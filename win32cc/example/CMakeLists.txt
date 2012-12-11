cmake_minimum_required ( VERSION 2.6 )

project ( win32-cross-compile-example )

# PROJECT_SOURCE_DIR is needed when executing example in super_include 
# project isolated and PROJECT_SOURCE_DIR/../ is needed when executing
# it from the CMakeLists.txt root project.
set ( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/ ${PROJECT_SOURCE_DIR}/../ )

include ( Win32CC )

include_directories ( BEFORE ${CMAKE_SOURCE_DIR}/src )

set ( CMAKE_CXX_FLAGS
      "-std=c++0x -pedantic -Wall -Werror -Wconversion -Wextra -Wno-unused" )

win32cc_configuration ()

# 
# Compilation 
# 
find_package ( Boost 1.40.0 REQUIRED COMPONENTS date_time )

include_directories ( ${Boost_INCLUDE_DIRS} )

add_library ( example SHARED "src/boost_time.cpp" )

target_link_libraries ( example ${Boost_LIBRARIES} )

# 
# Testing
# 
enable_testing() 

add_subdirectory ( test )

win32cc_test_configuration ( 
  WIN32_LD_LIBRARY_PATH "${CMAKE_CURRENT_BINARY_DIR}"
  TEST_TARGETS example_test 
)

message ( STATUS "TEST:  Win32CC: success" ) 

