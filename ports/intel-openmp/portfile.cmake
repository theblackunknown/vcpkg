# More information on Intel OpenMP Compatibility Layer libraries can be found at
# - https://software.intel.com/en-us/cpp-compiler-developer-guide-and-reference-openmp-support-libraries
# - https://software.intel.com/en-us/articles/how-to-use-intelr-compiler-openmp-compatibility-libraries-on-windows

vcpkg_fail_port_install(
    ON_TARGET
        OSX
        LINUX
        ANDROID
        FREEBSD
    ON_ARCH
        arm
)

# cf. https://software.intel.com/en-us/cpp-compiler-developer-guide-and-reference-openmp-support
set(OPEN_VERSION_MAJOR 4)
set(OPEN_VERSION_MINOR 5)
set(OPEN_VERSION_PATCH 0)

list(APPEND _LIBRARY_NAMES
    PERFORMANCE
    PERFORMANCE_PROFILE
    STUB
)

set(_DESCRIPTION_PERFORMANCE
    "Intel OpenMP Compatibility Layer library"
)
set(_DESCRIPTION_PERFORMANCE_PROFILE
    "Intel OpenMP Compatibility Layer library (with profiling)"
)
set(_DESCRIPTION_STUB
    "Intel OpenMP Compatibility Layer library (serial execution)"
)

# OS Specific

if(CMAKE_HOST_WIN32)
    set(_ProgramFilesx86 "ProgramFiles(x86)")
    set(_COMPILER_AND_LIBRARIES_ROOT_SEARCH_PATHS
        $ENV{${_ProgramFilesx86}}/IntelSWTools/compilers_and_libraries
    )

    # NOTE: https://software.intel.com/en-us/forums/intel-math-kernel-library/topic/328168
    # vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

    # Intel does not ship static libraries
    set(VCPKG_LIBRARY_LINKAGE dynamic)

    # Intel does not ship debug libraries
    set(VCPKG_BUILD_TYPE      release)

    find_path(INTEL_ROOT
        windows
        PATHS
            $ENV{INTEL_ROOT}
            ${_COMPILER_AND_LIBRARIES_ROOT_SEARCH_PATHS}
        DOC
            "Intel Compilers and Libraries folder"
    )
    get_filename_component(COMPILER_AND_LIBRARIES_ROOT "${INTEL_ROOT}/windows" REALPATH)

    # Intel does not ship performance profile library
    list(REMOVE_ITEM _LIBRARY_NAMES PERFORMANCE_PROFILE)

    # Whether shipped or not, here are expected library name
    set(_BASENAME_PERFORMANCE_DYNAMIC         "libiomp5md")
    set(_BASENAME_PERFORMANCE_STATIC          "libiomp5mt")
    set(_BASENAME_PERFORMANCE_PROFILE_DYNAMIC "libiompprof5md")
    set(_BASENAME_PERFORMANCE_PROFILE_STATIC  "libiompprof5mt")
    set(_BASENAME_STUB_DYNAMIC                "libiompstubs5md")
    set(_BASENAME_STUB_STATIC                 "libiompstubs5mt")
endif()

message(STATUS "[${PORT}] COMPILER_AND_LIBRARIES_ROOT: ${COMPILER_AND_LIBRARIES_ROOT}")

if (NOT COMPILER_AND_LIBRARIES_ROOT)
    message(FATAL_ERROR
        "Could not find Intel Compilers and Libraries folder."
        "Before continuing, please download and install Intel MKL (2020 or higher) from:"
        " https://registrationcenter.intel.com/en/products"
    )
endif()

# Arch Specific

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(_ARCH_FOLDER "intel64")
elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(_ARCH_FOLDER "ia32")
else()
    message(FATAL_ERROR
        "Unsupported archicture : \"${VCPKG_TARGET_ARCHITECTURE}\"."
        "Supported ones are \"x64\" or \"x86\"")
endif()

get_filename_component(_PATH_ARCHIVE_FOLDER "${COMPILER_AND_LIBRARIES_ROOT}/compiler/lib/${_ARCH_FOLDER}"    REALPATH)
get_filename_component(_PATH_RUNTIME_FOLDER "${COMPILER_AND_LIBRARIES_ROOT}/redist/${_ARCH_FOLDER}/compiler" REALPATH)

