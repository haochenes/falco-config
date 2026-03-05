# Install script for directory: /home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/carlos/work/falco-config/cross_compile/install_ebpf")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/opt/cross-compile/arm-gnu-toolchain-11.3.rel1-x86_64-aarch64-none-linux-gnu//bin/aarch64-none-linux-gnu-objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/configure/0__SANITY" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/0__SANITY/build.sh"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/0__SANITY/test.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/0__SANITY/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/0__SANITY/Makefile.inc"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/configure/ACCESS_OK_2" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/ACCESS_OK_2/build.sh"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/ACCESS_OK_2/test.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/ACCESS_OK_2/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/ACCESS_OK_2/Makefile.inc"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/configure/CLASS_CREATE_1" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/CLASS_CREATE_1/build.sh"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/CLASS_CREATE_1/test.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/CLASS_CREATE_1/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/CLASS_CREATE_1/Makefile.inc"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/configure/DEVNODE_ARG1_CONST" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/DEVNODE_ARG1_CONST/build.sh"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/DEVNODE_ARG1_CONST/test.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/DEVNODE_ARG1_CONST/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/DEVNODE_ARG1_CONST/Makefile.inc"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/configure/FS_MNT_IDMAP" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/FS_MNT_IDMAP/build.sh"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/FS_MNT_IDMAP/test.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/FS_MNT_IDMAP/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/configure/FS_MNT_IDMAP/Makefile.inc"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/dkms.conf"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/driver_config.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/dynamic_params_table.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/event_table.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/fillers_table.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/flags_table.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/kernel_hacks.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/feature_gates.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/main.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_api_version.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_events.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_events.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_events_public.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_fillers.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_fillers.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_flag_helpers.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_ringbuffer.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/syscall_table.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/syscall_table64.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_cputime.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_version.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/systype_compat.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_tp.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_tp.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/ppm_consumer.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/capture_macro.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/socketcall_to_syscall.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/syscall_compat_loongarch64.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/syscall_compat_ppc64le.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/syscall_compat_riscv64.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/syscall_compat_s390x.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/syscall_compat_x86_64.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/syscall_ia32_64_map.c"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/cmake_install.cmake")

endif()

