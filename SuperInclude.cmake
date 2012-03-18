# - Includes a CMake script found in a github repository. The script
# is downloaded if it's not already found locally. 
#
# The parameters to be supplied are:
#
#   USER            Github user.
#
#   REPO            Github repository.
#
#   PATH_TO_SCRIPT  Path to the script file in Github repository.
# 
# Dani Perez (c) 2012
#
function ( github_include USER REPO PATH_TO_SCRIPT )

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

    # TODO: implement MD5 sum check.
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

  list ( APPEND CMAKE_MODULE_PATH ${destination_dir} )
  list ( REMOVE_DUPLICATES CMAKE_MODULE_PATH )
  include ( ${module_filename_we} )

endfunction()
