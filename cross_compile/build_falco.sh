#!/bin/bash
#
# Falco Cross-Compilation Build Script
# Target: aarch64
# 
# Usage: ./build_falco.sh [clean|configure|build|install|all]
#   clean     - Clean all build artifacts
#   configure - Configure CMake only
#   build     - Build only (requires configure first)
#   install   - Install to install directory
#   all       - Full build (default)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
INSTALL_DIR="${SCRIPT_DIR}/install"
SRC_DIR="${SCRIPT_DIR}/src"
PATCHES_DIR="${SCRIPT_DIR}/patches"
# Allow caller to pass config via env (e.g. BSP build_falco.sh)
CONFIG_FILE="${CONFIG_FILE:-${SCRIPT_DIR}/build.cfg}"

# Load configuration from build.cfg
load_config() {
    if [[ -f "${CONFIG_FILE}" ]]; then
        # Source the config file (only lines with valid variable assignments)
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^#.*$ ]] && continue
            [[ -z "$key" ]] && continue
            # Remove leading/trailing whitespace and quotes
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs | sed 's/^["'\'']//;s/["'\'']$//')
            # Export the variable
            if [[ -n "$key" && -n "$value" ]]; then
                export "$key"="$value"
            fi
        done < "${CONFIG_FILE}"
    else
        echo -e "${RED}[ERROR]${NC} Configuration file not found: ${CONFIG_FILE}"
        echo "Please create build.cfg with SYSROOT and CROSS_COMPILE_PREFIX settings."
        exit 1
    fi
}

# Load configuration
load_config

# Apply configuration with defaults
SYSROOT="${SYSROOT:-/opt/ti-processor-sdk-linux-adas-j721e-evm-09_02_00_05/linux-devkit/sysroots/aarch64-oe-linux}"
CROSS_PREFIX="${CROSS_COMPILE_PREFIX:-/opt/cross-compile/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu}"
CROSS_TRIPLE="${CROSS_COMPILE_TRIPLE:-aarch64-none-linux-gnu}"
CMAKE_BUILD_TYPE="${BUILD_TYPE:-Release}"
STRIP_BINARY="${STRIP_BINARY:-ON}"
BUILD_DRIVER="${BUILD_DRIVER:-OFF}"
BUILD_BPF="${BUILD_BPF:-OFF}"
BUILD_MODERN_BPF="${BUILD_MODERN_BPF:-OFF}"
MINIMAL_BUILD="${MINIMAL_BUILD:-ON}"
BUILD_KMOD="${BUILD_KMOD:-OFF}"
# Expand LINUX_KERNEL_SRC (e.g. ~/work/tda4-bsp/...) for use in commands
LINUX_KERNEL_SRC="${LINUX_KERNEL_SRC:-}"
[[ -n "${LINUX_KERNEL_SRC}" ]] && LINUX_KERNEL_SRC="$(eval echo "${LINUX_KERNEL_SRC}")"

TOOLCHAIN_FILE="${SCRIPT_DIR}/toolchain-aarch64.cmake"

# Export cross-compiler environment
export CC="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-gcc"
export CXX="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-g++"
export AR="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-ar"
export RANLIB="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-ranlib"
export STRIP="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-strip"
export LD="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-ld"
export PATH="${CROSS_PREFIX}/bin:${PATH}"

# Number of parallel jobs
JOBS="${JOBS:-$(nproc)}"

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if [[ ! -d "${SYSROOT}" ]]; then
        log_error "Sysroot not found: ${SYSROOT}"
        exit 1
    fi
    
    if [[ ! -f "${CC}" ]]; then
        log_error "Cross-compiler not found: ${CC}"
        exit 1
    fi
    
    for cmd in cmake git make wget; do
        if ! command -v $cmd &> /dev/null; then
            log_error "$cmd is required but not installed"
            exit 1
        fi
    done
    
    # When building modern eBPF, host clang is required to compile BPF programs (CO-RE)
    if [[ "${BUILD_MODERN_BPF}" == "ON" ]]; then
        if ! command -v clang &> /dev/null; then
            log_error "BUILD_MODERN_BPF=ON requires clang (for BPF compilation). Install and re-run:"
            echo "  sudo apt-get install -y clang llvm"
            exit 1
        fi
        log_info "clang found: $(command -v clang) (required for modern BPF)"
    fi
    
    log_success "Prerequisites check passed"
}

