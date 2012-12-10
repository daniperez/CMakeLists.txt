cmake_minimum_required ( VERSION 2.6 )

project ( Example )

# PROJECT_SOURCE_DIR is needed when executing example in cmake_jar
# project isolated and PROJECT_SOURCE_DIR/../ is needed when executing
# it from the CMakeLists.txt root project.
set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/ ${PROJECT_SOURCE_DIR}/../ )

include ( jar )

init_ivy ( REQUIRED )

get_ivy_artifact ( dest ORGANIZATION "org.apache.ant" MODULE_NAME "ant" REVISION "1.8.2" MODULE_FILES "META-INF/NOTICE.txt" ) 

message ( STATUS "Example: file downloaded to ${dest}" ) 
