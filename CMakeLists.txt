cmake_minimum_required ( VERSION 2.6 )

project ( Testing )

include(ExternalProject)

ExternalProject_Add ( check URL "${PROJECT_SOURCE_DIR}/cmake_jar" SOURCE_DIR "${PROJECT_SOURCE_DIR}/cmake_jar/example" )
  