# Create directories
create_dirs() {
    log_info "Creating build directories..."
    mkdir -p "${BUILD_DIR}"
    mkdir -p "${INSTALL_DIR}"/{lib,include,bin}
    mkdir -p "${SRC_DIR}"
    mkdir -p "${PATCHES_DIR}"
}

# Clone or update Falco
clone_falco() {
    log_info "Cloning/updating Falco source..."
    
    if [[ -d "${SRC_DIR}/falco" ]]; then
        log_info "Falco source exists, updating..."
        cd "${SRC_DIR}/falco"
        git fetch --tags
    else
        cd "${SRC_DIR}"
        git clone --depth 1 https://github.com/falcosecurity/falco.git
    fi
    
    # Initialize submodules
    cd "${SRC_DIR}/falco"
    git submodule update --init --recursive
    
    apply_falco_container_plugin_arch_fix
    apply_falco_openssl_cross_compile
    log_success "Falco source ready"
}

# OpenSSL: use Configure linux-aarch64 when cross-compiling (avoid ./config which adds -m64 for x86_64)
apply_falco_openssl_cross_compile() {
    local openssl_cmake="${SRC_DIR}/falco/cmake/modules/openssl.cmake"
    [[ -f "${openssl_cmake}" ]] || return 0
    if grep -q "OPENSSL_CONFIGURE_CMD\|Configure linux-aarch64" "${openssl_cmake}" 2>/dev/null; then
        return 0
    fi
    local patch_file="${PATCHES_DIR}/fix_openssl_cross_compile.patch"
    if [[ -f "${patch_file}" ]]; then
        log_info "Patching Falco openssl.cmake for aarch64 cross-compilation (OpenSSL Configure)"
        (cd "${SRC_DIR}/falco" && patch -p1 -s -f < "${patch_file}") || true
        if grep -q "OPENSSL_CONFIGURE_CMD" "${openssl_cmake}" 2>/dev/null; then
            log_success "OpenSSL will use Configure linux-aarch64 for cross-compilation"
        else
            log_warning "OpenSSL patch may have failed; if build fails with -m64, apply fix_openssl_cross_compile.patch manually"
        fi
    fi
}

# Fix container plugin arch: Falco uses CMAKE_HOST_SYSTEM_PROCESSOR to pick prebuilt
# libcontainer.so, so on x86_64 host cross-compiling for aarch64 we get x86_64 .so.
# Use target arch (CMAKE_SYSTEM_PROCESSOR) when cross-compiling.
apply_falco_container_plugin_arch_fix() {
    local cmake_lists="${SRC_DIR}/falco/CMakeLists.txt"
    [[ -f "${cmake_lists}" ]] || return 0
    grep -q 'CONTAINER_PLUGIN_ARCH' "${cmake_lists}" && return 0
    log_info "Patching Falco: use target arch for container plugin (aarch64)"
    # Insert CONTAINER_PLUGIN_ARCH logic after set(CONTAINER_VERSION "0.6.1")
    # Use \$ in sed so CMake receives ${CMAKE_SYSTEM_PROCESSOR} literally
    sed -i '/set(CONTAINER_VERSION "0.6.1")/a\
# Cross-compilation: use target arch for container plugin (upstream uses host -> wrong .so)\
if(CMAKE_CROSSCOMPILING)\
  set(CONTAINER_PLUGIN_ARCH \$'{CMAKE_SYSTEM_PROCESSOR}')\
else()\
  set(CONTAINER_PLUGIN_ARCH \$'{CMAKE_HOST_SYSTEM_PROCESSOR}')\
endif()' "${cmake_lists}"
    sed -i 's/if(${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL "x86_64")/if(${CONTAINER_PLUGIN_ARCH} STREQUAL "x86_64")/' "${cmake_lists}"
    log_success "Container plugin will be downloaded for target arch (aarch64)"
}

