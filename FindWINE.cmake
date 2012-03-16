find_program ( WINE_CMD wine )

if ( NOT WINE_CMD AND REQUIRED )

  message ( FATAL_ERROR "Wine not found" )

endif ()

if ( WINE_CMD )

  set ( WINE_FOUND true )

endif ()

mark_as_advanced ( WINE_CMD )
mark_as_advanced ( WINE_FOUND )

