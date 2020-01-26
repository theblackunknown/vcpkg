# More information on Intel MKL libraries can be found at

# Developer Guide
# - https://software.intel.com/en-us/mkl-linux-developer-guide
# - https://software.intel.com/en-us/mkl-macos-developer-guide
# - https://software.intel.com/en-us/mkl-windows-developer-guide

# Developer Reference
# - https://software.intel.com/en-us/mkl-developer-reference-c

# Manual Reference
# - https://software.intel.com/en-us/articles/mkl-reference-manual

# Linking
# - https://software.intel.com/en-us/mkl-windows-developer-guide-using-the-single-dynamic-library
# - https://software.intel.com/en-us/mkl-windows-developer-guide-linking-with-interface-libraries
# - https://software.intel.com/en-us/mkl-windows-developer-guide-linking-with-threading-libraries
# - https://software.intel.com/en-us/mkl-windows-developer-guide-linking-with-computational-libraries
# - https://software.intel.com/en-us/mkl-windows-developer-guide-linking-with-compiler-run-time-libraries
# - https://software.intel.com/en-us/mkl-windows-developer-guide-redefining-memory-functions
# - https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor

# Redistribuable
# - https://software.intel.com/en-us/articles/intel-compilers-redistributable-libraries-by-version
# - https://software.intel.com/en-us/articles/redistributable-libraries-for-intel-c-and-fortran-2020-compilers-for-windows

vcpkg_fail_port_install(
    ON_TARGET
        OSX     # TODO
        LINUX   # TODO
        ANDROID
        FREEBSD
    ON_ARCH
        arm
)

# TODO
# - Cluster
# - MPI
# - message catalog

