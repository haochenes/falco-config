# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix/src/falcoctl"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix/src/falcoctl-build"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix/tmp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix/src/falcoctl-stamp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix/src"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix/src/falcoctl-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix/src/falcoctl-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix/src/falcoctl-stamp${cfgdir}") # cfgdir has leading slash
endif()
