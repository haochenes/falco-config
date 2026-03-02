# Install script for directory: /home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs/userspace/libscap

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

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs-deps" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/falcosecurity" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/libz.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs-deps" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity/zlib" TYPE FILE FILES
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/crc32.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/deflate.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/gzguts.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/inffast.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/inffixed.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/inflate.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/inftrees.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/trees.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/zconf.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/zlib.h"
    "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/zlib-prefix/src/zlib/zutil.h"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/linux/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/noop/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/nodriver/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/savefile/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/source_plugin/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/kmod/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/bpf/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/modern_bpf/cmake_install.cmake")

endif()

