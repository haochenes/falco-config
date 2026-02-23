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

**For modern eBPF build** (`BUILD_MODERN_BPF=ON` in `build.cfg`):

- **clang** and **llvm** (to compile BPF programs at build time):
  ```bash
  sudo apt-get install -y clang llvm
  ```
- **libelf-dev** and **zlib1g-dev** (for bpftool; script can build bpftool from source if needed):
  ```bash
  sudo apt-get install -y libelf-dev zlib1g-dev
  ```
- Optionally **bpftool** (if installed, the script uses it; otherwise it will build from source):
  ```bash
  sudo apt-get install -y bpftool
  ```

The following paths must exist (or set in `build.cfg`):

- Sysroot: e.g. `/opt/ti-processor-sdk-linux-adas-j721e-evm-09_02_00_05/linux-devkit/sysroots/aarch64-oe-linux`
- Cross-compiler: e.g. `/opt/cross-compile/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/bin`

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

### [MODERN BPF] unable to find clang

When `BUILD_MODERN_BPF=ON`, the build needs **clang** to compile BPF programs. Install and retry:
```bash
sudo apt-get install -y clang llvm
./build_falco.sh all
```

### events_dimensions_generator: not found (modern BPF cross-compile)

When `BUILD_MODERN_BPF=ON`, falcosecurity-libs needs host-built generators; cross-compile may fail with this error. Workaround: set `BUILD_MODERN_BPF=OFF` and `MINIMAL_BUILD=ON` in `build.cfg` to produce an aarch64 binary (use `engine.kind: kmod` or `nodriver` on the board).

## Build Configuration

Edit `build.cfg` to control the build:

| Option | Description | Modern eBPF 推荐 |
|--------|-------------|------------------|
| `BUILD_MODERN_BPF` | Enable modern eBPF driver (no .ko on board) | **ON** |
| `MINIMAL_BUILD` | Minimal deps; with modern BPF can be OFF | OFF |
| `BUILD_DRIVER` | Build legacy driver | OFF |
| `BUILD_BPF` | Build legacy BPF probe | OFF |
| `BUILD_KMOD` | Build falco.ko for target kernel | OFF（modern eBPF 无需 .ko） |
| `USE_BUNDLED_DEPS=ON` | Use bundled deps for ARM64 | ON |

**Modern eBPF 流程**：在 `build.cfg` 中设 `BUILD_MODERN_BPF=ON`、`MINIMAL_BUILD=OFF`，主机安装 clang/llvm 后执行 `./build_falco.sh all`。板端使用 `engine.kind: modern_ebpf`（见 `board_test/config/falco.modern_bpf.board.yaml`），无需编译或加载 falco.ko；板端内核需支持 BTF（通常 5.8+）。

**BUILD_MODERN_BPF=OFF 时使用 kmod**：若板端要用 `engine.kind: kmod`，需 falco.ko。在 `build.cfg` 中设 `BUILD_KMOD=ON`、`LINUX_KERNEL_SRC` 指向板子内核源码树（与板端 `uname -r` 一致且已 `make modules_prepare` 或完整编过），执行 `./build_falco.sh all` 会同时产出 `install/bin/falco` 和 `install/share/falco/falco.ko`；部署后将 falco.ko 拷到板子并 `insmod`，再启动 Falco。

## Notes

- The binary is dynamically linked against glibc from the sysroot
- Kernel module/BPF driver is disabled (requires separate kernel build)
- This builds the userspace components only
- The stripped binary is ~5.6MB
