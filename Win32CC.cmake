# - This macro does some post-configuration in addition to
#    Windows-mingw-i686.cmake toolchain file. Namely:
#
#      i.  Sets Boost_COMPILER, otherwise find_package ( Boost ) won't work.
#      ii. Sets some preprocessor symbols for Boost::Process (highscore's version). 
#
# Dani Perez (c) 2012
#
function ( do_extra_win32_configuration )

  if ( CMAKE_CROSSCOMPILING AND WIN32 )

    execute_process ( COMMAND "${MINGW_PREFIX}-gcc" "-dumpversion"
                      OUTPUT_VARIABLE GCC_VERSION )

    string ( REGEX REPLACE "(.+)\\.(.+)\\.(.+)" "\\1\\2" GCC_VERSION_COMPACT ${GCC_VERSION} )

    set ( Boost_COMPILER -gcc${GCC_VERSION_COMPACT} CACHE STRING "See FindBoost.cmake documentation." )

    message ( STATUS "Win32CC -- Boost_COMPILER suffix is -gcc${GCC_VERSION_COMPACT}" )

    message ( STATUS "Win32CC -- Adding -D__CYGWIN__ needed by Boost::Process" )
    add_definitions ( "-D__CYGWIN__" )

  endif ()

endfunction()

# If Wine is found, adds a 'check' target.
#
# The parameters to be supplied are:
#
#   WIN32_LD_LIBRARY_PATH  Extra folders to add to Wine's PATH, separated 
#                          with ';' or ':'. Tests in 'check' target will be
#                          executed with this path and CMAKE_FIND_ROOT_PATH/bin,
#                          added by default.
#   TEST_TARGETS           This targets  will be added as a dependency to 'check'
#                          target.
#
# Dani Perez (c) 2012
#
function ( 
  do_extra_win32_test_configuration  
    WIN32_LD_LIBRARY_PATH win32_library_path
    TEST_TARGETS          test_targets 
)

  if ( CMAKE_CROSSCOMPILING AND WIN32 )

    find_package ( WINE )

    if ( WINE_FOUND )

      message ( STATUS "Win32CC -- Wine found: ${WINE_CMD}" )

    else()

      message ( STATUS "Win32CC -- Couldn't find Wine, 'check' target disabled." )

    endif ()

    if ( WINE_FOUND )

      if ( WIN32_LD_LIBRARY_PATH )
        string( REPLACE ";" ":" WIN32_LD_LIBRARY_PATH_STR ${win32_library_path} )
      endif()

      # Cross-testing win32 tests in linux works if .exe is omitted (otherwise tests
      # cannot be find). 
      foreach ( _test ${test_targets} ) 
        set_target_properties ( ${_test} PROPERTIES SUFFIX "" )
      endforeach()

      add_custom_target (
        check
        COMMAND WINEPATH=${CMAKE_FIND_ROOT_PATH}/bin/:${WIN32_LD_LIBRARY_PATH_STR} ${CMAKE_CTEST_COMMAND} --output-on-failure
      )

      message ( STATUS "Win32CC -- Added 'check' target with the following Windows PATH: " )
      foreach ( folder ${CMAKE_FIND_ROOT_PATH}/bin ${WIN32_LD_LIBRARY_PATH_STR} )

        message ( STATUS "Win32CC --  - ${folder}" )
      
      endforeach()

    endif()
  endif ()

endfunction()
