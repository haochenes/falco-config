# Install script for directory: /home/carlos/work/falco-config/cross_compile/src/falco

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

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/libscap_error.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/libscap.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/libscap_platform_util.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/libscap_event_schema.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/libdriver_event_schema.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/libscap_engine_util.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/linux/libscap_platform.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/noop/libscap_engine_noop.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/nodriver/libscap_engine_nodriver.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/savefile/libscap_engine_savefile.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/source_plugin/libscap_engine_source_plugin.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/kmod/libscap_engine_kmod.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/bpf/libscap_engine_bpf.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/engine/modern_bpf/libscap_engine_modern_bpf.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "scap" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs/userspace/libscap" FILES_MATCHING REGEX "/[^/]*\\.h$" REGEX "/[^/]*examples[^/]*$" EXCLUDE REGEX "/[^/]*doxygen[^/]*$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "scap" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity/driver" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/src/" FILES_MATCHING REGEX "/[^/]*\\.h$")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "scap" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs/userspace/plugin" FILES_MATCHING REGEX "/[^/]*\\.h$")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity/libscap" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/uthash-prefix/src/uthash/src/uthash.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity/libscap" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/scap_config.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity/libscap" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/scap_strl_config.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/libscap.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs-deps" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/falcosecurity" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/tbb-prefix/src/tbb/lib_release/" FILES_MATCHING REGEX "/libtbb[^/]*$")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs-deps" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/tbb-prefix/src/tbb/include//tbb")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs-deps" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/falcosecurity" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/jsoncpp-prefix/src/lib/libjsoncpp.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs-deps" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/jsoncpp-prefix/src/include/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs-deps" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/falcosecurity" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/src/re2/lib/" FILES_MATCHING REGEX "/libre2[^/]*$")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs-deps" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/re2-prefix/src/re2/include")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libsinsp/libsinsp.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "sinsp" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs/userspace/libsinsp" FILES_MATCHING REGEX "/[^/]*\\.h$" REGEX "/[^/]*third\\_party[^/]*$" EXCLUDE REGEX "/[^/]*examples[^/]*$" EXCLUDE REGEX "/[^/]*doxygen[^/]*$" EXCLUDE REGEX "/[^/]*scripts[^/]*$" EXCLUDE REGEX "/[^/]*test[^/]*$" EXCLUDE)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "sinsp" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/falcosecurity" TYPE DIRECTORY FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-libs-repo/falcosecurity-libs-prefix/src/falcosecurity-libs/userspace/async" FILES_MATCHING REGEX "/[^/]*\\.h$")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libsinsp/libsinsp.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco/falco.yaml")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/src/falco/falco.yaml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco/config.d/")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco/config.d" TYPE DIRECTORY FILES "")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco/falco_rules.yaml")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco" TYPE FILE RENAME "falco_rules.yaml" FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-falco-prefix/src/falcosecurity-rules-falco/falco_rules.yaml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco/falco_rules.local.yaml")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco" TYPE FILE RENAME "falco_rules.local.yaml" FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcosecurity-rules-local-prefix/falco_rules.local.yaml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco/rules.d/")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco/rules.d" TYPE DIRECTORY FILES "")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE PROGRAM FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/falcoctl-prefix/src/falcoctl/falcoctl")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/carlos/work/falco-config/cross_compile/install_ebpf/share/falco/plugins/")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/home/carlos/work/falco-config/cross_compile/install_ebpf/share/falco/plugins" TYPE DIRECTORY FILES "")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/carlos/work/falco-config/cross_compile/install_ebpf/share/falco/plugins/libcontainer.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/home/carlos/work/falco-config/cross_compile/install_ebpf/share/falco/plugins" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/container_plugin-prefix/src/container_plugin/libcontainer.so")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "falco" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco/config.d/falco.container_plugin.yaml")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/home/carlos/work/falco-config/cross_compile/install_ebpf/etc/falco/config.d" TYPE FILE FILES "/home/carlos/work/falco-config/cross_compile/src/falco/config/falco.container_plugin.yaml")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/driver/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libscap/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/libsinsp/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/_deps/nlohmann_json-build/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/_deps/yamlcpp-build/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/scripts/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/userspace/engine/cmake_install.cmake")
  include("/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/userspace/falco/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/carlos/work/falco-config/cross_compile/build_ebpf/falco/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
