#!/bin/bash
#
# Falco Cross-Compilation Build Script — Modern eBPF probe only
# Target: aarch64. Builds Falco with BUILD_MODERN_BPF=ON (no kernel module).
# Does not modify build_falco.sh; uses separate build_ebpf/ and install_ebpf/.
#
# Usage: ./build_falco_ebpf.sh [clean|configure|build|install|all]
#   all       - Full build (default)
#   configure - Configure CMake only
#   build     - Build only
#   install   - Install to install_ebpf
#   clean     - Remove build_ebpf and install_ebpf
#   fullclean - Clean including src (shared with build_falco.sh)

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Separate dirs so this script does not touch build_falco.sh output
BUILD_DIR="${SCRIPT_DIR}/build_ebpf"
INSTALL_DIR="${SCRIPT_DIR}/install_ebpf"
SRC_DIR="${SCRIPT_DIR}/src"
PATCHES_DIR="${SCRIPT_DIR}/patches"
CONFIG_FILE="${CONFIG_FILE:-${SCRIPT_DIR}/build.cfg}"

load_config() {
    if [[ -f "${CONFIG_FILE}" ]]; then
        while IFS='=' read -r key value; do
            [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs | sed 's/^["'\'']//;s/["'\'']$//')
            [[ -n "$key" && -n "$value" ]] && export "$key"="$value"
        done < "${CONFIG_FILE}"
    else
        echo -e "${RED}[ERROR]${NC} Configuration file not found: ${CONFIG_FILE}"
        exit 1
    fi
}

load_config

# Apply config with overrides for modern eBPF only (no kmod, no legacy driver/BPF)
SYSROOT="${SYSROOT:-/opt/ti-processor-sdk-linux-adas-j721e-evm-09_02_00_05/linux-devkit/sysroots/aarch64-oe-linux}"
CROSS_PREFIX="${CROSS_COMPILE_PREFIX:-/opt/cross-compile/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu}"
CROSS_TRIPLE="${CROSS_COMPILE_TRIPLE:-aarch64-none-linux-gnu}"
CMAKE_BUILD_TYPE="${BUILD_TYPE:-Release}"
STRIP_BINARY="${STRIP_BINARY:-ON}"
# Force modern eBPF; disable driver/kmod
BUILD_DRIVER="OFF"
BUILD_BPF="OFF"
BUILD_MODERN_BPF="ON"
MINIMAL_BUILD="${MINIMAL_BUILD:-OFF}"
BUILD_KMOD="OFF"
TOOLCHAIN_FILE="${SCRIPT_DIR}/toolchain-aarch64.cmake"

export CC="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-gcc"
export CXX="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-g++"
export AR="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-ar"
export RANLIB="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-ranlib"
export STRIP="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-strip"
export LD="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-ld"
export PATH="${CROSS_PREFIX}/bin:${PATH}"

JOBS="${JOBS:-$(nproc)}"

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

check_prerequisites() {
    log_info "Checking prerequisites (modern eBPF build)..."
    if [[ ! -d "${SYSROOT}" ]]; then
        log_error "Sysroot not found: ${SYSROOT}"
        exit 1
    fi
    if [[ ! -f "${CC}" ]]; then
        log_error "Cross-compiler not found: ${CC}"
        exit 1
    fi
    for cmd in cmake git make wget; do
        if ! command -v $cmd &>/dev/null; then
            log_error "$cmd is required but not installed"
            exit 1
        fi
    done
    if ! command -v clang &>/dev/null; then
        log_error "Modern eBPF build requires clang (for BPF compilation). Install: sudo apt-get install -y clang llvm"
        exit 1
    fi
    log_info "clang found: $(command -v clang)"
    log_success "Prerequisites check passed"
}

create_dirs() {
    log_info "Creating build directories..."
    mkdir -p "${BUILD_DIR}"
    mkdir -p "${INSTALL_DIR}"/{lib,include,bin}
    mkdir -p "${SRC_DIR}"
    mkdir -p "${PATCHES_DIR}"
}

apply_falco_openssl_cross_compile() {
    local openssl_cmake="${SRC_DIR}/falco/cmake/modules/openssl.cmake"
    [[ -f "${openssl_cmake}" ]] || return 0
    if grep -q "OPENSSL_CONFIGURE_CMD\|Configure linux-aarch64" "${openssl_cmake}" 2>/dev/null; then
        return 0
    fi
    local patch_file="${PATCHES_DIR}/fix_openssl_cross_compile.patch"
    if [[ -f "${patch_file}" ]]; then
        log_info "Patching Falco openssl.cmake for aarch64 cross-compilation"
        (cd "${SRC_DIR}/falco" && patch -p1 -s -f < "${patch_file}") || true
    fi
}

