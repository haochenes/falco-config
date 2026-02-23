# Falco Cross-Compilation for TI J721E (ARM64)

This directory contains scripts for cross-compiling Falco for the TI J721E platform.

## Target Platform

- **Architecture**: ARM64 (aarch64)
- **Sysroot**: TI Processor SDK Linux ADAS J721E EVM 09.02.00.05
- **Compiler**: GCC ARM 11.2 (aarch64-none-linux-gnu)
- **Falco Version**: Latest from GitHub

## Prerequisites

Ensure the following are installed on your host system:

- CMake 3.16+
- Git
- Make
- wget

The following paths must exist:
- Sysroot: `/opt/ti-processor-sdk-linux-adas-j721e-evm-09_02_00_05/linux-devkit/sysroots/aarch64-oe-linux`
- Cross-compiler: `/opt/cross-compile/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/bin`

## Quick Start

```bash
# Make build script executable
chmod +x build_falco.sh

# Build everything (clone, configure, build, install)
./build_falco.sh all
```

The build script automatically:
1. Clones Falco source from GitHub
2. Applies necessary patches for cross-compilation
3. Configures CMake with toolchain file
4. Builds all bundled dependencies for ARM64
5. Compiles Falco
6. Strips the binary for smaller size

## Directory Structure

After building:

```
cross_compile/
├── build_falco.sh          # Main build script
├── toolchain-aarch64.cmake # CMake toolchain file
├── env.sh                  # Environment setup (for manual builds)
├── README.md               # This file
├── src/                    # Source code (auto-downloaded)
│   └── falco/              # Falco source
├── build/                  # Build artifacts
│   └── falco/              # Falco build (includes bundled deps)
└── install/                # Installation prefix
    ├── bin/
    │   └── falco           # Falco executable (~5.6MB stripped)
    ├── lib/                # Libraries
    ├── etc/                # Configuration files
    └── share/              # Rules files
```

## Build Commands

| Command | Description |
|---------|-------------|
| `./build_falco.sh all` | Full build (default) |
| `./build_falco.sh configure` | Configure CMake only |
| `./build_falco.sh build` | Build only (requires configure) |
| `./build_falco.sh install` | Install to install directory |
| `./build_falco.sh clean` | Clean build artifacts |
| `./build_falco.sh fullclean` | Clean everything including sources |
| `./build_falco.sh help` | Show help |

## Manual CMake Usage

For manual builds, source the environment first:

```bash
source env.sh

# Then use CMake with toolchain file
cmake -DCMAKE_TOOLCHAIN_FILE=toolchain-aarch64.cmake ...
```

## Build Output

After successful build:
- Binary: `install/bin/falco` (~5.6MB stripped)
- Configuration: `install/etc/falco/`
- Rules: `install/share/falco/`

**现代推荐：modern eBPF（无需 .ko）**  
在 `build.cfg` 中设置 **BUILD_MODERN_BPF=ON** 后重新编译，板端配置 `engine.kind: modern_ebpf`（或使用 `board_test/config/falco.modern_bpf.board.yaml`），无需编译或部署 falco.ko，性能更好、兼容性强（Falco 0.32+ 默认推荐）。板端内核需支持 BTF（通常 5.8+）。

## Deployment to Target

Copy the compiled files to the target device (manual), or use the **board_test** directory for automated deploy and remote test execution:

```bash
# Manual copy
scp install/bin/falco target:/usr/local/bin/
scp -r install/etc/falco target:/etc/
scp -r install/share/falco target:/usr/share/
```

For board-level deploy and running tests via SSH, see **../board_test** (e.g. `board_test/deploy_to_board.sh`, `board_test/run_tests_remote.sh`).

## Cross-Compilation Patches

The build script automatically applies patches to the following bundled dependency cmake modules:
- `tbb.cmake` - Pass CMAKE_SYSTEM_NAME/PROCESSOR/SYSROOT
- `zlib.cmake` - Use cross-compiler CC/AR/RANLIB
- `jsoncpp.cmake` - Pass cross-compilation parameters
- `re2.cmake` - Pass cross-compilation parameters

### Container plugin (libcontainer.so) architecture fix

Falco’s CMake uses **CMAKE_HOST_SYSTEM_PROCESSOR** (build host) to choose which prebuilt `libcontainer.so` to download. When you cross-compile on x86_64 for aarch64, the host is x86_64, so the build downloads the **x86_64** plugin and installs it into `install/share/falco/plugins/`. On the aarch64 board that `.so` cannot be loaded (wrong architecture).

The build script therefore patches Falco’s `CMakeLists.txt` after clone so that when **CMAKE_CROSSCOMPILING** is true it uses **CMAKE_SYSTEM_PROCESSOR** (target arch) to select the plugin. That way the correct **aarch64** `libcontainer.so` is downloaded and installed. No manual download or build of the container plugin is needed for aarch64.

## Troubleshooting

### Missing sysroot libraries

If build fails due to missing libraries, check if they exist in the sysroot:

```bash
ls /opt/ti-processor-sdk-linux-adas-j721e-evm-09_02_00_05/linux-devkit/sysroots/aarch64-oe-linux/usr/lib/
```

### Build fails with x86 errors

Ensure all bundled dependencies are being built with cross-compilation flags. Check the build logs in `build/` directory.

### Linker errors about ELF format

This usually means some dependency was built for x86 instead of ARM64. Clean and rebuild:
```bash
./build_falco.sh fullclean
./build_falco.sh all
```

## Build Configuration

The Falco build uses the following configuration:
- `MINIMAL_BUILD=ON` - Minimal build to reduce dependencies
- `BUILD_DRIVER=OFF` - No kernel module (requires kernel source)
- `BUILD_BPF=OFF` - No BPF probe
- `BUILD_FALCO_MODERN_BPF=OFF` - No modern BPF
- `USE_BUNDLED_DEPS=ON` - Use bundled dependencies for ARM64

## Notes

- The binary is dynamically linked against glibc from the sysroot
- Kernel module/BPF driver is disabled (requires separate kernel build)
- This builds the userspace components only
- The stripped binary is ~5.6MB
