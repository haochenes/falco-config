# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix/src/falcosecurity-rules-falco"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix/src/falcosecurity-rules-falco-build"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix/tmp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix/src/falcosecurity-rules-falco-stamp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix/src"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix/src/falcosecurity-rules-falco-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix/src/falcosecurity-rules-falco-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix/src/falcosecurity-rules-falco-stamp${cfgdir}") # cfgdir has leading slash
endif()