set(_DESCRIPTION_SDL                    "Intel® MKL Single Dynamic Library (SDL)")
set(_DESCRIPTION_IMALLOC                "Intel® MKL Dynamic library to support renaming of memory functions")
set(_DESCRIPTION_INTERFACE_CDECL        "Intel® MKL [Interface Layer] cdecl interface library for dynamic linking")
set(_DESCRIPTION_INTERFACE_STDCALL      "Intel® MKL [Interface Layer] CVF (stdcall) interface library for dynamic linking")
set(_DESCRIPTION_INTERFACE_LP64         "Intel® MKL [Interface Layer] LP64 (32-bit integer) interface library for the Intel compilers")
set(_DESCRIPTION_INTERFACE_ILP64        "Intel® MKL [Interface Layer] ILP64 (64-bit integer) interface library for the Intel compilers")
set(_DESCRIPTION_INTERFACE_BLAS_LP64    "Intel® MKL [Interface Layer] Fortran 95 interface library for BLAS. Supports the Intel® Fortran compiler and LP64 interface")
set(_DESCRIPTION_INTERFACE_BLAS_ILP64   "Intel® MKL [Interface Layer] Fortran 95 interface library for BLAS. Supports the Intel® Fortran compiler and ILP64 interface")
set(_DESCRIPTION_INTERFACE_LAPACK_LP64  "Intel® MKL [Interface Layer] Fortran 95 interface library for LAPACK. Supports the Intel® Fortran compiler and LP64 interface")
set(_DESCRIPTION_INTERFACE_LAPACK_ILP64 "Intel® MKL [Interface Layer] Fortran 95 interface library for LAPACK. Supports the Intel® Fortran compiler and ILP64 interface")
set(_DESCRIPTION_THREADING_OPENMP       "Intel® MKL [Threading Layer] Dynamic OpenMP threading library for the Intel compilers")
set(_DESCRIPTION_THREADING_TBB          "Intel® MKL [Threading Layer] Dynamic Intel TBB threading library for the Intel compilers")
set(_DESCRIPTION_THREADING_SEQUENTIAL   "Intel® MKL [Threading Layer] Dynamic sequential library")
set(_DESCRIPTION_COMPUTATIONAL          "Intel® MKL [Computational Layer] Core library containing processor-independent code and a dispatcher for dynamic loading of processor-specific code")
set(_DESCRIPTION_DEF                    "Intel® MKL [Computational Layer] Default kernel for the Intel® 64 architecture")
set(_DESCRIPTION_P4                     "Intel® MKL [Computational Layer] Pentium® 4 processor kernel")
set(_DESCRIPTION_P4M                    "Intel® MKL [Computational Layer] Kernel library for Intel® Supplemental Streaming SIMD Extensions 3 (Intel® SSSE3) enabled processors")
set(_DESCRIPTION_P4M3                   "Intel® MKL [Computational Layer] Kernel library for Intel® Streaming SIMD Extensions 4.2 (Intel® SSE4.2) enabled processors")
set(_DESCRIPTION_MC                     "Intel® MKL [Computational Layer] Kernel library for Intel® Supplemental Streaming SIMD Extensions 3 (Intel® SSSE3) enabled processors")
set(_DESCRIPTION_MC3                    "Intel® MKL [Computational Layer] Kernel library for Intel® Streaming SIMD Extensions 4.2 (Intel® SSE4.2) enabled processors")
set(_DESCRIPTION_AVX                    "Intel® MKL [Computational Layer] Kernel library optimized for Intel® Advanced Vector Extensions (Intel® AVX) enabled processors")
set(_DESCRIPTION_AVX2                   "Intel® MKL [Computational Layer] Kernel library optimized for Intel® Advanced Vector Extensions 2 (Intel® AVX2) enabled processors")
set(_DESCRIPTION_AVX512                 "Intel® MKL [Computational Layer] Kernel library optimized for Intel® Advanced Vector Extensions 512 (Intel® AVX-512) enabled processors")
set(_DESCRIPTION_VML_DEF                "Intel® MKL [Computational Layer] Vector Mathematics (VM)/Vector Statistics (VS)/Data Fitting (DF) part of default kernel")
set(_DESCRIPTION_VML_MC                 "Intel® MKL [Computational Layer] VM/VS/DF for Intel® SSSE3 enabled processors")
set(_DESCRIPTION_VML_MC2                "Intel® MKL [Computational Layer] VM/VS/DF for 45nm Hik Intel® Core™2 and Intel Xeon® processor families")
set(_DESCRIPTION_VML_MC3                "Intel® MKL [Computational Layer] VM/VS/DF for Intel® SSE4.2 enabled processors")
set(_DESCRIPTION_VML_P4                 "Intel® MKL [Computational Layer] Vector Mathematics (VM)/Vector Statistics (VS)/Data Fitting (DF) part of Pentium® 4 processor kernel")
set(_DESCRIPTION_VML_P4M                "Intel® MKL [Computational Layer] VM/VS/DF for Intel® SSSE3 enabled processors")
set(_DESCRIPTION_VML_P4M2               "Intel® MKL [Computational Layer] VM/VS/DF for 45nm Hik Intel® Core™2 and Intel Xeon® processor families")
set(_DESCRIPTION_VML_P4M3               "Intel® MKL [Computational Layer] VM/VS/DF for Intel® SSE4.2 enabled processors")
set(_DESCRIPTION_VML_IA                 "Intel® MKL [Computational Layer] VM/VS/DF default kernel for newer Intel® architecture processors")
set(_DESCRIPTION_VML_AVX                "Intel® MKL [Computational Layer] VM/VS/DF optimized for Intel® AVX enabled processors")
set(_DESCRIPTION_VML_AVX2               "Intel® MKL [Computational Layer] VM/VS/DF optimized for Intel® AVX2 enabled processors")
set(_DESCRIPTION_VML_AVX512             "Intel® MKL [Computational Layer] VM/VS/DF optimized for Intel® AVX-512 enabled processors")
set(_DESCRIPTION_VML_CMPT               "Intel® MKL [Computational Layer] VM/VS/DF library for conditional numerical reproducibility")

# FIXME: How to let a user should which OpenMP library to link to ?

unset(_COMPILE_DEFINITIONS)

set(_RUNTIME_LIBRARIES
    DEF
    AVX
    AVX2
    AVX512
    VML_DEF
    VML_AVX
    VML_AVX2
    VML_AVX512
    VML_CMPT
)

# TODO x86 vs x64 runtime libraries
if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    list(APPEND _RUNTIME_LIBRARIES
        MC
        MC3
        VML_MC
        VML_MC2
        VML_MC3
    )
else()
    list(APPEND _RUNTIME_LIBRARIES
        P4
        P4M
        P4M3
        VML_P4
        VML_P4M
        VML_P4M2
        VML_P4M3
        VML_IA
    )
endif()

set(_THREADING_LIBRARIES
    THREADING_SEQUENTIAL
)

