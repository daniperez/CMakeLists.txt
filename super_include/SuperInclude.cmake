include ( CMakeParseArguments )
# - Includes a CMake script found in a github repository. The script
# is downloaded only if it's not already present. 
# 
# The parameters to be supplied are:
# 
#   USER    Github user (required)
# 
#   REPO    Github repository (required)
# 
#   BRANCH  Github branch or tag  (required)
# 
#   PATH    Path to the script file in Github repository (required)
# 
# To do:
#
#   - support Bitbucket. 
#   - check MD5 signatures if found in the repo.
# 
# Requires parse_arguments.cmake macro. Install it along with
# SuperInclude.cmake.
#
# Dani Perez (c) 2012
#
macro ( github_include )

  cmake_parse_arguments ( GITHUB "" "USER;REPO;PATH;BRANCH" "" ${ARGN} )

  if ( NOT GITHUB_USER )
    message ( FATAL_ERROR "SuperInclude -- USER not supplied." )
  endif () 
  if ( NOT GITHUB_REPO )
    message ( FATAL_ERROR "SuperInclude -- REPO not supplied." )
  endif () 
  if ( NOT GITHUB_PATH )
    message ( FATAL_ERROR "SuperInclude -- PATH not supplied." )
  endif () 
  if ( NOT GITHUB_BRANCH )
    message ( FATAL_ERROR "SuperInclude -- BRANCH not supplied." )
  endif () 

  set ( url "https://raw.github.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}/${GITHUB_PATH}" )

  set ( HOME "$ENV{HOME}" )

  if ( HOME )

    set ( destination_dir "$ENV{HOME}/.cmake/superinclude" )

  elseif ( WIN32 )

    set ( destination_dir "$ENV{APPDATA}/.cmake/superinclude" ) 

  else ()

    message ( FATAL_ERROR "Cannot locate HOME folder" )

  endif ()

  get_filename_component ( module_filename    "${GITHUB_PATH}" NAME )
  get_filename_component ( module_filename_we "${GITHUB_PATH}" NAME_WE )

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

  list ( APPEND CMAKE_MODULE_PATH ${destination_dir} )
  list ( REMOVE_DUPLICATES CMAKE_MODULE_PATH )

  include ( ${module_filename_we} )

endmacro()

