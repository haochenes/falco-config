# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs-build"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/tmp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs-stamp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs-stamp${cfgdir}") # cfgdir has leading slash
endif()
