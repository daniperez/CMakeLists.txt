cmake_minimum_required ( VERSION 2.6 )

# We still need to include SuperInclude as usual
set ( CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../ )
include ( SuperInclude )

github_include ( "daniperez" "CMakeLists.txt" "super_include_example/DummyModule.cmake" )

if ( DummyVariable )

  message ( STATUS "SuperInclude -- Worked!" )

else ()

  message ( FATAL_ERROR "SuperInclude -- module didn't work :-( " )

endif ()
