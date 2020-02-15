set(QT_VERSION 5.12.5)
set(NINJA_VERSION 1.8.2)

vcpkg_find_acquire_program(PYTHON3)
find_program(QMAKE qmake
    PATHS
        "${CURRENT_INSTALLED_DIR}/tools/qt5/bin"
    NO_DEFAULT_PATHS
)
find_program(NINJA
    NAMES
        ninja
    HINTS
        "${VCPKG_ROOT_DIR}/downloads/tools/ninja"
    PATH_SUFFIXES
        "ninja-${NINJA_VERSION}"
    NO_DEFAULT_PATH
)

message(STATUS "QMAKE: ${QMAKE}")
message(STATUS "PYTHON3: ${PYTHON3}")
message(STATUS "CMAKE_COMMAND: ${CMAKE_COMMAND}")
message(STATUS "NINJA: ${NINJA}")

get_filename_component(NINJA_PATH ${NINJA} PATH)
vcpkg_add_to_path(${NINJA_PATH})

set(_QT_MODULES
    # Core
    # Gui
    # Test
    # Widgets
    Multimedia
)
list(JOIN _QT_MODULES "," _QT_MODULES_STRING)
message(STATUS "_QT_MODULES_STRING: ${_QT_MODULES_STRING}")

set(ENV{LLVM_INSTALL_DIR} "${CURRENT_INSTALLED_DIR}")
vcpkg_add_to_path("${CURRENT_INSTALLED_DIR}/tools/llvm")

vcpkg_download_distfile(ARCHIVE
    URLS "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${QT_VERSION}-src/pyside-setup-everywhere-src-${QT_VERSION}.tar.xz"
    FILENAME "pyside-setup-everywhere-src-${QT_VERSION}.tar.xz"
    SHA512 3c0c5b1d701e8085ff3b39effdd2c4dc042f6385ed8a222264d36b2052cdb6fde6a44e9b87c94001890c8b4e4c0f2ed6e81ab0edbdba977edfdc98fefe32809d
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    REF ${QT_VERSION}
)

vcpkg_execute_build_process(
    # COMMAND ${PYTHON3} setup.py build
    COMMAND py setup.py build
        # --prefix=${CURRENT_PACKAGES_DIR}
        --cmake=${CMAKE_COMMAND}
        --qmake=${QMAKE}
        --openssl=${CURRENT_INSTALLED_DIR}/bin
        --make-spec=ninja
        --ignore-git
        --parallel=${VCPKG_CONCURRENCY}
        --build-type=all
        --module-subset=${_QT_MODULES_STRING}
        --skip-docs
        # --skip-make-install
        # --skip-packaging
        --verbose-build
        # --standalone
    WORKING_DIRECTORY ${SOURCE_PATH}
    LOGNAME python-setup-${TARGET_TRIPLET}-release
)
# qt_build_submodule(${SOURCE_PATH})
