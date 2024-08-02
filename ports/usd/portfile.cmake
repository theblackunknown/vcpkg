# USD plugins do not produce .lib
set(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)

# Proper support for a true static usd build is left as a future port improvement.
vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

string(REGEX REPLACE "^([0-9]+)[.]([0-9])\$" "\\1.0\\2" USD_VERSION "${VERSION}")

vcpkg_download_distfile(FIND_DEPENDENCY_PATCH
  URLS "https://github.com/PixarAnimationStudios/OpenUSD/pull/3205.diff?full_index=1"
  SHA512 b8809bc321bd774ec85101d07b8827d87fd80babd052b58a1880e57df700fe20943cbf0d7544f2f01c2562aa3dc0c3b8759578cec01e8c5097242376573c39b3
  FILENAME "001-fix_rename_find_package_to_find_dependency-c99a32b.patch"
)

# Uncomment once PixarAnimationStudios/OpenUSD#3205 is merged because it conflicts with the previous patch
# vcpkg_download_distfile(FIND_TBB_PATCH
#   URLS "https://github.com/PixarAnimationStudios/OpenUSD/pull/3207.diff?full_index=1"
#   SHA512 997fa508adf7b58e0caa05b6fce0d55de8bc60a71caaa0efeccb79a2399647731f816f5e0fbe339846d3dd85d187a103ae00e6494b69cb3e8b0f7e956eccc5c4
#   FILENAME "002-vcpkg_find_tbb-a1075a60.patch"
# )

vcpkg_download_distfile(MATERIALX_1_39_PATCH
  URLS "https://github.com/PixarAnimationStudios/OpenUSD/pull/3159.diff?full_index=1"
  SHA512 f31b682d5d15c54d8bcaff4bcacc4a00b25c95b9735660f5e3908fb995bc5f29a6a71400b710a9feea4d9a5a6dcb2975131f9a249597e1efdf939ef34c795fd0
  FILENAME "014-MaterialX_v1.38-39-1033d49.patch"
)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO PixarAnimationStudios/OpenUSD
    REF "v${VERSION}"
    SHA512 7d4404980579c4de3c155386184ca9d2eb96756ef6e090611bae7b4c21ad942c649f73a39b74ad84d0151ce6b9236c4b6c0c555e8e36fdd86304079e1c2e5cbe
    HEAD_REF release
    PATCHES
        "${FIND_DEPENDENCY_PATCH}"
        002-vcpkg_find_tbb.patch # "${FIND_TBB_PATCH}" # Uncomment once PixarAnimationStudios/OpenUSD#3205 is merged because it conflicts with the previous patch
        003-vcpkg_find_opensubdiv.patch
        004-vcpkg_find_openimageio.patch
        005-vcpkg_find_shaderc.patch
        006-vcpkg_find_spirv-reflect.patch
        007-vcpkg_find_vma.patch
        008-fix_cmake_package.patch
        009-fix_cmake_hgi_interop.patch
        010-fix_missing_find_dependency_vulkan.patch
        011-fix_clang8_compiler_error.patch
        012-vcpkg_install_folder_conventions.patch
        013-cmake_export_plugin_as_modules.patch
        "${MATERIALX_1_39_PATCH}"
        015-fix_missing_find_dependency_opengl.patch
)