if("threading-openmp" IN_LIST FEATURES)
    list(APPEND _THREADING_LIBRARIES
        THREADING_OPENMP
    )
endif()
if("threading-tbb" IN_LIST FEATURES)
    list(APPEND _THREADING_LIBRARIES
        THREADING_TBB
    )
endif()

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    list(APPEND _INTERFACE_LIBRARIES
        INTERFACE_LP64
        INTERFACE_ILP64
    )
else()
    list(APPEND _INTERFACE_LIBRARIES
        INTERFACE_CDECL
        INTERFACE_STDCALL
    )
endif()

# FIXME Fortran95 shipped libraries are compiler dependent, what should we do ?
# cf. https://software.intel.com/en-us/mkl-windows-developer-guide-linking-with-fortran-95-interface-libraries

# OS Specific

if(CMAKE_HOST_WIN32)
    set(_ProgramFilesx86 "ProgramFiles(x86)")
    set(_COMPILER_AND_LIBRARIES_ROOT_SEARCH_PATHS
        $ENV{${_ProgramFilesx86}}/IntelSWTools/compilers_and_libraries
    )

    find_path(INTEL_ROOT
        windows
        PATHS
            $ENV{INTEL_ROOT}
            ${_COMPILER_AND_LIBRARIES_ROOT_SEARCH_PATHS}
        DOC
            "Intel Compilers and Libraries folder"
    )
    get_filename_component(COMPILER_AND_LIBRARIES_ROOT "${INTEL_ROOT}/windows" REALPATH)
    get_filename_component(MKL_ROOT                    "${INTEL_ROOT}/windows/mkl" REALPATH)
endif()

message(STATUS "[${PORT}] MKL_ROOT: ${MKL_ROOT}")

if (NOT MKL_ROOT)
    message(FATAL_ERROR
        "Could not find Intel Compilers and Libraries folder."
        "Before continuing, please download and install Intel MKL (2020 or higher) from:"
        " https://registrationcenter.intel.com/en/products"
    )
endif()

file(STRINGS "${MKL_ROOT}/include/mkl_version.h" MKL_VERSION_LINE REGEX "__INTEL_MKL__")
string(REGEX MATCH "([0-9]+)" VERSION_MAJOR ${MKL_VERSION_LINE})
file(STRINGS "${MKL_ROOT}/include/mkl_version.h" MKL_VERSION_LINE REGEX "__INTEL_MKL_MINOR__")
string(REGEX MATCH "([0-9]+)" VERSION_MINOR ${MKL_VERSION_LINE})
file(STRINGS "${MKL_ROOT}/include/mkl_version.h" MKL_VERSION_LINE REGEX "__INTEL_MKL_UPDATE__")
string(REGEX MATCH "([0-9]+)" VERSION_PATCH ${MKL_VERSION_LINE})

message(STATUS "[${PORT}] Host version: ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")

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

get_filename_component(_PATH_ARCHIVE_FOLDER "${COMPILER_AND_LIBRARIES_ROOT}/mkl/lib/${_ARCH_FOLDER}"    REALPATH)
get_filename_component(_PATH_RUNTIME_FOLDER "${COMPILER_AND_LIBRARIES_ROOT}/redist/${_ARCH_FOLDER}/mkl" REALPATH)

# Linkage specific
# CMake target type of each MKL library
set(_TYPE_SDL                  SHARED)
set(_TYPE_INTERFACE_STDCALL    STATIC)
set(_TYPE_INTERFACE_CDECL      STATIC)
set(_TYPE_INTERFACE_LP64       STATIC)
set(_TYPE_INTERFACE_ILP64      STATIC)
if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(_TYPE_THREADING_OPENMP     SHARED)
    set(_TYPE_THREADING_TBB        SHARED)
    set(_TYPE_THREADING_SEQUENTIAL SHARED)
    set(_TYPE_COMPUTATIONAL        SHARED)
else()
    set(_TYPE_THREADING_OPENMP     STATIC)
    set(_TYPE_THREADING_TBB        STATIC)
    set(_TYPE_THREADING_SEQUENTIAL STATIC)
    set(_TYPE_COMPUTATIONAL        STATIC)
