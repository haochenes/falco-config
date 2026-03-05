# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver-build"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/tmp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver-stamp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver-repo/driver-prefix/src/driver-stamp${cfgdir}") # cfgdir has leading slash
endif()
