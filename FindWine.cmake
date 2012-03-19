# - Tries to find Wine.
#
# If Wine is found, the following variables are defined:
#
#   WINE_FOUND   Set to true if Wine is found, otherwise it's set to
#                WINE-NOTFOUND.
#   WINE_CMD     Full path to the Wine executable.
#
#
# Dani Perez (c) 2012
#
find_program ( WINE_CMD wine )

if ( NOT WINE_CMD AND REQUIRED )

  message ( FATAL_ERROR "Wine not found" )

endif ()

if ( WINE_CMD )

  set ( WINE_FOUND true )

else()

  set ( WINE_FOUND WINE-NOTFOUND )

endif ()

mark_as_advanced ( WINE_CMD )
mark_as_advanced ( WINE_FOUND )