# Apply cross-compilation patches to libs cmake modules
apply_patches() {
    log_info "Applying cross-compilation patches..."
    
    local LIBS_CMAKE="${BUILD_DIR}/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs/cmake/modules"
    
    if [[ ! -d "${LIBS_CMAKE}" ]]; then
        log_warning "Libs cmake modules not found yet, patches will be applied after CMake configure"
        return
    fi
    
    # Patch tbb.cmake
    if [[ -f "${LIBS_CMAKE}/tbb.cmake" ]]; then
        if ! grep -q "CMAKE_SYSTEM_PROCESSOR" "${LIBS_CMAKE}/tbb.cmake"; then
            log_info "Patching tbb.cmake for cross-compilation..."
            sed -i 's/-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}/-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}\n\t\t\t\t\t\t   -DCMAKE_SYSROOT=${CMAKE_SYSROOT}/g' "${LIBS_CMAKE}/tbb.cmake"
        fi
    fi
    
    # Patch zlib.cmake
    if [[ -f "${LIBS_CMAKE}/zlib.cmake" ]]; then
        if ! grep -q 'env "CC=\${CMAKE_C_COMPILER}"' "${LIBS_CMAKE}/zlib.cmake"; then
            log_info "Patching zlib.cmake for cross-compilation..."
            sed -i 's/CONFIGURE_COMMAND env "CFLAGS=\${ZLIB_CFLAGS}"/CONFIGURE_COMMAND env "CC=${CMAKE_C_COMPILER}" "AR=${CMAKE_AR}" "RANLIB=${CMAKE_RANLIB}" "CFLAGS=${ZLIB_CFLAGS} --sysroot=${CMAKE_SYSROOT}"/g' "${LIBS_CMAKE}/zlib.cmake"
        fi
    fi
    
    # Patch jsoncpp.cmake
    if [[ -f "${LIBS_CMAKE}/jsoncpp.cmake" ]]; then
        if ! grep -q "CMAKE_SYSTEM_PROCESSOR" "${LIBS_CMAKE}/jsoncpp.cmake"; then
            log_info "Patching jsoncpp.cmake for cross-compilation..."
            sed -i 's/-DCMAKE_INSTALL_LIBDIR=lib$/-DCMAKE_INSTALL_LIBDIR=lib\n\t\t\t\t\t\t   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}\n\t\t\t\t\t\t   -DCMAKE_SYSROOT=${CMAKE_SYSROOT}/g' "${LIBS_CMAKE}/jsoncpp.cmake"
        fi
    fi
    
    # Patch re2.cmake
    if [[ -f "${LIBS_CMAKE}/re2.cmake" ]]; then
        if ! grep -q "CMAKE_SYSTEM_PROCESSOR" "${LIBS_CMAKE}/re2.cmake"; then
            log_info "Patching re2.cmake for cross-compilation..."
            sed -i 's/-DCMAKE_BUILD_TYPE=\${CMAKE_BUILD_TYPE}$/-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}\n\t\t\t\t\t\t   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}\n\t\t\t\t\t\t   -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}\n\t\t\t\t\t\t   -DCMAKE_SYSROOT=${CMAKE_SYSROOT}/g' "${LIBS_CMAKE}/re2.cmake"
        fi
    fi

    # container_plugin.cmake (in falcosecurity-libs) uses CMAKE_HOST_SYSTEM_PROCESSOR in the
    # download URL -> wrong arch. Use CONTAINER_PLUGIN_ARCH (set in Falco CMakeLists for cross-compile).
    local CONTAINER_CMAKE="${LIBS_CMAKE}/container_plugin.cmake"
    if [[ -f "${CONTAINER_CMAKE}" ]]; then
        if ! grep -q "CONTAINER_PLUGIN_ARCH" "${CONTAINER_CMAKE}"; then
            log_info "Patching container_plugin.cmake: use CONTAINER_PLUGIN_ARCH for download URL"
            sed -i 's/\${CMAKE_HOST_SYSTEM_PROCESSOR}\.tar\.gz/\${CONTAINER_PLUGIN_ARCH}.tar.gz/g' "${CONTAINER_CMAKE}"
            log_success "container_plugin URL will use target arch"
        fi
        # Force re-download with correct URL (remove cached x86_64 download)
        local CP_PREFIX="${BUILD_DIR}/falco/container_plugin-prefix"
        if [[ -d "${CP_PREFIX}" ]]; then
            log_info "Removing container_plugin download cache so reconfigure fetches aarch64"
            rm -rf "${CP_PREFIX}/src/container_plugin" "${CP_PREFIX}/src/container_plugin-stamp" 2>/dev/null || true
        fi
    fi

    log_success "Patches applied"
}

