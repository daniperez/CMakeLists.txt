cmake_minimum_required ( VERSION 2.6 )

# We still need to include SuperInclude as usual
set ( CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../ )
include ( SuperInclude )

github_include ( 
  USER   "daniperez"
  REPO   "CMakeLists.txt"
  BRANCH "v0.1.0"
  PATH   "super_include_example/DummyModule.cmake"
)

if ( DummyVariable )

  message ( STATUS "SuperInclude -- Worked!" )

else ()

  message ( FATAL_ERROR "SuperInclude -- module didn't work :-( " )

endif ()
