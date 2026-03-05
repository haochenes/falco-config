# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix/src/uthash"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix/src/uthash-build"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix/tmp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix/src/uthash-stamp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix/src"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix/src/uthash-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix/src/uthash-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix/src/uthash-stamp${cfgdir}") # cfgdir has leading slash
endif()
