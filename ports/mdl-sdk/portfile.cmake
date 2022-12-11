vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

# Notes on Clang 12 binary download:
# MDL-SDK requires Clang version 12.0.1 precisely as a *build tool* not as a *source compiler* as it is usually used.
# This ports provides CMake instructions to fetch and use it to build this port - and only for this purpose:
# it will not be installed and as such not be usable by any other ports. 
# 
# More details on the why below:
# MDL-SDK supports its own source file format (NVIDIA MDL sources `.mdl`), and can codegen executable code at runtime using its own vendored and modified version of LLVM 12.0.1. 
# Also, at buildtime MDL-SDK also "pre-compile" MDL core libraries as LLVM bitcode directly into its binaries (through generated c array in headers) using this very Clang 12.0.1.
# To have everything working together, we have to use a Clang as build tool which match the vendored LLVM version so that LLVM bitcode can be loaded/linked properly as it is not compatible across LLVM versions.

# Clang 12 build tool

# FIXME Switch to 12.0.1
set(LLVM_VERSION 12.0.0)
set(LLVM_BASE_URL "https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}")

if(VCPKG_HOST_IS_WINDOWS)
    set(LLVM_FILENAME  "LLVM-${LLVM_VERSION}-win64.exe")
    set(LLVM_HASH      0)
elseif(VCPKG_HOST_IS_LINUX)
    set(LLVM_FILENAME  "clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-20.04.tar.xz")
    set(LLVM_HASH      0)
elseif(VCPKG_HOST_IS_FREEBSD)
    set(LLVM_FILENAME  "clang+llvm-${LLVM_VERSION}-amd64-unknown-freebsd11.tar.xz")
    set(LLVM_HASH      0)
elseif(VCPKG_HOST_IS_OSX)
    set(LLVM_FILENAME  "clang+llvm-${LLVM_VERSION}-x86_64-apple-darwin.tar.xz")
    set(LLVM_HASH      2e74791425c12dacc201c5cfc38be7abe0ac670ddb079e75d477bf3f78d1dad442d1b4c819d67e0ba51c4474d8b7a726d4c50b7ad69d536e30edc38d1dce78b8)
else()
    message(FATAL_ERROR "Pre-built binaries for Clang 12 not available, aborting install (platform: ${VCPKG_CMAKE_SYSTEM_NAME}).")
endif()

vcpkg_download_distfile(LLVM_ARCHIVE_PATH
  URLS     "${LLVM_BASE_URL}/${LLVM_FILENAME}"
  SHA512   ${LLVM_HASH}
  FILENAME "${LLVM_FILENAME}"
)

if(VCPKG_TARGET_IS_WINDOWS)
    get_filename_component(LLVM_BASENAME "${LLVM_FILENAME}" NAME_WE)
    set(LLVM_DIRECTORY "${CURRENT_BUILDTREES_DIR}/src/${LLVM_BASENAME}")
    file(REMOVE_RECURSE "${LLVM_DIRECTORY}")
    file(MAKE_DIRECTORY "${LLVM_DIRECTORY}")

    vcpkg_find_acquire_program(7Z)
    vcpkg_execute_in_download_mode(
        COMMAND ${7Z} x
            "${LLVM_ARCHIVE_PATH}"
            "-o${LLVM_DIRECTORY}"
            -y -bso0 -bsp0
        WORKING_DIRECTORY "${LLVM_DIRECTORY}"
    )
else()
    vcpkg_extract_source_archive(LLVM_DIRECTORY
        ARCHIVE "${LLVM_ARCHIVE_PATH}"
        SOURCE_BASE "clang+llvm-${LLVM_VERSION}"
    )
endif()

set(LLVM_CLANG12 "${LLVM_DIRECTORY}/bin/clang${VCPKG_HOST_EXECUTABLE_SUFFIX}")
if(NOT EXISTS "${LLVM_CLANG12}")
    message(FATAL_ERROR "Missing required build tool clang 12, please check your setup.")
endif()

# MDL-SDK
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO NVIDIA/MDL-SDK
    REF 9ccd1485447870f847244139d0c2168ce2c400af # 2022.0.1
    SHA512 653666e250ff374d35175a5beedeec168ca95126ee7a0209c2e14d8ffaf385f01c0e97d03f013e5818a46bcfcf0479b6c6b88f8cb10b404157273401f579d510
    HEAD_REF master
    PATCHES
        001-freeimage-from-vcpkg.patch
        002-install-rules.patch
        003-freeimage-disable-faxg3.patch
        005-missing-link-windows-crypt-libraries.patch
        007-plugin-options.patch
        # 008-build-static-llvm.patch
        # 009-include-priority-vendored-llvm.patch
)

string(COMPARE NOTEQUAL "${VCPKG_CRT_LINKAGE}" "static" _MVSC_CRT_LINKAGE_OPTION)

vcpkg_find_acquire_program(PYTHON3)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        dds MDL_BUILD_DDS_PLUGIN
        freeimage MDL_BUILD_FREEIMAGE_PLUGIN
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/unofficial-mdl-config.cmake.in" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DMDL_LOG_DEPENDENCIES:BOOL=ON

        -DMDL_MSVC_DYNAMIC_RUNTIME_EXAMPLES:BOOL=${_MVSC_CRT_LINKAGE_OPTION}

        -DMDL_ENABLE_CUDA_EXAMPLES:BOOL=OFF
        -DMDL_ENABLE_D3D12_EXAMPLES:BOOL=OFF
        -DMDL_ENABLE_MATERIALX:BOOL=OFF
        -DMDL_ENABLE_OPENGL_EXAMPLES:BOOL=OFF
        -DMDL_ENABLE_OPTIX7_EXAMPLES:BOOL=OFF
        -DMDL_ENABLE_PYTHON_BINDINGS:BOOL=OFF
        -DMDL_ENABLE_QT_EXAMPLES:BOOL=OFF
        -DMDL_ENABLE_TESTS:BOOL=OFF
        -DMDL_ENABLE_VULKAN_EXAMPLES:BOOL=OFF

        -DMDL_BUILD_SDK_EXAMPLES:BOOL=OFF
        -DMDL_BUILD_CORE_EXAMPLES:BOOL=OFF
        -DMDL_BUILD_ARNOLD_PLUGIN:BOOL=OFF
        
        -Dpython_PATH:PATH=${PYTHON3}
        -Dclang_PATH:PATH=${LLVM_CLANG12}

        ${FEATURE_OPTIONS}

    MAYBE_UNUSED_VARIABLES
        -DCMAKE_DISABLE_FIND_PACKAGE_GLEW=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_glfw3=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_OCaml=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_OpenGL=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_Qt5=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_Subversion=ON
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-mdl)
vcpkg_copy_tools(
    TOOL_NAMES i18n mdlc mdlm
    AUTO_CLEAN
)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
)

file(INSTALL "${SOURCE_PATH}/LICENSE.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