apply_falco_container_plugin_arch_fix() {
    local cmake_lists="${SRC_DIR}/falco/CMakeLists.txt"
    [[ -f "${cmake_lists}" ]] || return 0
    grep -q 'CONTAINER_PLUGIN_ARCH' "${cmake_lists}" && return 0
    log_info "Patching Falco: use target arch for container plugin (aarch64)"
    # Append CMake lines (single-quoted so ${CMAKE_SYSTEM_PROCESSOR} is literal in file)
    sed -i '/set(CONTAINER_VERSION "0.6.1")/a\
# Cross-compilation: use target arch for container plugin\
if(CMAKE_CROSSCOMPILING)\
  set(CONTAINER_PLUGIN_ARCH ${CMAKE_SYSTEM_PROCESSOR})\
else()\
  set(CONTAINER_PLUGIN_ARCH ${CMAKE_HOST_SYSTEM_PROCESSOR})\
endif()' "${cmake_lists}"
    sed -i 's/if(${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL "x86_64")/if(${CONTAINER_PLUGIN_ARCH} STREQUAL "x86_64")/' "${cmake_lists}"
}

clone_falco() {
    log_info "Cloning/updating Falco source..."
    if [[ -d "${SRC_DIR}/falco" ]]; then
        cd "${SRC_DIR}/falco"
        git fetch --tags
    else
        cd "${SRC_DIR}"
        git clone --depth 1 https://github.com/falcosecurity/falco.git
    fi
    cd "${SRC_DIR}/falco"
    git submodule update --init --recursive
    apply_falco_container_plugin_arch_fix
    apply_falco_openssl_cross_compile
    log_success "Falco source ready"
}

apply_patches() {
    log_info "Applying cross-compilation patches..."
    local LIBS_CMAKE="${BUILD_DIR}/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs/cmake/modules"
    if [[ ! -d "${LIBS_CMAKE}" ]]; then
        log_warning "Libs cmake modules not found yet"
        return
    fi
    if [[ -f "${LIBS_CMAKE}/tbb.cmake" ]] && ! grep -q "CMAKE_SYSTEM_PROCESSOR" "${LIBS_CMAKE}/tbb.cmake"; then
        log_info "Patching tbb.cmake..."
        sed -i 's/-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}/-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}\n\t\t\t\t\t\t   -DCMAKE_SYSROOT=${CMAKE_SYSROOT}/g' "${LIBS_CMAKE}/tbb.cmake"
    fi
    if [[ -f "${LIBS_CMAKE}/zlib.cmake" ]] && ! grep -q 'env "CC=\${CMAKE_C_COMPILER}"' "${LIBS_CMAKE}/zlib.cmake"; then
        log_info "Patching zlib.cmake..."
        sed -i 's/CONFIGURE_COMMAND env "CFLAGS=\${ZLIB_CFLAGS}"/CONFIGURE_COMMAND env "CC=${CMAKE_C_COMPILER}" "AR=${CMAKE_AR}" "RANLIB=${CMAKE_RANLIB}" "CFLAGS=${ZLIB_CFLAGS} --sysroot=${CMAKE_SYSROOT}"/g' "${LIBS_CMAKE}/zlib.cmake"
    fi
    if [[ -f "${LIBS_CMAKE}/jsoncpp.cmake" ]] && ! grep -q "CMAKE_SYSTEM_PROCESSOR" "${LIBS_CMAKE}/jsoncpp.cmake"; then
        log_info "Patching jsoncpp.cmake..."
        sed -i 's/-DCMAKE_INSTALL_LIBDIR=lib$/-DCMAKE_INSTALL_LIBDIR=lib\n\t\t\t\t\t\t   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}\n\t\t\t\t\t\t   -DCMAKE_SYSROOT=${CMAKE_SYSROOT}/g' "${LIBS_CMAKE}/jsoncpp.cmake"
    fi
    if [[ -f "${LIBS_CMAKE}/re2.cmake" ]] && ! grep -q "CMAKE_SYSTEM_PROCESSOR" "${LIBS_CMAKE}/re2.cmake"; then
        log_info "Patching re2.cmake..."
        sed -i 's/-DCMAKE_BUILD_TYPE=\${CMAKE_BUILD_TYPE}$/-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}\n\t\t\t\t\t\t   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}\n\t\t\t\t\t\t   -DCMAKE_SYSROOT=${CMAKE_SYSROOT}/g' "${LIBS_CMAKE}/re2.cmake"
    fi
    local CONTAINER_CMAKE="${LIBS_CMAKE}/container_plugin.cmake"
    if [[ -f "${CONTAINER_CMAKE}" ]] && ! grep -q "CONTAINER_PLUGIN_ARCH" "${CONTAINER_CMAKE}"; then
        log_info "Patching container_plugin.cmake..."
        sed -i 's/\${CMAKE_HOST_SYSTEM_PROCESSOR}\.tar\.gz/\${CONTAINER_PLUGIN_ARCH}.tar.gz/g' "${CONTAINER_CMAKE}"
        local CP_PREFIX="${BUILD_DIR}/falco/container_plugin-prefix"
        [[ -d "${CP_PREFIX}" ]] && rm -rf "${CP_PREFIX}/src/container_plugin" "${CP_PREFIX}/src/container_plugin-stamp" 2>/dev/null || true
    fi
    # libbpf cross-compile: use bundled libelf headers instead of sysroot elf.h (avoid Elf32_Verdef conflict)
    local LIBBPF_CMAKE="${LIBS_CMAKE}/libbpf.cmake"
    if [[ -f "${LIBBPF_CMAKE}" ]] && ! grep -q "idirafter.*CMAKE_SYSROOT" "${LIBBPF_CMAKE}"; then
        log_info "Patching libbpf.cmake: -idirafter sysroot so bundled libelf elf.h is used"
        sed -i 's|EXTRA_CFLAGS=-fPIC \${LIBELF_COMPILER_STRING}|EXTRA_CFLAGS=-fPIC -idirafter ${CMAKE_SYSROOT}/usr/include ${LIBELF_COMPILER_STRING}|g' "${LIBBPF_CMAKE}"
        # Force falcosecurity-libs to reconfigure (so libbpf BUILD_COMMAND uses new flags) and libbpf to rebuild
        rm -f "${BUILD_DIR}/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs-stamp/falcosecurity-libs-configure" \
              "${BUILD_DIR}/falco/libbpf-prefix/src/libbpf-stamp/libbpf-build" \
              "${BUILD_DIR}/falco/libbpf-prefix/src/libbpf-stamp/libbpf-configure" 2>/dev/null || true
    fi
    log_success "Patches applied"
}

