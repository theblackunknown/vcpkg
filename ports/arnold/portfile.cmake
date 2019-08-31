# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

# Following https://vcpkg.readthedocs.io/en/latest/about/faq/#can-i-use-a-prebuilt-private-library-with-this-tool

set(VCPKG_TARGET_ARCHITECTURE x64)

include(vcpkg_common_definitions)
include(vcpkg_common_functions)

vcpkg_download_distfile(ARCHIVE
    # Dummy URL as I don't know any public URL for this, you need to create an account and log on https://www.arnoldrenderer.com/arnold to get the SDK
    # Then simply drop the downloaded packages in vcpkg/downloaded folder
    URLS
        "http://www.example.com/Arnold-5.4.0.0-windows.zip"
        "https://www.arnoldrenderer.com/arnold/download/product-download/?id=2895"
    FILENAME "Arnold-5.4.0.0-windows.zip"
    SHA512 7a5bf9ae0368b7f571fe3624513766a1ee4db6d41825457ebc1c23205f8d9dbc9f34d3ae7d32a2d1b606af644867c1f647a9cac138a03d530ae8affc52da0881
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    NO_REMOVE_ONE_LEVEL
    REF 5.4.0.0
)

file(INSTALL "${SOURCE_PATH}/bin/"                       DESTINATION "${CURRENT_PACKAGES_DIR}/bin"            FILES_MATCHING PATTERN "*.dll")
file(INSTALL "${SOURCE_PATH}/bin/"                       DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"      FILES_MATCHING PATTERN "*.dll")
file(INSTALL "${SOURCE_PATH}/bin/"                       DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}"  FILES_MATCHING PATTERN "*.exe")
file(INSTALL "${SOURCE_PATH}/doc/"                       DESTINATION "${CURRENT_PACKAGES_DIR}/doc/${PORT}")
file(INSTALL "${SOURCE_PATH}/include/"                   DESTINATION "${CURRENT_PACKAGES_DIR}/include/${PORT}" FILES_MATCHING PATTERN "*.h")
file(INSTALL "${SOURCE_PATH}/lib/"                       DESTINATION "${CURRENT_PACKAGES_DIR}/lib"             FILES_MATCHING PATTERN "*.lib")
file(INSTALL "${SOURCE_PATH}/lib/"                       DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"       FILES_MATCHING PATTERN "*.lib")
file(INSTALL "${SOURCE_PATH}/license"                    DESTINATION "${CURRENT_PACKAGES_DIR}")
file(INSTALL "${SOURCE_PATH}/materialx"                  DESTINATION "${CURRENT_PACKAGES_DIR}")
file(INSTALL "${SOURCE_PATH}/osl"                        DESTINATION "${CURRENT_PACKAGES_DIR}")
file(INSTALL "${SOURCE_PATH}/plugins"                    DESTINATION "${CURRENT_PACKAGES_DIR}")
file(INSTALL "${SOURCE_PATH}/python"                     DESTINATION "${CURRENT_PACKAGES_DIR}")
file(INSTALL "${SOURCE_PATH}/Arnold_5_Porting_Guide.pdf" DESTINATION "${CURRENT_PACKAGES_DIR}/misc/${PORT}")
file(INSTALL "${SOURCE_PATH}/Changes.html"               DESTINATION "${CURRENT_PACKAGES_DIR}/misc/${PORT}")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/arnold-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/arnold-config-version.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright" "See https://www.arnoldrenderer.com/arnold/download/ for the Arnold SDK license")

vcpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}")

vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY ONLY_DYNAMIC_CRT)

set(VCPKG_POLICY_ALLOW_OBSOLETE_MSVCRT enabled)
