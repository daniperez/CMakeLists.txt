cmake_minimum_required ( VERSION 2.6 )

project ( Testing )

include(ExternalProject)

ExternalProject_Add ( check
  SOURCE_DIR "${PROJECT_SOURCE_DIR}/cmake_jar/example"
  PREFIX "cmake_jar" )
  
