vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KhronosGroup/MoltenVK
    REF b051111953df389c3d54aa57b5eac71ea1af7c92 # v1.1.11
    SHA512 b8a9db38d98bb6cff9981e6be00389cf92e6ffe60eb05a7f0c73e8e271640b51b437a3776c8978a7f7b05a109ab633cec97a733ee8fe4ace8ec63c377b58b8ea
    HEAD_REF master
    PATCHES
        001-remove-SPIRV-Cross-namespace-override.patch
)

set(shorthand_debug dbg)
set(camelcase_debug Debug)
set(relpath_debug "/debug")

set(shorthand_release rel)
set(camelcase_release Release)
set(relpath_release "")

function(stage_headers product_name)
    file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/headers-${product_name}-${TARGET_TRIPLET}")

    message(STATUS "Stage headers for ${product_name}")

    foreach(include_relpath IN LISTS ARGN)
        file(COPY "${CURRENT_INSTALLED_DIR}/include/${include_relpath}" 
            DESTINATION "${CURRENT_BUILDTREES_DIR}/headers-${product_name}-${TARGET_TRIPLET}/"
        )
    endforeach()
endfunction()

function(combine_libraries product_name)
    foreach(build_config debug release)
        set(shorthand ${shorthand_${build_config}})
        set(camelcase ${camelcase_${build_config}})
        set(relpath   ${relpath_${build_config}})

        if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "${build_config}")
            file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/libtool-${TARGET_TRIPLET}-${shorthand}")
            message(STATUS "Combine libraries into lib${product_name}.a for ${camelcase}")

            vcpkg_list(SET libraries)
            foreach(library_name IN LISTS ARGN)
                vcpkg_list(APPEND libraries "${CURRENT_INSTALLED_DIR}${relpath}/lib/lib${library_name}.a")
            endforeach()

            vcpkg_execute_required_process(
                COMMAND libtool
                    -static
                    -o "libtool-${TARGET_TRIPLET}-${shorthand}/lib${product_name}.a"
                    ${libraries}
                WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
                LOGNAME "libtool-${product_name}-${TARGET_TRIPLET}-${shorthand}"
            )
        endif()
    endforeach()
endfunction()

function(create_xcframework product_name)
    foreach(build_config debug release)
        set(shorthand ${shorthand_${build_config}})
        set(camelcase ${camelcase_${build_config}})
        set(relpath   ${relpath_${build_config}})

        if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "${build_config}")
            file(MAKE_DIRECTORY "${SOURCE_PATH}/External/${camelcase}")
            message(STATUS "Building ${product_name}.xcframework for ${camelcase}")

            vcpkg_execute_required_process(
                COMMAND xcodebuild
                    -verbose
                    -create-xcframework
                    -output "${SOURCE_PATH}/External/${camelcase}/${product_name}.xcframework"
                    -library "libtool-${TARGET_TRIPLET}-${shorthand}/lib${product_name}.a"
                    -headers  "headers-${product_name}-${TARGET_TRIPLET}"
                WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
                LOGNAME "xcframework-${product_name}-${TARGET_TRIPLET}-${shorthand}"
            )
        endif()
    endforeach()
endfunction()

