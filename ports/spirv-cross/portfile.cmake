vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KhronosGroup/SPIRV-Cross
    REF 61c603f3baa5270e04bcfb6acf83c654e3c57679 # sdk-1.3.224.1
    SHA512 edc8fd7efec20395cee00129f485c0ea7ef57f4c0efdc91e1335310be913d899e04c8103336e44ed83d08b28a221eea87853c054af3ad9f223e49a9038f61103
    HEAD_REF master
    PATCHES
        001-unofficial-SPIRV-Cross.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" _SPIRV_CROSS_SHARED)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" _SPIRV_CROSS_STATIC)

if(VCPKG_TARGET_IS_IOS)
    message(STATUS "Using iOS trplet. Executables won't be created...")
    set(BUILD_CLI OFF)
else()
    set(BUILD_CLI ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSPIRV_CROSS_CLI=${BUILD_CLI}
        -DSPIRV_CROSS_ENABLE_C_API=ON
        -DSPIRV_CROSS_ENABLE_TESTS=OFF
        -DSPIRV_CROSS_EXCEPTIONS_TO_ASSERTIONS=OFF
        -DSPIRV_CROSS_FORCE_PIC=${_SPIRV_CROSS_SHARED}
        -DSPIRV_CROSS_SHARED=${_SPIRV_CROSS_SHARED}
        -DSPIRV_CROSS_SKIP_INSTALL=OFF
        -DSPIRV_CROSS_STATIC=${_SPIRV_CROSS_STATIC}
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-SPIRV-Cross)

if(BUILD_CLI)
    vcpkg_copy_tools(TOOL_NAMES spirv-cross AUTO_CLEAN)
endif()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

configure_file(
    "${SOURCE_PATH}/LICENSE"
    "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright"
    COPYONLY
)