endif()
set(_TYPE_DEF        MODULE)
set(_TYPE_MC         MODULE)
set(_TYPE_MC3        MODULE)
set(_TYPE_P4         MODULE)
set(_TYPE_P4M        MODULE)
set(_TYPE_P4M3       MODULE)
set(_TYPE_AVX        MODULE)
set(_TYPE_AVX2       MODULE)
set(_TYPE_AVX512     MODULE)
set(_TYPE_VML_DEF    MODULE)
set(_TYPE_VML_MC     MODULE)
set(_TYPE_VML_MC2    MODULE)
set(_TYPE_VML_MC3    MODULE)
set(_TYPE_VML_P4     MODULE)
set(_TYPE_VML_P4M    MODULE)
set(_TYPE_VML_P4M2   MODULE)
set(_TYPE_VML_P4M3   MODULE)
set(_TYPE_VML_IA     MODULE)
set(_TYPE_VML_AVX    MODULE)
set(_TYPE_VML_AVX2   MODULE)
set(_TYPE_VML_AVX512 MODULE)
set(_TYPE_VML_CMPT   MODULE)
set(_TYPE_IMALLOC    MODULE)

# Library basename of what should be used when for dynamic or static build
set(_BASENAME_SDL                          "mkl_rt")
set(_BASENAME_INTERFACE_STDCALL_STATIC     "mkl_intel_s")
set(_BASENAME_INTERFACE_STDCALL_DYNAMIC    "mkl_intel_s_dll")
set(_BASENAME_INTERFACE_CDECL_STATIC       "mkl_intel_c")
set(_BASENAME_INTERFACE_CDECL_DYNAMIC      "mkl_intel_c_dll")
set(_BASENAME_INTERFACE_LP64_STATIC        "mkl_intel_lp64")
set(_BASENAME_INTERFACE_LP64_DYNAMIC       "mkl_intel_lp64_dll")
set(_BASENAME_INTERFACE_ILP64_STATIC       "mkl_intel_ilp64")
set(_BASENAME_INTERFACE_ILP64_DYNAMIC      "mkl_intel_ilp64_dll")
set(_BASENAME_THREADING_OPENMP_STATIC      "mkl_intel_thread")
set(_BASENAME_THREADING_OPENMP_DYNAMIC     "mkl_intel_thread")
set(_BASENAME_THREADING_OPENMP_IMPLIB      "mkl_intel_thread_dll")
set(_BASENAME_THREADING_TBB_STATIC         "mkl_tbb_thread")
set(_BASENAME_THREADING_TBB_DYNAMIC        "mkl_tbb_thread")
set(_BASENAME_THREADING_TBB_IMPLIB         "mkl_tbb_thread_dll")
set(_BASENAME_THREADING_SEQUENTIAL_STATIC  "mkl_sequential")
set(_BASENAME_THREADING_SEQUENTIAL_DYNAMIC "mkl_sequential")
set(_BASENAME_THREADING_SEQUENTIAL_IMPLIB  "mkl_sequential_dll")
set(_BASENAME_COMPUTATIONAL_STATIC         "mkl_core")
set(_BASENAME_COMPUTATIONAL_DYNAMIC        "mkl_core")
set(_BASENAME_COMPUTATIONAL_IMPLIB         "mkl_core_dll")
set(_BASENAME_DEF                          "mkl_def")
set(_BASENAME_P4                           "mkl_p4")
set(_BASENAME_P4M                          "mkl_p4m")
set(_BASENAME_P4M3                         "mkl_p4m3")
set(_BASENAME_MC                           "mkl_mc")
set(_BASENAME_MC3                          "mkl_mc3")
set(_BASENAME_AVX                          "mkl_avx")
set(_BASENAME_AVX2                         "mkl_avx2")
set(_BASENAME_AVX512                       "mkl_avx512")
set(_BASENAME_VML_DEF                      "mkl_vml_def")
set(_BASENAME_VML_MC                       "mkl_vml_mc")
set(_BASENAME_VML_MC2                      "mkl_vml_mc2")
set(_BASENAME_VML_MC3                      "mkl_vml_mc3")
set(_BASENAME_VML_P4                       "mkl_vml_p4")
set(_BASENAME_VML_P4M                      "mkl_vml_p4m")
set(_BASENAME_VML_P4M2                     "mkl_vml_p4m2")
set(_BASENAME_VML_P4M3                     "mkl_vml_p4m3")
set(_BASENAME_VML_ia                       "mkl_vml_ia")
set(_BASENAME_VML_AVX                      "mkl_vml_avx")
set(_BASENAME_VML_AVX2                     "mkl_vml_avx2")
set(_BASENAME_VML_AVX512                   "mkl_vml_avx512")
set(_BASENAME_VML_CMPT                     "mkl_vml_cmpt")
set(_BASENAME_IMALLOC                      "imalloc")