ensure_bpftool() {
    if command -v bpftool &>/dev/null && bpftool help 2>&1 | grep -qw gen; then
        BPFTOOL_EXE="$(command -v bpftool)"
        log_success "Using system bpftool: ${BPFTOOL_EXE}"
        return
    fi
    local bpftool_build="${BUILD_DIR}/bpftool-build"
    local bpftool_bin="${bpftool_build}/src/bootstrap/bpftool"
    if [[ -x "${bpftool_bin}" ]]; then
        BPFTOOL_EXE="${bpftool_bin}"
        log_success "Using built bpftool: ${BPFTOOL_EXE}"
        return
    fi
    if ! pkg-config --exists libelf 2>/dev/null; then
        log_error "Modern eBPF requires host libelf. Install: sudo apt-get install -y libelf-dev zlib1g-dev"
        exit 1
    fi
    log_info "Building bpftool..."
    mkdir -p "${BUILD_DIR}"
    if [[ ! -d "${bpftool_build}/.git" ]]; then
        git clone --depth 1 https://github.com/libbpf/bpftool.git "${bpftool_build}"
        (cd "${bpftool_build}" && git submodule update --init --recursive)
    fi
    if ! (cd "${bpftool_build}/src" && make bootstrap -j"${JOBS}" 2>&1); then
        log_error "bpftool build failed. Install: sudo apt-get install -y bpftool (if available)"
        exit 1
    fi
    [[ -x "${bpftool_bin}" ]] && BPFTOOL_EXE="${bpftool_bin}" && log_success "bpftool built: ${BPFTOOL_EXE}" || { log_error "bpftool binary not found"; exit 1; }
}