function(vcpkg_xcode_build)
    cmake_parse_arguments(
        PARSE_ARGV 0
        arg
        ""
        "PROJECT_PATH;RELEASE_CONFIGURATION;DEBUG_CONFIGURATION;SCHEME;TARGET"
        "OPTIONS;OPTIONS_RELEASE;OPTIONS_DEBUG"
    )

    if(DEFINED arg_UNPARSED_ARGUMENTS)
        message(WARNING "vcpkg_xcode_build was passed extra arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    if(DEFINED arg_SCHEME AND DEFINED arg_TARGET)
        message(WARNING "vcpkg_xcode_build cannot be used with both SCHEME and TARGET, only one need to be defined")
    endif()

    if(NOT (DEFINED arg_SCHEME OR DEFINED arg_TARGET))
        message(WARNING "vcpkg_xcode_build requires either SCHEME or TARGET to be set")
    endif()

    if(NOT DEFINED arg_RELEASE_CONFIGURATION)
        set(arg_RELEASE_CONFIGURATION Release)
    endif()
    if(NOT DEFINED arg_DEBUG_CONFIGURATION)
        set(arg_DEBUG_CONFIGURATION Debug)
    endif()

    list(APPEND arg_OPTIONS
        -verbose
    )

    if(DEFINED arg_SCHEME)
        list(APPEND arg_OPTIONS
            "-scheme" "${arg_SCHEME}"
        )
    elseif(DEFINED arg_TARGET)
        list(APPEND arg_OPTIONS
            "-target" "${arg_TARGET}"
        )
    endif()

    if(VCPKG_OSX_ARCHITECTURES STREQUAL "x86_64")
        list(APPEND arg_OPTIONS
            "-arch" "x86_64"
        )
    elseif(VCPKG_OSX_ARCHITECTURES STREQUAL "arm64")
        list(APPEND arg_OPTIONS
            "-arch" "arm64"
        )
    else()
        message(FATAL_ERROR "vcpkg_xcode_build: unable to detect for which arch to build, VCPKG_OSX_ARCHITECTURES=${VCPKG_OSX_ARCHITECTURES}")
    endif()

    # if(VCPKG_TARGET_IS_OSX)
    #     list(APPEND arg_OPTIONS
    #         "-sdk" "macOSXX.Y"
    #     )
    # elseif(VCPKG_TARGET_IS_IOS)
    #     list(APPEND arg_OPTIONS
    #         "-sdk" "iphoneosXX.Y"
    #     )
    # else()
    #     message(FATAL_ERROR "vcpkg_xcode_build: unable to detect for which sdk to build, VCPKG_CMAKE_SYSTEM_NAME=${VCPKG_CMAKE_SYSTEM_NAME}")
    # endif()


    foreach(build_config debug release)
        set(shorthand ${shorthand_${build_config}})
        set(camelcase ${camelcase_${build_config}})
        set(relpath   ${relpath_${build_config}})
        string(TOUPPER "${build_config}" uppercase)

        if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "${build_config}")
            # NOTE BEGIN MoltenVK specific
            file(MAKE_DIRECTORY "${SOURCE_PATH}/External/build")
            message(STATUS "Symlink xcframework folder for ${camelcase}")
            vcpkg_execute_required_process(
                COMMAND ${CMAKE_COMMAND}
                    -E create_symlink
                    "${SOURCE_PATH}/External/${camelcase}"
                    "${SOURCE_PATH}/External/build/Latest"
                WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
                LOGNAME "create-symlink-xcframework-${TARGET_TRIPLET}-${shorthand}"
            )
            # NOTE END MoltenVK specific

            file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-${shorthand}")
            message(STATUS "Building ${arg_PROJECT_PATH} for ${camelcase}")

            vcpkg_execute_required_process(
                COMMAND xcodebuild
                    -project "${arg_PROJECT_PATH}"
                    -configuration "${arg_${uppercase}_CONFIGURATION}"
                    ${arg_OPTIONS}
                    ${arg_OPTIONS_${uppercase}}
                    build
                WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-${shorthand}"
                LOGNAME "build-${TARGET_TRIPLET}-${shorthand}"
            )

            # NOTE BEGIN MoltenVK specific
            message(STATUS "Remove symlink xcframework folder for ${camelcase}")
            vcpkg_execute_required_process(
                COMMAND ${CMAKE_COMMAND}
                    -E rm
                    "${SOURCE_PATH}/External/build/Latest"
                WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
                LOGNAME "remove-symlink-xcframework-${TARGET_TRIPLET}-${shorthand}"
            )
            # NOTE END MoltenVK specific
        endif()
    endforeach()
endfunction()

# BEGIN Mock header paths

message(STATUS "Mock headers path for SPIRV-Cross")

file(REMOVE "${SOURCE_PATH}/MoltenVKShaderConverter/SPIRV-Cross")
file(MAKE_DIRECTORY "${SOURCE_PATH}/MoltenVKShaderConverter/SPIRV-Cross/include")
file(COPY "${CURRENT_INSTALLED_DIR}/include/spirv_cross" 
    DESTINATION "${SOURCE_PATH}/MoltenVKShaderConverter/SPIRV-Cross/include/"
)
file(GLOB spirv_cross_headers
    LIST_DIRECTORIES false
    "${CURRENT_INSTALLED_DIR}/include/spirv_cross/*"
)
file(COPY ${spirv_cross_headers} 
    DESTINATION "${SOURCE_PATH}/MoltenVKShaderConverter/SPIRV-Cross/"
)

message(STATUS "Mock headers path for glslang")

file(REMOVE "${SOURCE_PATH}/MoltenVKShaderConverter/glslang")
file(MAKE_DIRECTORY "${SOURCE_PATH}/MoltenVKShaderConverter/glslang/External/spirv-tools/include")
file(COPY "${CURRENT_INSTALLED_DIR}/include/spirv-tools" 
    DESTINATION "${SOURCE_PATH}/MoltenVKShaderConverter/glslang/External/spirv-tools/include/"
)

message(STATUS "Mock headers path for vulkan-headers")

file(REMOVE "${SOURCE_PATH}/MoltenVK/include/vk_video")
file(REMOVE "${SOURCE_PATH}/MoltenVK/include/vulkan")

file(COPY "${CURRENT_INSTALLED_DIR}/include/vk_video" 
    DESTINATION "${SOURCE_PATH}/MoltenVK/include/"
)
file(COPY "${CURRENT_INSTALLED_DIR}/include/vulkan" 
    DESTINATION "${SOURCE_PATH}/MoltenVK/include/"
)

message(STATUS "Mock headers path for cereal")

file(MAKE_DIRECTORY "${SOURCE_PATH}/External/cereal/include")
file(COPY "${CURRENT_INSTALLED_DIR}/include/cereal" 
    DESTINATION "${SOURCE_PATH}/External/cereal/include/"
)

# END Mock header paths

stage_headers("SPIRVCross" 
    "spirv_cross"
)