set(_LOCATION_IMPLIB "${_PATH_ARCHIVE_FOLDER}")
set(_LOCATION_MODULE "${_PATH_RUNTIME_FOLDER}")
set(_LOCATION_STATIC "${_PATH_ARCHIVE_FOLDER}")
set(_LOCATION_SHARED "${_PATH_RUNTIME_FOLDER}")

# Library searching

function(_search_library NAME TYPE OUT_PATH)
    if(DEFINED _BASENAME_${NAME})
        set(_BASENAME "${_BASENAME_${NAME}}")
    elseif(DEFINED _BASENAME_${NAME}_${TYPE})
        set(_BASENAME "${_BASENAME_${NAME}_${TYPE}}")
    else()
        string(TOUPPER ${VCPKG_LIBRARY_LINKAGE} _VCPKG_LIBRARY_LINKAGE_UPPER)
        set(_BASENAME "${_BASENAME_${NAME}_${_VCPKG_LIBRARY_LINKAGE_UPPER}}")
    endif()

    set(_LOCATION    "${_LOCATION_${TYPE}}")
    set(_DESCRIPTION "${_DESCRIPTION_${NAME}}")

    message(STATUS "[${PORT}] NAME    : ${NAME}")
    message(STATUS "[${PORT}] TYPE    : ${TYPE}")
    message(STATUS "[${PORT}] BASENAME: ${_BASENAME}")
    message(STATUS "[${PORT}] LOCATION: ${_LOCATION}")

    find_library(_PATH_${NAME}_${TYPE}
        NAMES
            ${_BASENAME}
        HINTS
            "${_LOCATION}"
        DOC
            ${_DESCRIPTION}
        NO_DEFAULT_PATH
        NO_CMAKE_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
    )
    set(_PATH ${_PATH_${NAME}_${TYPE}})
    message(STATUS "[${PORT}] _PATH   : ${_PATH}")
    if(NOT _PATH)
        message(FATAL_ERROR
            "[${PORT}] ${_DESCRIPTION} ${NAME} is missing, fix your Intel MKL installation.\n"
            "Expected basename : '${_BASENAME}'\n"
            "Expected location : '${_LOCATION}'\n"
        )
    endif()
    set(${OUT_PATH} ${_PATH} PARENT_SCOPE)
endfunction()

