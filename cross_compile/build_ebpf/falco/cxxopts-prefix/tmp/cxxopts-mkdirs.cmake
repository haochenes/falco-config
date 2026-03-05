# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/cxxopts-prefix/src/cxxopts"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/cxxopts-prefix/src/cxxopts-build"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/cxxopts-prefix"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/cxxopts-prefix/tmp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/cxxopts-prefix/src/cxxopts-stamp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/cxxopts-prefix/src"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/cxxopts-prefix/src/cxxopts-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/cxxopts-prefix/src/cxxopts-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/cxxopts-prefix/src/cxxopts-stamp${cfgdir}") # cfgdir has leading slash
endif()
