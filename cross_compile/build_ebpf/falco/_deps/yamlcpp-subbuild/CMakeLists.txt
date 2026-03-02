# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.28.3)

# Reject any attempt to use a toolchain file. We must not use one because
# we could be downloading it here. If the CMAKE_TOOLCHAIN_FILE environment
# variable is set, the cache variable will have been initialized from it.
unset(CMAKE_TOOLCHAIN_FILE CACHE)
unset(ENV{CMAKE_TOOLCHAIN_FILE})

# We name the project and the target for the ExternalProject_Add() call
# to something that will highlight to the user what we are working on if
# something goes wrong and an error message is produced.

project(yamlcpp-populate NONE)



include(ExternalProject)
ExternalProject_Add(yamlcpp-populate
                     "UPDATE_DISCONNECTED" "False" "DOWNLOAD_EXTRACT_TIMESTAMP" "TRUE" "EXTERNALPROJECT_INTERNAL_ARGUMENT_SEPARATOR" "URL" "https://github.com/jbeder/yaml-cpp/archive/c2bec4c755c67ad86185a2a264996137904fb712.tar.gz" "URL_HASH" "SHA256=faea1ffdbad81b958b3b45a63ba667f4db53a3fffb983ca5df4745cf90044797"
                    SOURCE_DIR          "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/_deps/yamlcpp-src"
                    BINARY_DIR          "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/_deps/yamlcpp-build"
                    CONFIGURE_COMMAND   ""
                    BUILD_COMMAND       ""
                    INSTALL_COMMAND     ""
                    TEST_COMMAND        ""
                    USES_TERMINAL_DOWNLOAD  YES
                    USES_TERMINAL_UPDATE    YES
                    USES_TERMINAL_PATCH     YES
)


