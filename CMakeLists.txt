cmake_minimum_required ( VERSION 2.6 )

project ( Testing )

include(ExternalProject)

ExternalProject_Add ( check-cmake_jar
  SOURCE_DIR "${PROJECT_SOURCE_DIR}/cmake_jar/example"
  PREFIX "cmake_jar" 
  INSTALL_COMMAND "" ) 

ExternalProject_Add ( check-super_include
  SOURCE_DIR "${PROJECT_SOURCE_DIR}/super_include/example"
  PREFIX "super_include" 
  INSTALL_COMMAND "" ) 

#ExternalProject_Add ( check-win32cc
#  SOURCE_DIR "${PROJECT_SOURCE_DIR}/win32cc/example"
#  PREFIX "super_include" 
#  INSTALL_COMMAND "" ) 

  