# Linkage specific

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    string(TOUPPER ${VCPKG_LIBRARY_LINKAGE} _VCPKG_LIBRARY_LINKAGE_UPPER)
    foreach(_LIBRARYNAME ${_LIBRARY_NAMES})
        set(_TYPE_${_LIBRARYNAME}            SHARED)
        set(_BASENAME_${_LIBRARYNAME}        ${_BASENAME_${_LIBRARYNAME}_${_VCPKG_LIBRARY_LINKAGE_UPPER}})
        set(_LOCATION_${_LIBRARYNAME}        "${_PATH_RUNTIME_FOLDER}")
        set(_LOCATION_${_LIBRARYNAME}_IMPLIB "${_PATH_ARCHIVE_FOLDER}")
    endforeach()
elseif(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    foreach(_LIBRARYNAME ${_LIBRARY_NAMES})
        set(_TYPE_${_LIBRARYNAME}     STATIC)
        set(_BASENAME_${_LIBRARYNAME} ${_BASENAME_${_LIBRARYNAME}_${_VCPKG_LIBRARY_LINKAGE_UPPER}})
        set(_LOCATION_${_LIBRARYNAME} "${_PATH_ARCHIVE_FOLDER}")
    endforeach()
endif()

# Library searching

unset(_ARCHIVES)
unset(_RUNTIMES)
foreach(_LIBRARYNAME ${_LIBRARY_NAMES})
    message(STATUS "[${PORT}] _BASENAME_${_LIBRARYNAME}   : ${_BASENAME_${_LIBRARYNAME}}")
    message(STATUS "[${PORT}] _LOCATION_${_LIBRARYNAME}   : ${_LOCATION_${_LIBRARYNAME}}")
    message(STATUS "[${PORT}] _DESCRIPTION_${_LIBRARYNAME}: ${_DESCRIPTION_${_LIBRARYNAME}}")
    find_library(_PATH_${_LIBRARYNAME}
        NAMES
            ${_BASENAME_${_LIBRARYNAME}}
        HINTS
            "${_LOCATION_${_LIBRARYNAME}}"
        DOC
            ${_DESCRIPTION_${_LIBRARYNAME}}
        NO_DEFAULT_PATH
        NO_CMAKE_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
    )
    message(STATUS "[${PORT}] _PATH_${_LIBRARYNAME}: ${_PATH_${_LIBRARYNAME}}")
    if(NOT _PATH_${_LIBRARYNAME})
        message(FATAL_ERROR
            "[${PORT}] Library ${_LIBRARYNAME} is missing, fix your Intel MKL installation.\n"
            "Expected basename : '${_BASENAME_${_LIBRARYNAME}}'\n"
            "Expected location : '${_LOCATION_${_LIBRARYNAME}}'\n"
        )
    endif()

    if(_TYPE_${_LIBRARYNAME} STREQUAL SHARED)
        list(APPEND _RUNTIMES "${_PATH_${_LIBRARYNAME}}")

        file(INSTALL
                "${_PATH_${_LIBRARYNAME}}"
            DESTINATION
                "${CURRENT_PACKAGES_DIR}/bin"
        )

        file(INSTALL
                "${_PATH_${_LIBRARYNAME}}"
            DESTINATION
                "${CURRENT_PACKAGES_DIR}/debug/bin"
        )

        message(STATUS "[${PORT}] _LOCATION_${_LIBRARYNAME}_IMPLIB: ${_LOCATION_${_LIBRARYNAME}_IMPLIB}")
        find_library(_PATH_${_LIBRARYNAME}_IMPLIB
            NAMES
                ${_BASENAME_${_LIBRARYNAME}}
            HINTS
                "${_LOCATION_${_LIBRARYNAME}_IMPLIB}"
            DOC
                ${_DESCRIPTION_${_LIBRARYNAME}}
            NO_DEFAULT_PATH
            NO_CMAKE_PATH
            NO_CMAKE_ENVIRONMENT_PATH
            NO_SYSTEM_ENVIRONMENT_PATH
            NO_CMAKE_SYSTEM_PATH
        )
        message(STATUS "[${PORT}] _PATH_${_LIBRARYNAME}_IMPLIB: ${_PATH_${_LIBRARYNAME}_IMPLIB}")

        if(NOT _PATH_${_LIBRARYNAME}_IMPLIB)
            message(FATAL_ERROR
                "[${PORT}] Library ${_LIBRARYNAME} is missing, fix your Intel MKL installation.\n"
                "Expected basename : '${_BASENAME_${_LIBRARYNAME}}'\n"
                "Expected location : '${_LOCATION_${_LIBRARYNAME}_IMPLIB}'\n"
            )
        endif()

        file(INSTALL
                "${_PATH_${_LIBRARYNAME}_IMPLIB}"
            DESTINATION
                "${CURRENT_PACKAGES_DIR}/lib"
        )

        file(INSTALL
                "${_PATH_${_LIBRARYNAME}_IMPLIB}"
            DESTINATION
                "${CURRENT_PACKAGES_DIR}/debug/lib"
        )

        list(APPEND _ARCHIVES "${_PATH_${_LIBRARYNAME}_IMPLIB}")
    elseif(_TYPE_${_LIBRARYNAME} STREQUAL STATIC)
        list(APPEND _ARCHIVES "${_PATH_${_LIBRARYNAME}}")

        file(INSTALL
                "${_PATH_${_LIBRARYNAME}}"
            DESTINATION
                "${CURRENT_PACKAGES_DIR}/lib"
        )
    endif()
endforeach()
message(STATUS "[${PORT}] _ARCHIVES: ${_ARCHIVES}")
message(STATUS "[${PORT}] _RUNTIMES: ${_RUNTIMES}")

set(CONFIG_FILENAMES
    intel-openmp-config
    intel-openmp-config-version
)
foreach(CONFIG_FILENAME ${CONFIG_FILENAMES})
    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/${CONFIG_FILENAME}.cmake.in"
        "${CURRENT_PACKAGES_DIR}/share/${PORT}/${CONFIG_FILENAME}.cmake"
        @ONLY
    )
    message(STATUS "${CURRENT_PACKAGES_DIR}/share/${PORT}/${CONFIG_FILENAME}.cmake written")
