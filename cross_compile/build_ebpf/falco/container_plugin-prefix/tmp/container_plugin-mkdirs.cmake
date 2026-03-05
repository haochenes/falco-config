# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix/src/container_plugin"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix/src/container_plugin-build"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix/tmp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix/src/container_plugin-stamp"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix/src"
  "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix/src/container_plugin-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix/src/container_plugin-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix/src/container_plugin-stamp${cfgdir}") # cfgdir has leading slash
endif()
