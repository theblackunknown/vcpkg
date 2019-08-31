cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

if(arnold_FIND_COMPONENTS)
  set(_REQUIRED_TARGETS ${arnold_FIND_COMPONENTS})
else( )
  set(_REQUIRED_TARGETS)
endif( )

function(verify_path description path)
  if(NOT EXISTS "${path}")
      message(FATAL_ERROR "${description} is not found at the expected location: ${path}
Possible reasons include:
* The path was deleted, renamed, or moved to another location.
* An install or uninstall procedure did not complete successfully.
* The installation package was faulty and contained
   \"${CMAKE_CURRENT_LIST_FILE}\"
but not all the files it references.
")
  endif()
endfunction()

include(FindPackageMessage)

get_filename_component(ARNOLD_SDK_FOLDER "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)

verify_path("Arnold SDK include directory"       "${ARNOLD_SDK_FOLDER}/include"   )
verify_path("Arnold SDK Debug archive library"   "${ARNOLD_SDK_FOLDER}/lib/ai.lib")
verify_path("Arnold SDK Release archive library" "${ARNOLD_SDK_FOLDER}/bin/ai.dll")

add_library(arnold SHARED IMPORTED)

target_include_directories(arnold SYSTEM
    INTERFACE
        "${ARNOLD_SDK_FOLDER}/include"
        "${ARNOLD_SDK_FOLDER}/include/arnold"
)

set_target_properties(arnold
    PROPERTIES
        IMPORTED_IMPLIB   "${ARNOLD_SDK_FOLDER}/lib/ai.lib"
        IMPORTED_LOCATION "${ARNOLD_SDK_FOLDER}/bin/ai.dll"
        PUBLIC_HEADER
            "${ARNOLD_SDK_FOLDER}/include/ai.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_allocate.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_api.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_array.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_bbox.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_cameras.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_closure.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_color.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_color_managers.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_comparison.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_constants.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_critsec.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_deprecated.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_device.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_dotass.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_drivers.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_driver_utils.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_enum.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_filters.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_license.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_materialx.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_math.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_matrix.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_matrix_private.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_metadata.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_msg.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_nodes.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_node_entry.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_noise.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_operator.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_params.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_plugins.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_procedural.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_ray.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_render.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_sampler.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shaderglobals.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shaders.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_aovs.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_bsdf.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_closure.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_lights.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_message.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_parameval.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_radiance.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_sample.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_sss.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_userdef.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_util.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_shader_volume.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_stats.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_string.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_texture.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_threads.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_unit_test.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_universe.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_vector.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_version.h"
            "${ARNOLD_SDK_FOLDER}/include/ai_volume.h"
)

find_package_message(arnold
  "Found Arnold SDK library: ${ARNOLD_SDK_FOLDER}/include/arnold"
  "[${ARNOLD_SDK_FOLDER}/include][${ARNOLD_SDK_FOLDER}/lib/ai.lib][${ARNOLD_SDK_FOLDER}/bin/ai.dll]"
)