endforeach()

foreach(_LIBRARYNAME ${_LIBRARY_NAMES})
    string(TOLOWER ${_LIBRARYNAME} _LIBRARYNAME_LOWER)
    string(TOLOWER ${_TYPE_${_LIBRARYNAME}} _LIBRARYTYPE_LOWER)

    set(DESCRIPTION                                ${_DESCRIPTION_${_LIBRARYNAME}})
    get_filename_component(FILENAME_LIBRARY        "${_PATH_${_LIBRARYNAME}}" NAME)
    get_filename_component(FILENAME_LIBRARY_IMPLIB "${_PATH_${_LIBRARYNAME}_IMPLIB}" NAME)
    message(STATUS "FILENAME_LIBRARY: ${FILENAME_LIBRARY}")
    message(STATUS "FILENAME_LIBRARY_IMPLIB: ${FILENAME_LIBRARY_IMPLIB}")

    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/intel-openmp-config-${_LIBRARYTYPE_LOWER}-${_LIBRARYNAME_LOWER}.cmake.in"
        "${CURRENT_PACKAGES_DIR}/share/${PORT}/intel-openmp-config-${_LIBRARYNAME_LOWER}.cmake"
        @ONLY
    )
    message(STATUS "${CURRENT_PACKAGES_DIR}/share/${PORT}/intel-openmp-config-${_LIBRARYNAME_LOWER}.cmake written")
endforeach()

# We are not an empty package, but Intel does not ship OpenMP headers
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/include")
file(TOUCH "${CURRENT_PACKAGES_DIR}/include/omp.h.dummy")

# Copyright
file(INSTALL "${INTEL_ROOT}/licensing/mkl/en/license.rtf" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${INTEL_ROOT}/licensing/mkl/en/license.rtf" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
