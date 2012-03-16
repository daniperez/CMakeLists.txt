cmake_minimum_required ( VERSION 2.6 )

project ( win32-cross-compile-example )

set ( CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../ )

include_directories ( BEFORE ${CMAKE_SOURCE_DIR}/src )

set ( CMAKE_CXX_FLAGS
      "-std=c++0x -pedantic -Wall -Werror -Wconversion -Wextra -Wno-unused" )

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

