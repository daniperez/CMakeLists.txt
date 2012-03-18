cmake_minimum_required ( VERSION 2.6 )

project ( super-include-example )

set ( CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../ )

include ( SuperInclude )

github_download ( "daniperez" "CMakeLists.txt" "super_include_example/DummyModule.cmake" )
include ( DummyModule )

if ( DummyVariable )

  message ( STATUS "SuperInclude -- Worked!" )

else ()

  message ( FATAL_ERROR "SuperInclude -- module didn't work :-( " )

endif ()