function(_search_and_install_library NAME)
    set(TYPE        ${_TYPE_${NAME}})
    set(DESCRIPTION ${_DESCRIPTION_${NAME}})
    message(STATUS "[${PORT}] NAME       : ${NAME}")
    message(STATUS "[${PORT}] TYPE       : ${TYPE}")
    message(STATUS "[${PORT}] DESCRIPTION: ${DESCRIPTION}")

    _search_library(${NAME} ${TYPE} _PATH)

    if(TYPE STREQUAL SHARED)
        file(INSTALL "${_PATH}"        DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
        file(INSTALL "${_PATH}"        DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
        if(CMAKE_HOST_WIN32)
            _search_library(${NAME} IMPLIB _PATH_IMPLIB)
            file(INSTALL "${_PATH_IMPLIB}" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
            file(INSTALL "${_PATH_IMPLIB}" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
        endif()
    elseif(TYPE STREQUAL MODULE)
        file(INSTALL "${_PATH}" DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
        file(INSTALL "${_PATH}" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
    elseif(TYPE STREQUAL STATIC)
        file(INSTALL "${_PATH}" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
        file(INSTALL "${_PATH}" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
    else()
        message(FATAL_ERROR "Unexpected ${TYPE}")
    endif()

    string(TOLOWER ${NAME} NAME_LOWER)
    string(TOLOWER ${TYPE} TYPE_LOWER)

    # configure_file variables
    set(TARGET_NAME                       ${NAME_LOWER})
    set(COMPILE_DEFINITIONS               ${_COMPILE_DEFINITIONS})
    get_filename_component(FILENAME_LOCATION "${_PATH}"        NAME)
    message(STATUS "[${PORT}] FILENAME_LOCATION: ${FILENAME_LOCATION}")

    if(DEFINED _PATH_IMPLIB)
        get_filename_component(FILENAME_IMPLIB   "${_PATH_IMPLIB}" NAME)
        message(STATUS "[${PORT}] FILENAME_IMPLIB  : ${FILENAME_IMPLIB}")
    endif()

    set(_PATH_CONFIG "${CURRENT_PACKAGES_DIR}/share/${PORT}/intel-mkl-config-${NAME_LOWER}.cmake")

    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/config-${NAME_LOWER}-${TYPE_LOWER}.cmake.in")
        set(_PATH_TEMPLATE "${CMAKE_CURRENT_LIST_DIR}/config-${NAME_LOWER}-${TYPE_LOWER}.cmake.in")
        message(STATUS "[${PORT}] CONFIG TEMPLATE: ${_PATH_TEMPLATE}")
    else()
        set(_PATH_TEMPLATE "${CMAKE_CURRENT_LIST_DIR}/config-library-${TYPE_LOWER}.cmake.in")
        message(STATUS "[${PORT}] CONFIG TEMPLATE: ${_PATH_TEMPLATE}")
    endif()

    configure_file("${_PATH_TEMPLATE}" "${_PATH_CONFIG}" @ONLY)
    message(STATUS "${_PATH_CONFIG} written")

    unset(COMPILE_DEFINITIONS)
    unset(_PATH_CONFIG)
    unset(FILENAME_IMPLIB)
    unset(FILENAME_LOCATION)
    unset(TARGET_NAME)
endfunction()

list(APPEND _LIBRARIES
    SDL
    IMALLOC
)
foreach(_LIBRARY IN LISTS _INTERFACE_LIBRARIES)
    list(APPEND _LIBRARIES ${_LIBRARY})
endforeach()
foreach(_LIBRARY IN LISTS _THREADING_LIBRARIES)
    list(APPEND _LIBRARIES ${_LIBRARY})
endforeach()
list(APPEND _LIBRARIES
    COMPUTATIONAL
)
foreach(_LIBRARY IN LISTS _RUNTIME_LIBRARIES)
    list(APPEND _LIBRARIES ${_LIBRARY})
endforeach()
# CMake Package installation

set(PACKAGENAME      intel-mkl)
set(TARGET_NAMESPACE intel-mkl)

# Pass 1. Search libraries artefact, install them and corresponding CMake config

foreach(_NAME ${_LIBRARIES})
    _search_and_install_library(${_NAME})
endforeach()

# Pass 2. Install CMake Package config & version
list(JOIN _LIBRARIES " " PACKAGE_REQUIRED_COMPONENTS)
string(TOLOWER ${PACKAGE_REQUIRED_COMPONENTS} PACKAGE_REQUIRED_COMPONENTS)

foreach(_RUNTIME_LIBRARY IN LISTS _RUNTIME_LIBRARIES)
    list(APPEND PACKAGE_RUNTIME_COMPONENTS ${TARGET_NAMESPACE}::${_RUNTIME_LIBRARY})
endforeach()
list(JOIN PACKAGE_RUNTIME_COMPONENTS " " PACKAGE_RUNTIME_COMPONENTS)
string(TOLOWER ${PACKAGE_RUNTIME_COMPONENTS} PACKAGE_RUNTIME_COMPONENTS)

set(PACKAGE_DEFAULT_COMPONENTS sdl)

foreach(_CONFIG config config-version)
    set(_PATH_CONFIG "${CURRENT_PACKAGES_DIR}/share/${PORT}/intel-mkl-${_CONFIG}.cmake")
    configure_file("${CMAKE_CURRENT_LIST_DIR}/${_CONFIG}.cmake.in" "${_PATH_CONFIG}" @ONLY)
    message(STATUS "${_PATH_CONFIG} written")
endforeach()
unset(PACKAGENAME)

# headers
file(INSTALL
        "${MKL_ROOT}/include"
    DESTINATION
        "${CURRENT_PACKAGES_DIR}/include"
    RENAME
        mkl
)

# Copyright
file(INSTALL "${INTEL_ROOT}/licensing/mkl/en/license.rtf" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${INTEL_ROOT}/licensing/mkl/en/license.rtf" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