# When BUILD_MODERN_BPF=ON, ensure bpftool is available for falcosecurity-libs (gen skeleton).
# Sets BPFTOOL_EXE for use in configure_falco. Uses system bpftool if present, else builds from source.
ensure_bpftool() {
    if command -v bpftool &>/dev/null; then
        if bpftool help 2>&1 | grep -qw gen; then
            BPFTOOL_EXE="$(command -v bpftool)"
            log_success "Using system bpftool: ${BPFTOOL_EXE}"
            return
        fi
    fi
    local bpftool_build="${BUILD_DIR}/bpftool-build"
    local bpftool_bin="${bpftool_build}/src/bootstrap/bpftool"
    if [[ -x "${bpftool_bin}" ]]; then
        BPFTOOL_EXE="${bpftool_bin}"
        log_success "Using built bpftool: ${BPFTOOL_EXE}"
        return
    fi
    # Building bpftool from source needs libelf (libelf-dev) and zlib (zlib1g-dev) on the host.
    if ! pkg-config --exists libelf 2>/dev/null; then
        local apt_deps="${bpftool_build}/apt-deps"
        mkdir -p "${BUILD_DIR}" "${apt_deps}"
        log_info "Trying to fetch libelf/zlib via apt-get download (no sudo)..."
        (cd "${BUILD_DIR}" && mkdir -p apt-download && cd apt-download \
            && apt-get update -qq 2>/dev/null && apt-get download libelf-dev zlib1g-dev 2>/dev/null) || true
        for deb in "${BUILD_DIR}"/apt-download/*.deb; do
            [[ -f "${deb}" ]] && dpkg -x "${deb}" "${apt_deps}" 2>/dev/null || true
        done
        for pcdir in "${apt_deps}/usr/lib/x86_64-linux-gnu/pkgconfig" "${apt_deps}/usr/lib/pkgconfig"; do
            if [[ -d "${pcdir}" ]] && [[ -f "${pcdir}/libelf.pc" ]]; then
                export PKG_CONFIG_PATH="${pcdir}${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"
                break
            fi
        done
        if ! pkg-config --exists libelf 2>/dev/null; then
            log_error "BUILD_MODERN_BPF=ON requires host libelf. Install and re-run:"
            echo "  sudo apt-get install -y libelf-dev zlib1g-dev"
            echo "Then either install bpftool (sudo apt-get install -y bpftool) or let this script build it."
            exit 1
        fi
    fi
    log_info "Building bpftool (required for modern BPF)..."
    mkdir -p "${BUILD_DIR}"
    if [[ ! -d "${bpftool_build}/.git" ]]; then
        git clone --depth 1 https://github.com/libbpf/bpftool.git "${bpftool_build}"
        (cd "${bpftool_build}" && git submodule update --init --recursive)
    fi
    if ! (cd "${bpftool_build}/src" && make bootstrap -j"${JOBS}" 2>&1); then
        log_error "bpftool build failed. Install bpftool: sudo apt-get install -y bpftool (if available), then re-run."
        exit 1
    fi
    if [[ -x "${bpftool_bin}" ]]; then
        BPFTOOL_EXE="${bpftool_bin}"
        log_success "bpftool built: ${BPFTOOL_EXE}"
    else
        log_error "bpftool binary not found after build. Install: sudo apt-get install -y bpftool"
        exit 1
    fi
}

# Configure Falco
configure_falco() {
    log_info "Configuring Falco with CMake..."
    
    BPFTOOL_EXE=""
    if [[ "${BUILD_MODERN_BPF}" == "ON" ]]; then
        ensure_bpftool
    fi
    
    mkdir -p "${BUILD_DIR}/falco"
    cd "${BUILD_DIR}/falco"
    
    # Convert ON/OFF to CMake boolean
    [[ "${BUILD_DRIVER}" == "ON" ]] && CMAKE_BUILD_DRIVER="ON" || CMAKE_BUILD_DRIVER="OFF"
    [[ "${BUILD_BPF}" == "ON" ]] && CMAKE_BUILD_BPF="ON" || CMAKE_BUILD_BPF="OFF"
    [[ "${BUILD_MODERN_BPF}" == "ON" ]] && CMAKE_BUILD_MODERN_BPF="ON" || CMAKE_BUILD_MODERN_BPF="OFF"
    [[ "${MINIMAL_BUILD}" == "ON" ]] && CMAKE_MINIMAL_BUILD="ON" || CMAKE_MINIMAL_BUILD="OFF"
    
    local cmake_extra=()
    [[ -n "${BPFTOOL_EXE}" ]] && cmake_extra+=(-DMODERN_BPFTOOL_EXE="${BPFTOOL_EXE}")
    
    cmake "${SRC_DIR}/falco" \
        -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
        -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" \
        -DUSE_BUNDLED_DEPS=ON \
        -DBUILD_DRIVER="${CMAKE_BUILD_DRIVER}" \
        -DBUILD_BPF="${CMAKE_BUILD_BPF}" \
        -DBUILD_LIBSCAP_MODERN_BPF="${CMAKE_BUILD_MODERN_BPF}" \
        -DBUILD_FALCO_MODERN_BPF="${CMAKE_BUILD_MODERN_BPF}" \
        -DBUILD_LIBSCAP_GVISOR=OFF \
        -DCREATE_TEST_TARGETS=OFF \
        -DMINIMAL_BUILD="${CMAKE_MINIMAL_BUILD}" \
        -DBUILD_FALCO_UNIT_TESTS=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        "${cmake_extra[@]}" \
        2>&1 | tee "${BUILD_DIR}/falco_cmake.log"
    
    # Apply patches after initial cmake (libs are downloaded during cmake)
    apply_patches
    
    # Reconfigure after patches
    log_info "Reconfiguring after patches..."
    cmake "${SRC_DIR}/falco" \
        -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
        -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" \
        -DUSE_BUNDLED_DEPS=ON \
        -DBUILD_DRIVER="${CMAKE_BUILD_DRIVER}" \
        -DBUILD_BPF="${CMAKE_BUILD_BPF}" \
        -DBUILD_LIBSCAP_MODERN_BPF="${CMAKE_BUILD_MODERN_BPF}" \
        -DBUILD_FALCO_MODERN_BPF="${CMAKE_BUILD_MODERN_BPF}" \
        -DBUILD_LIBSCAP_GVISOR=OFF \
        -DCREATE_TEST_TARGETS=OFF \
        -DMINIMAL_BUILD="${CMAKE_MINIMAL_BUILD}" \
        -DBUILD_FALCO_UNIT_TESTS=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        "${cmake_extra[@]}" \
        2>&1 | tee -a "${BUILD_DIR}/falco_cmake.log"
    
    log_success "CMake configuration complete"
}

# Build Falco
build_falco() {
    log_info "Building Falco..."
    
    cd "${BUILD_DIR}/falco"
    
    make -j${JOBS} 2>&1 | tee "${BUILD_DIR}/falco_build.log"
    
    if [[ ${PIPESTATUS[0]} -eq 0 ]]; then
        log_success "Falco built successfully!"
    else
        log_error "Falco build failed. Check ${BUILD_DIR}/falco_build.log"
        exit 1
    fi
}

# Install Falco
install_falco() {
    log_info "Installing Falco..."
    
    cd "${BUILD_DIR}/falco"
    make install
    
    # Strip the binary if configured
    if [[ "${STRIP_BINARY}" == "ON" ]]; then
        log_info "Stripping binary for smaller size..."
        ${STRIP} -s "${INSTALL_DIR}/bin/falco"
    fi
    
    local BINARY_SIZE=$(du -h "${INSTALL_DIR}/bin/falco" | cut -f1)
    log_success "Falco installed to ${INSTALL_DIR}/bin/falco (${BINARY_SIZE})"
    if [[ -f "${BUILD_DIR}/falco/falco.ko" ]]; then
        mkdir -p "${INSTALL_DIR}/share/falco"
        cp -f "${BUILD_DIR}/falco/falco.ko" "${INSTALL_DIR}/share/falco/falco.ko"
        log_success "falco.ko installed to ${INSTALL_DIR}/share/falco/falco.ko"
    fi
    log_info "Binary info:"
    file "${INSTALL_DIR}/bin/falco"
}

# Build Falco kernel module (falco.ko) against target kernel tree.
# Requires: BUILD_KMOD=ON, LINUX_KERNEL_SRC set, and Falco configured (libs source present).
# When BUILD_MODERN_BPF=OFF, set BUILD_KMOD=ON (and LINUX_KERNEL_SRC) to build falco.ko for engine.kind: kmod on board.
# Skipped when BUILD_KMOD=OFF or LINUX_KERNEL_SRC missing (warning only, "all" still produces binary).
build_falco_kmod() {
    [[ "${BUILD_KMOD}" != "ON" ]] && return 0
    if [[ -z "${LINUX_KERNEL_SRC}" ]]; then
        log_warning "BUILD_KMOD=ON but LINUX_KERNEL_SRC not set; skipping falco.ko (set LINUX_KERNEL_SRC in build.cfg to build .ko)"
        return 0
    fi
    LINUX_KERNEL_SRC="$(eval echo "${LINUX_KERNEL_SRC}")"
    if [[ ! -d "${LINUX_KERNEL_SRC}" ]]; then
        log_warning "LINUX_KERNEL_SRC not found: ${LINUX_KERNEL_SRC}; skipping falco.ko (binary will still be installed)"
        return 0
    fi
    if [[ ! -f "${LINUX_KERNEL_SRC}/Makefile" ]]; then
        log_warning "LINUX_KERNEL_SRC does not look like a kernel tree (no Makefile): ${LINUX_KERNEL_SRC}; skipping falco.ko"
        return 0
    fi
    log_info "Building falco.ko against kernel: ${LINUX_KERNEL_SRC}"
    LIBS_SRC=""
    for candidate in \
        "${BUILD_DIR}/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs" \
        "${BUILD_DIR}/falco/_deps/falcosecurity-libs-src" \
        "${SRC_DIR}/falco/build/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs"; do
        if [[ -d "${candidate}" && -f "${candidate}/driver/CMakeLists.txt" ]]; then
            LIBS_SRC="${candidate}"
            break
        fi
    done
    if [[ -z "${LIBS_SRC}" ]]; then
        log_error "falcosecurity-libs source not found. Run 'configure' first so that Falco fetches libs."
        exit 1
    fi
    KMOD_BUILD="${BUILD_DIR}/falco/libs-driver-build"
    mkdir -p "${KMOD_BUILD}"
    cd "${KMOD_BUILD}"
    log_info "Configuring Falco driver (DRIVER_NAME=falco)..."
    cmake "${LIBS_SRC}" \
        -DUSE_BUNDLED_DRIVER=ON \
        -DBUILD_DRIVER=ON \
        -DDRIVER_NAME=falco \
        -DDRIVER_DEVICE_NAME=falco \
        -DCREATE_TEST_TARGETS=OFF \
        -DCMAKE_BUILD_TYPE=Release \
        2>&1 | tee "${BUILD_DIR}/falco_kmod_cmake.log" || true
    DRIVER_SRC="${KMOD_BUILD}/driver/src"
    if [[ ! -f "${DRIVER_SRC}/Makefile" ]]; then
        log_error "Driver Makefile not generated at ${DRIVER_SRC}. Check ${BUILD_DIR}/falco_kmod_cmake.log"
        exit 1
    fi
    # Patch configure Makefiles so submakes get ARCH=arm64 and CROSS_COMPILE
    CROSS_COMPILE_VAL="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-"
    find "${DRIVER_SRC}/configure" -name Makefile -print0 | xargs -0 sed -i 's|$(MAKE) -C $(KERNELDIR) M=$(TOP) |$(MAKE) -C $(KERNELDIR) M=$(TOP) ARCH=arm64 CROSS_COMPILE='"${CROSS_COMPILE_VAL}"' |g'
    log_info "Compiling kernel module (ARCH=arm64, CROSS_COMPILE)..."
    export ARCH=arm64
    export CROSS_COMPILE="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-"
    make -C "${LINUX_KERNEL_SRC}" \
        M="${DRIVER_SRC}" \
        ARCH=arm64 \
        CROSS_COMPILE="${CROSS_PREFIX}/bin/${CROSS_TRIPLE}-" \
        modules \
        2>&1 | tee "${BUILD_DIR}/falco_kmod_build.log"
    if [[ ! -f "${DRIVER_SRC}/falco.ko" ]]; then
        log_error "falco.ko was not produced. Check ${BUILD_DIR}/falco_kmod_build.log"
        exit 1
    fi
    cp -f "${DRIVER_SRC}/falco.ko" "${BUILD_DIR}/falco/falco.ko"
    log_success "falco.ko built: ${BUILD_DIR}/falco/falco.ko"
}

# Clean build
clean_build() {
    log_info "Cleaning build directories..."
    rm -rf "${BUILD_DIR}"
    rm -rf "${INSTALL_DIR}"
    log_success "Build directories cleaned"
}

# Full clean (including sources)
full_clean() {
    log_info "Full clean (including sources)..."
    rm -rf "${BUILD_DIR}"
    rm -rf "${INSTALL_DIR}"
    rm -rf "${SRC_DIR}"
    log_success "All directories cleaned"
}

# Show help
show_help() {
    echo "Falco Cross-Compilation Build Script for TI J721E (ARM64)"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  all       - Full build (default)"
    echo "  configure - Configure CMake only"
    echo "  build     - Build only (requires configure)"
    echo "  install   - Install to install directory"
    echo "  clean     - Clean build artifacts"
    echo "  fullclean - Clean everything including sources"
    echo "  help      - Show this help"
    echo ""
    echo "Configuration (from build.cfg):"
    echo "  SYSROOT:           ${SYSROOT}"
    echo "  CROSS_PREFIX:      ${CROSS_PREFIX}"
    echo "  CROSS_TRIPLE:      ${CROSS_TRIPLE}"
    echo "  BUILD_TYPE:        ${CMAKE_BUILD_TYPE}"
    echo "  STRIP_BINARY:      ${STRIP_BINARY}"
    echo "  MINIMAL_BUILD:     ${MINIMAL_BUILD}"
    echo "  BUILD_MODERN_BPF:  ${BUILD_MODERN_BPF} (ON = no .ko needed, use engine.kind: modern_ebpf on board)"
    echo "  BUILD_KMOD:        ${BUILD_KMOD} (ON + LINUX_KERNEL_SRC => build falco.ko when BUILD_MODERN_BPF=OFF)"
    echo "  LINUX_KERNEL_SRC:  ${LINUX_KERNEL_SRC:-<not set>}"
    echo ""
    echo "Output: ${INSTALL_DIR}/bin/falco"
    [[ "${BUILD_KMOD}" == "ON" ]] && echo "        ${INSTALL_DIR}/share/falco/falco.ko (if LINUX_KERNEL_SRC exists)"
}

# Main
main() {
    local command="${1:-all}"
    
    case "${command}" in
        all)
            check_prerequisites
            create_dirs
            clone_falco
            configure_falco
            build_falco
            # When BUILD_KMOD=ON (e.g. BUILD_MODERN_BPF=OFF and using kmod on board), build falco.ko
            build_falco_kmod
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
            build_falco_kmod
            build_falco
            ;;
        kmod)
            check_prerequisites
            BUILD_KMOD="ON"
            build_falco_kmod
            if [[ -f "${BUILD_DIR}/falco/falco.ko" ]]; then
                mkdir -p "${INSTALL_DIR}/share/falco"
                cp -f "${BUILD_DIR}/falco/falco.ko" "${INSTALL_DIR}/share/falco/falco.ko"
                log_success "falco.ko installed to ${INSTALL_DIR}/share/falco/falco.ko"
            fi
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

# Run main function
main "$@"