# Changes accompanying 006-vcpkg_find_spirv-reflect.patch
vcpkg_replace_string("${SOURCE_PATH}/pxr/imaging/hgiVulkan/shaderCompiler.cpp"
    [[#include "pxr/imaging/hgiVulkan/spirv_reflect.h"]]
    [[#include <spirv_reflect.h>]]
)
file(REMOVE
    "${SOURCE_PATH}/pxr/imaging/hgiVulkan/spirv_reflect.cpp"
    "${SOURCE_PATH}/pxr/imaging/hgiVulkan/spirv_reflect.h"
)

# Changes accompanying 007-vcpkg_find_vma.patch
vcpkg_replace_string("${SOURCE_PATH}/pxr/imaging/hgiVulkan/device.cpp"
    [[#include "pxr/imaging/hgiVulkan/vk_mem_alloc.h"]]
    [[#include <vk_mem_alloc.h>]]
)
vcpkg_replace_string("${SOURCE_PATH}/pxr/imaging/hgiVulkan/vulkan.h"
    [[#include "pxr/imaging/hgiVulkan/vk_mem_alloc.h"]]
    [[#include <vk_mem_alloc.h>]]
)
file(REMOVE
    "${SOURCE_PATH}/pxr/imaging/hgiVulkan/vk_mem_alloc.cpp"
    "${SOURCE_PATH}/pxr/imaging/hgiVulkan/vk_mem_alloc.h"
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        materialx      PXR_ENABLE_MATERIALX_SUPPORT
        metal          PXR_ENABLE_METAL_SUPPORT
        opencolorio    PXR_BUILD_OPENCOLORIO_PLUGIN
        openimageio    PXR_BUILD_OPENIMAGEIO_PLUGIN
        prman          PXR_BUILD_PRMAN_PLUGIN
        tools          PXR_BUILD_USD_TOOLS
        vulkan         PXR_ENABLE_VULKAN_SUPPORT
)

if (PXR_ENABLE_MATERIALX_SUPPORT)
    list(APPEND FEATURE_OPTIONS "-DMaterialX_DIR=${CURRENT_INSTALLED_DIR}/share/materialx")
endif()

# hgiInterop Metal and Vulkan backend requires garch which is only enabled if PXR_ENABLE_GL_SUPPORT is ON
if(PXR_ENABLE_VULKAN_SUPPORT OR PXR_ENABLE_METAL_SUPPORT)
    list(APPEND FEATURE_OPTIONS "-DPXR_ENABLE_GL_SUPPORT:BOOL=ON")
else()
    list(APPEND FEATURE_OPTIONS "-DPXR_ENABLE_GL_SUPPORT:BOOL=OFF")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${FEATURE_OPTIONS}
        -DPXR_BUILD_DOCUMENTATION:BOOL=OFF
        -DPXR_BUILD_EXAMPLES:BOOL=OFF
        -DPXR_BUILD_TESTS:BOOL=OFF
        -DPXR_BUILD_TUTORIALS:BOOL=OFF

        -DPXR_BUILD_ALEMBIC_PLUGIN:BOOL=OFF
        -DPXR_BUILD_DRACO_PLUGIN:BOOL=OFF
        -DPXR_BUILD_EMBREE_PLUGIN:BOOL=OFF
        -DPXR_BUILD_PRMAN_PLUGIN:BOOL=OFF

        -DPXR_BUILD_IMAGING:BOOL=ON 
        -DPXR_BUILD_USD_IMAGING:BOOL=ON 

        -DPXR_ENABLE_OPENVDB_SUPPORT:BOOL=OFF
        -DPXR_ENABLE_PTEX_SUPPORT:BOOL=OFF

        -DPXR_PREFER_SAFETY_OVER_SPEED:BOOL=ON 

        -DPXR_ENABLE_PRECOMPILED_HEADERS:BOOL=OFF

        -DPXR_ENABLE_PYTHON_SUPPORT:BOOL=OFF
        -DPXR_USE_DEBUG_PYTHON:BOOL=OFF
    MAYBE_UNUSED_VARIABLES
        PXR_USE_PYTHON_3
        PYTHON_EXECUTABLE
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

# Handle debug path for USD plugins
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    file(GLOB_RECURSE debug_targets
        "${CURRENT_PACKAGES_DIR}/debug/share/pxr/*-debug.cmake"
        )
    foreach(debug_target IN LISTS debug_targets)
        file(READ "${debug_target}" contents)
        string(REPLACE "\${_IMPORT_PREFIX}/usd" "\${_IMPORT_PREFIX}/debug/usd" contents "${contents}")
        string(REPLACE "\${_IMPORT_PREFIX}/plugin" "\${_IMPORT_PREFIX}/debug/plugin" contents "${contents}")
        file(WRITE "${debug_target}" "${contents}")
    endforeach()
endif()

vcpkg_cmake_config_fixup(PACKAGE_NAME "pxr")

vcpkg_list(SET tools)
if(PXR_BUILD_USD_TOOLS)
    vcpkg_list(APPEND tools
        sdfdump
        sdffilter
        usdcat
        usdtree
    )
endif()

if(tools)
    if(NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        vcpkg_copy_tools(
            TOOL_NAMES ${tools}
            SEARCH_DIR "${CURRENT_PACKAGES_DIR}/debug/bin"
            DESTINATION "${CURRENT_PACKAGES_DIR}/debug/tools/${PORT}"
        )
    endif()
    vcpkg_copy_tools(
        TOOL_NAMES ${tools}
        AUTO_CLEAN
    )
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

if(VCPKG_TARGET_IS_WINDOWS)
    # Move all dlls to bin
    file(GLOB RELEASE_DLL ${CURRENT_PACKAGES_DIR}/lib/*.dll)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/bin)
    file(GLOB DEBUG_DLL ${CURRENT_PACKAGES_DIR}/debug/lib/*.dll)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/bin)
    foreach(CURRENT_FROM ${RELEASE_DLL} ${DEBUG_DLL})
        string(REPLACE "/lib/" "/bin/" CURRENT_TO ${CURRENT_FROM})
        file(RENAME ${CURRENT_FROM} ${CURRENT_TO})
    endforeach()

    function(file_replace_regex filename match_string replace_string)
        file(READ ${filename} _contents)
        string(REGEX REPLACE "${match_string}" "${replace_string}" _contents "${_contents}")
        file(WRITE ${filename} "${_contents}")
    endfunction()

    # fix dll path for cmake
    file_replace_regex(${CURRENT_PACKAGES_DIR}/share/pxr/pxrTargets-debug.cmake "debug/lib/([a-zA-Z0-9_]+)\\.dll" "debug/bin/\\1.dll")
    file_replace_regex(${CURRENT_PACKAGES_DIR}/share/pxr/pxrTargets-release.cmake "lib/([a-zA-Z0-9_]+)\\.dll" "bin/\\1.dll")

    # fix plugInfo.json for runtime
    file(GLOB_RECURSE PLUGINFO_FILES ${CURRENT_PACKAGES_DIR}/lib/usd/*/resources/plugInfo.json)
    file(GLOB_RECURSE PLUGINFO_FILES_DEBUG ${CURRENT_PACKAGES_DIR}/debug/lib/usd/*/resources/plugInfo.json)
    foreach(PLUGINFO ${PLUGINFO_FILES} ${PLUGINFO_FILES_DEBUG})
        file_replace_regex(${PLUGINFO} [=["LibraryPath": "../../([a-zA-Z0-9_]+).dll"]=] [=["LibraryPath": "../../../bin/\1.dll"]=])
    endforeach()
endif()

# Handle copyright
vcpkg_install_copyright(FILE_LIST ${SOURCE_PATH}/LICENSE.txt)
