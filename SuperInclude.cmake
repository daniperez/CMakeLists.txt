# - Downloads a CMake script found in a github repository. The script
# is downloaded only if it's not already found locally. 
#
# The parameters to be supplied are:
#
#   USER            Github user.
#
#   REPO            Github repository.
#
#   PATH_TO_SCRIPT  Path to the script file in Github repository.
#
# To do:
#
#   - check MD5 signatures if found in the repo.
#   - it would be great if github_download were github_include
#     and avoid this way always having to include the module.
#     We do this way because include is scope sensitive. 
# 
# Dani Perez (c) 2012
#
function ( github_download USER REPO PATH_TO_SCRIPT )

  set ( url "https://raw.github.com/${USER}/${REPO}/master/${PATH_TO_SCRIPT}" )

  set ( HOME "$ENV{HOME}" )

  if ( HOME )

    set ( destination_dir "$ENV{HOME}/.cmake/superinclude" )

  elseif ( WIN32 )

    set ( destination_dir "$ENV{APPDATA}/.cmake/superinclude" ) 

  else ()

    message ( FATAL_ERROR "Cannot locate HOME folder" )

  endif ()

  get_filename_component ( module_filename    "${PATH_TO_SCRIPT}" NAME )
  get_filename_component ( module_filename_we "${PATH_TO_SCRIPT}" NAME_WE )

  set ( destination "${destination_dir}/${module_filename}" )

  if ( NOT EXISTS "${destination}" )

    message ( STATUS "SuperInclude -- Downloading ${url}" )

    file ( DOWNLOAD "${url}" "${destination}"
           STATUS status
           SHOW_PROGRESS )

    list( GET status 0 status_value )
    list( GET status 1 status_error )

    if ( NOT status_value EQUAL 0 )

      message ( FATAL_ERROR "Couldn't download the module: ${status_error}" )

    endif ()

  else ()

    message ( STATUS "SuperInclude -- Skipping ${module_filename} download, module exists." )

  endif ()

  set ( CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${destination_dir}" PARENT_SCOPE )
  list ( REMOVE_DUPLICATES CMAKE_MODULE_PATH )

endfunction()