stage_headers("SPIRVTools" 
    "spirv"
    "spirv-tools"
)

stage_headers("glslang" 
    "glslang"
)

combine_libraries("SPIRVCross" 
    "spirv-cross-c"
    "spirv-cross-core"
    "spirv-cross-cpp"
    "spirv-cross-glsl"
    "spirv-cross-hlsl"
    "spirv-cross-msl"
    "spirv-cross-reflect"
    "spirv-cross-util"
)

combine_libraries("SPIRVTools" 
    "SPIRV-Tools-diff"
    "SPIRV-Tools-link"
    "SPIRV-Tools-lint"
    "SPIRV-Tools-opt"
    "SPIRV-Tools-reduce"
    "SPIRV-Tools"
)

combine_libraries("glslang" 
    "GenericCodeGen"
    "glslang"
    "glslang-default-resource-limits"
    "HLSL"
    "MachineIndependent"
    "OGLCompiler"
    "OSDependent"
    "SPIRV"
    "SPVRemapper"
)

create_xcframework("SPIRVCross")
create_xcframework("SPIRVTools")
create_xcframework("glslang")

vcpkg_xcode_build(
    PROJECT_PATH "${SOURCE_PATH}/MoltenVKPackaging.xcodeproj"
    SCHEME "MoltenVK Package (macOS only)"
)

file(INSTALL
        "${SOURCE_PATH}/Package/Release/MoltenVK/include/MoltenVK"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include/"
)

file(INSTALL
        "${SOURCE_PATH}/Package/Release/MoltenVKShaderConverter/include/MoltenVKShaderConverter"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include/"
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        file(INSTALL
                "${SOURCE_PATH}/Package/Debug/MoltenVK/macOS/MoltenVK_icd.json"
                "${SOURCE_PATH}/Package/Debug/MoltenVK/macOS/libMoltenVK.dylib.dSYM"
                "${SOURCE_PATH}/Package/Debug/MoltenVK/macOS/libMoltenVK.dylib"
            DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/"
        )
    endif()
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        file(INSTALL
                "${SOURCE_PATH}/Package/Release/MoltenVK/macOS/MoltenVK_icd.json"
                "${SOURCE_PATH}/Package/Release/MoltenVK/macOS/libMoltenVK.dylib.dSYM"
                "${SOURCE_PATH}/Package/Release/MoltenVK/macOS/libMoltenVK.dylib"
            DESTINATION "${CURRENT_PACKAGES_DIR}/lib/"
        )
    endif()
else()
    if(VCPKG_TARGET_IS_OSX)
        if(VCPKG_OSX_ARCHITECTURES STREQUAL "x86_64")
            set(xcframework_subpath "macos-x86_64")
        elseif(VCPKG_OSX_ARCHITECTURES STREQUAL "arm64")
            set(xcframework_subpath "macos-arm64")
        else()
            message(FATAL_ERROR "Unexpected architecture")
        endif()
    else()
        message(FATAL_ERROR "Unexpected platform")
    endif()

    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        file(INSTALL "${SOURCE_PATH}/Package/Debug/MoltenVK/MoltenVK.xcframework/${xcframework_subpath}/libMoltenVK.a"
            DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/"
        )
        file(INSTALL "${SOURCE_PATH}/Package/Debug/MoltenVKShaderConverter/MoltenVKShaderConverter.xcframework/${xcframework_subpath}/libMoltenVKShaderConverter.a"
            DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/"
        )
    endif()
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        file(INSTALL "${SOURCE_PATH}/Package/Release/MoltenVK/MoltenVK.xcframework/${xcframework_subpath}/libMoltenVK.a"
            DESTINATION "${CURRENT_PACKAGES_DIR}/lib/"
        )
        file(INSTALL "${SOURCE_PATH}/Package/Release/MoltenVKShaderConverter/MoltenVKShaderConverter.xcframework/${xcframework_subpath}/libMoltenVKShaderConverter.a"
            DESTINATION "${CURRENT_PACKAGES_DIR}/lib/"
        )
    endif()
endif()

# Bonuses
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    file(INSTALL
            "${SOURCE_PATH}/Package/Debug/MoltenVK/MoltenVK.xcframework"
            "${SOURCE_PATH}/Package/Debug/MoltenVKShaderConverter/MoltenVKShaderConverter.xcframework"
        DESTINATION "${CURRENT_PACKAGES_DIR}/debug/Frameworks/"
    )
endif()
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    file(INSTALL
            "${SOURCE_PATH}/Package/Release/MoltenVK/MoltenVK.xcframework"
            "${SOURCE_PATH}/Package/Release/MoltenVKShaderConverter/MoltenVKShaderConverter.xcframework"
        DESTINATION "${CURRENT_PACKAGES_DIR}/Frameworks/"
    )
endif()

vcpkg_copy_tools(
    TOOL_NAMES MoltenVKShaderConverter
    SEARCH_DIR "${SOURCE_PATH}/Package/Release/MoltenVKShaderConverter/Tools"
)

configure_file(
    "${SOURCE_PATH}/LICENSE"
    "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright"
    COPYONLY
)
