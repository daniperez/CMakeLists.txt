
find_package ( WINE REQUIRED )

if ( WINE_FOUND )

  message ( STATUS "Win32CC -- Wine found: ${WINE_CMD}" )

else()

  message ( FATAL_ERROR "Win32CC -- Couldn't find wine" )

endif ()


