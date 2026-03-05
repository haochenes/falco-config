# Install script for directory: /home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver/bpf

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/bpf" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/bpf_helpers.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/builtins.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/filler_helpers.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/fillers.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/maps.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/plumbing_helpers.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/probe.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/quirks.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ring_helpers.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/missing_definitions.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/types.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/capture_macro.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/driver_config.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/event_stats.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/feature_gates.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/kernel_hacks.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm_api_version.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm_consumer.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm_events.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm_events_public.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm_fillers.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm_flag_helpers.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm_ringbuffer.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm_tp.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/ppm_version.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/socketcall_to_syscall.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/syscall_compat.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/syscall_compat_aarch64.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/syscall_compat_loongarch64.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/syscall_compat_ppc64le.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/syscall_compat_riscv64.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/syscall_compat_s390x.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/syscall_compat_x86_64.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/systype_compat.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/bpf/configure/0__SANITY" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/0__SANITY/build.sh"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/0__SANITY/test.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/0__SANITY/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/0__SANITY/Makefile.inc"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/bpf/configure/KERNFS_NODE_PARENT" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/KERNFS_NODE_PARENT/build.sh"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/KERNFS_NODE_PARENT/test.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/KERNFS_NODE_PARENT/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/KERNFS_NODE_PARENT/Makefile.inc"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/bpf/configure/RSS_STAT_ARRAY" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/RSS_STAT_ARRAY/build.sh"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/RSS_STAT_ARRAY/test.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/RSS_STAT_ARRAY/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/RSS_STAT_ARRAY/Makefile.inc"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco-driver" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/src/falco-9.1.0+driver/bpf/configure/TASK_PIDS_FIELD" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/TASK_PIDS_FIELD/build.sh"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/TASK_PIDS_FIELD/test.c"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/TASK_PIDS_FIELD/Makefile"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/bpf/src/configure/TASK_PIDS_FIELD/Makefile.inc"
    )
endif()

