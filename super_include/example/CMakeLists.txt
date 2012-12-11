cmake_minimum_required ( VERSION 2.6 )

# PROJECT_SOURCE_DIR is needed when executing example in super_include 
# project isolated and PROJECT_SOURCE_DIR/../ is needed when executing
# it from the CMakeLists.txt root project.
set ( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/ ${PROJECT_SOURCE_DIR}/../ )

include ( SuperInclude )

github_include ( 
  USER   "daniperez"
  REPO   "CMakeLists.txt"
  PATH   "super_include/example/DummyModule.cmake"
)

# (DummyModule.cmake defines DummyVariable)
if ( DummyVariable )

  message ( STATUS "TEST:  SuperInclude: success" ) 

else ()

  message ( FATAL_ERROR "SuperInclude -- module didn't work :-( " )

endif ()
