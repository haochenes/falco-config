# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/src/re2"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/build"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/tmp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/src/re2-stamp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/src"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/src/re2-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/src/re2-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/src/re2-stamp${cfgdir}") # cfgdir has leading slash
endif()