configure_falco() {
    log_info "Configuring Falco (modern eBPF only)..."
    BPFTOOL_EXE=""
    ensure_bpftool

    mkdir -p "${BUILD_DIR}/falco"
    cd "${BUILD_DIR}/falco"

    [[ "${MINIMAL_BUILD}" == "ON" ]] && CMAKE_MINIMAL_BUILD="ON" || CMAKE_MINIMAL_BUILD="OFF"
    local cmake_extra=()
    [[ -n "${BPFTOOL_EXE}" ]] && cmake_extra+=(-DMODERN_BPFTOOL_EXE="${BPFTOOL_EXE}")

    cmake "${SRC_DIR}/falco" \
        -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
        -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" \
        -DUSE_BUNDLED_DEPS=ON \
        -DBUILD_DRIVER=OFF \
        -DBUILD_BPF=OFF \
        -DBUILD_LIBSCAP_MODERN_BPF=ON \
        -DBUILD_FALCO_MODERN_BPF=ON \
        -DBUILD_LIBSCAP_GVISOR=OFF \
        -DCREATE_TEST_TARGETS=OFF \
        -DMINIMAL_BUILD="${CMAKE_MINIMAL_BUILD}" \
        -DBUILD_FALCO_UNIT_TESTS=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        "${cmake_extra[@]}" \
        2>&1 | tee "${BUILD_DIR}/falco_cmake.log"

    apply_patches

    log_info "Reconfiguring after patches..."
    cmake "${SRC_DIR}/falco" \
        -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
        -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" \
        -DUSE_BUNDLED_DEPS=ON \
        -DBUILD_DRIVER=OFF \
        -DBUILD_BPF=OFF \
        -DBUILD_LIBSCAP_MODERN_BPF=ON \
        -DBUILD_FALCO_MODERN_BPF=ON \
        -DBUILD_LIBSCAP_GVISOR=OFF \
        -DCREATE_TEST_TARGETS=OFF \
        -DMINIMAL_BUILD="${CMAKE_MINIMAL_BUILD}" \
        -DBUILD_FALCO_UNIT_TESTS=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        "${cmake_extra[@]}" \
        2>&1 | tee -a "${BUILD_DIR}/falco_cmake.log"

    log_success "CMake configuration complete"
}

build_falco() {
    log_info "Building Falco..."
    cd "${BUILD_DIR}/falco"
    make -j${JOBS} 2>&1 | tee "${BUILD_DIR}/falco_build.log"
    if [[ ${PIPESTATUS[0]} -eq 0 ]]; then
        log_success "Falco built successfully!"
    else
        log_error "Build failed. Check ${BUILD_DIR}/falco_build.log"
        if grep -q "events_dimensions_generator" "${BUILD_DIR}/falco_build.log" 2>/dev/null; then
            echo ""
            log_warning "Known limitation: falcosecurity-libs needs host-built events_dimensions_generator for modern BPF; cross-compile builds it for target so it cannot run on host."
            echo "  Workaround: use build_falco.sh with BUILD_KMOD=ON for board (engine.kind: kmod + falco.ko). See cross_compile/README.md."
        fi
        exit 1
    fi
}

install_falco() {
    log_info "Installing Falco to ${INSTALL_DIR}..."
    cd "${BUILD_DIR}/falco"
    make install
    if [[ "${STRIP_BINARY}" == "ON" ]]; then
        log_info "Stripping binary..."
        ${STRIP} -s "${INSTALL_DIR}/bin/falco"
    fi
    local BINARY_SIZE=$(du -h "${INSTALL_DIR}/bin/falco" | cut -f1)
    log_success "Falco (modern eBPF) installed to ${INSTALL_DIR}/bin/falco (${BINARY_SIZE})"
    file "${INSTALL_DIR}/bin/falco"
}

clean_build() {
    log_info "Cleaning build_ebpf and install_ebpf..."
    rm -rf "${BUILD_DIR}" "${INSTALL_DIR}"
    log_success "Cleaned"
}

full_clean() {
    log_info "Full clean (including src)..."
    rm -rf "${BUILD_DIR}" "${INSTALL_DIR}" "${SRC_DIR}"
    log_success "All cleaned"
}

show_help() {
    echo "Falco Cross-Compilation — Modern eBPF only (build_falco_ebpf.sh)"
    echo "Uses build_ebpf/ and install_ebpf/ (does not touch build_falco.sh output)."
    echo ""
    echo "Usage: $0 [command]"
    echo "  all       - Full build (default)"
    echo "  configure - Configure CMake only"
    echo "  build     - Build only"
    echo "  install   - Install to install_ebpf"
    echo "  clean     - Remove build_ebpf and install_ebpf"
    echo "  fullclean - Clean including src"
    echo "  help      - Show this help"
    echo ""
    echo "Output: ${INSTALL_DIR}/bin/falco"
    echo "On board: set engine.kind: modern_ebpf (no falco.ko needed; kernel needs BTF, typically 5.8+)."
    echo ""
    echo "Note: Cross-compiling modern eBPF may fail with 'events_dimensions_generator: not found'"
    echo "      (falcosecurity-libs builds the generator for target, so it cannot run on host)."
    echo "      For board use, build_falco.sh with BUILD_KMOD=ON is the tested path (kmod + falco.ko)."
}

main() {
    local command="${1:-all}"
    case "${command}" in
        all)
            check_prerequisites
            create_dirs
            clone_falco
            configure_falco
            build_falco
            install_falco
            ;;
        configure)
            check_prerequisites
            create_dirs
            clone_falco
            configure_falco
            ;;
        build)
            check_prerequisites
            build_falco
            ;;
        install)
            check_prerequisites
            install_falco
            ;;
        clean)
            clean_build
            ;;
        fullclean)
            full_clean
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Unknown command: ${command}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
