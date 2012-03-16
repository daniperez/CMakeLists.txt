include(CMakeForceCompiler)

set ( CMAKE_SYSTEM_NAME Windows )

add_definitions ( "-D__CYGWIN__" )

find_path ( CMAKE_FIND_ROOT_PATH "bin" "/usr/i686-pc-mingw32/sys-root/mingw" )

if ( CMAKE_FIND_ROOT_PATH EQUAL CMAKE_FIND_ROOT_PATH-NOTFOUND )

  message ( FATAL_ERROR "Win32CC -- Your platform is not recognized and CMAKE_FIND_ROOT_PATH is not set" ) 

endif () 

string ( REGEX REPLACE "(.*)/(i.*32)/(.*)" "\\2" MINGW_PREFIX ${CMAKE_FIND_ROOT_PATH} )

if ( MINGW_PREFIX STREQUAL CMAKE_FIND_ROOT_PATH )

  message ( FATAL_ERROR "Win32CC -- Prefix not in ${CMAKE_FIND_ROOT_PATH}. Provide 'MINGW_PREFIX' variable with it (e.g. i686-pc-mingw)" )

endif () 

set ( MINGW_PREFIX "i686-pc-mingw32" )

set ( CMAKE_C_COMPILER ${MINGW_PREFIX}-gcc )
set ( CMAKE_FORCE_CXX_COMPILER ${MINGW_PREFIX}-g++ GNU )
set ( CMAKE_RC_COMPILER ${MINGW_PREFIX}-windres )

set ( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
set ( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
set ( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )

# Misc
execute_process ( COMMAND "${MINGW_PREFIX}-gcc" "-dumpversion"
                  OUTPUT_VARIABLE GCC_VERSION )

string ( REGEX REPLACE "(.+)\\.(.+)\\.(.+)" "\\1\\2" GCC_VERSION_COMPACT ${GCC_VERSION} )

set ( Boost_COMPILER -gcc${GCC_VERSION_COMPACT} )
