# The MIT License
#
# Copyright (c) 2011 Daniel Perez
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
############################################################################
# parse_arguments.cmake belongs to Cmake authors. See
#
#   http://www.cmake.org/Wiki/CMakeMacroParseArguments
#
include ( parse_arguments )
############################################################################

############################################################################
############################################################################
set ( IVY_TAR_NAME     "apache-ivy-2.3.0-bin.tar.gz"
      CACHE STRING     "Tarball name of Apache Ivy binary distribution" )
############################################################################
set ( IVY_DOWNLOAD_URL "http://www.apache.org/dist/ant/ivy/2.3.0/${IVY_TAR_NAME}"
      CACHE STRING     "URL of Apache Ivy binary distribution" )
############################################################################
set ( IVY_JAR_NAME     "apache-ivy-2.3.0/ivy-2.3.0.jar"
      CACHE STRING     "Jar name of Apache Ivy binary distribution" )
############################################################################
set ( IVY_TMP_FOLDER "${CMAKE_CURRENT_BINARY_DIR}/tmp" 
      CACHE STRING     "Path to put downloaded artifacts and tarballs" )
############################################################################
############################################################################
 
#
# init_ivy - Sets up the environment to use Ivy. It downloads Ivy.
# It defines IVY_INIT_DONE to true if the setup was successful.
#
#  init_ivy ( [REQUIRED] ) 
#
# REQUIRED makes the macro to abort the execution if Ivy cannot be properly 
# set up.
#
macro ( init_ivy )

  init_ivy_process_parameters (  _IVY_INIT ${ARGN} )

  download ( "${IVY_DOWNLOAD_URL}" "${IVY_TMP_FOLDER}/${IVY_TAR_NAME}" "${_IVY_INIT_REQUIRED}" )
    
  untar ( "${IVY_TMP_FOLDER}/${IVY_TAR_NAME}" ) 
 
  set ( CACHE INTERNAL IVY_INIT_DONE true "If Ivy was correctly set up" )
  
endmacro ()

#
# get_artifact - Retrieves the given file from the given artifact
# or module.
#
#   macro get_artifact ( file
#                            ORGANIZATION  organization
#                            MODULE_NAME   module_name
#                            REVISION      revision
#                            MODULE_FILE   module_file
#                            [CONFIG_FILE  config_file]  )
#
# file will be set by the macro to the file extracted from the jar.
# ORGANIZATION is the organization used in the module's ivy.xml descriptor. 
# MODULE_NAME is the name of the module or artifact as per the ivy.xml. 
# REVISION is the version to retrieve. MODULE_FILE is the file to extract 
# from the moduleeither a comma-separated or a GLOB pattern.
# The optional argument CONFIG_FILE points to the ivysettings.xml
# file with the settings for the resolvers, caches and so on (see
# http://ant.apache.org/ivy/history/latest-milestone/settings.html ).
#
macro ( get_artifact file )

   get_artifact_process_parameters (  _IVY_GET ${ARGN} )

   if ( EXISTS "${IVY_TMP_FOLDER}/${_IVY_GET_MODULE_FILE}" )

    set ( ${file} "${IVY_TMP_FOLDER}/${_IVY_GET_MODULE_FILE}" )
    message ( STATUS "CMAKE-IVY: ${${file}} already exists. Lazyness is a gift: perseverance is overstimated." )

  else ()
   
    if ( WIN32 )
      set ( _CACHE_PATTERN "Z://${IVY_TMP_FOLDER}/[module]-[type].jar" )
    else ()
      set ( _CACHE_PATTERN "${IVY_TMP_FOLDER}/[module]-[type].jar" )
    endif ()

    ivy_resolve ( CWD           ${IVY_TMP_FOLDER} 
                  JAVA          ${java}
                  IVYJAR        ${IVY_TMP_FOLDER}/${IVY_JAR_NAME}
                  PKG_ORG       ${_IVY_GET_ORGANIZATION}
                  PKG_NAME      ${_IVY_GET_MODULE_NAME}
                  PKG_REV       ${_IVY_GET_REVISION}
                  CACHE_PATTERN ${_CACHE_PATTERN}
                  CONFIG_FILE   ${_IVY_GET_CONFIG_FILE} )

    unjar (
            JAR           ${jar}
            JARFILE       ${IVY_TMP_FOLDER}/${_IVY_GET_MODULE_NAME}-jar.jar
            FILE          ${_IVY_GET_MODULE_FILE}
            UNJARRED_FILE ${file}
            CWD           ${IVY_TMP_FOLDER} )

    message ( STATUS "CMAKE-IVY: '${${file}}' extracted" )

  endif () 

endmacro ()

#
# init_ivy_process_parameters - Processes the arguments for init_ivy.
# Private method, not meant to be used by final user.
#
#  init_ivy_process_parameters ( PREFIX [parameters...] ) 
#
# It will process any PARAMETERS passed to the macro and it will set
# some variables prefixed by PREFIX.
# 
macro ( init_ivy_process_parameters PREFIX )

  parse_arguments ( ${PREFIX} "" "REQUIRED" ${ARGN} )

  if ( 0 )
    message ( "${PREFIX}_REQUIRED = ${${PREFIX}_REQUIRED}" )
  endif ()

  if ( _IVY_CONFIG_FILE )
    if ( NOT EXISTS ${_IVY_CONFIG_FILE} )

      message ( FATAL_ERROR "CMAKE-IVY: File ${_IVY_CONFIG_FILE} doesn't exist" )

    endif ()
  endif ()

endmacro ()

#
# get_artifact_process_parameters - Parses the arguments for get_artifact.
# Private method, not meant to be used by final user.
#
#  get_artifact_process_parameters ( PREFIX [parameters...] )
#
# It will process any PARAMETERS passed to the macro and it will set
# some variables prefixed by PREFIX.
# 
macro  ( get_artifact_process_parameters PREFIX )

  if ( IVY_INIT_DONE )

    message ( FATAL_ERROR "CMAKE-IVY: Call 'init_ivy' macro first" )

  endif () 
 
  parse_arguments ( ${PREFIX} "ORGANIZATION;MODULE_NAME;REVISION;MODULE_FILE;CONFIG_FILE" "" ${ARGN} )

  if ( 0 )
    message ( "${PREFIX}_ORGANIZATION = ${${PREFIX}_ORGANIZATION}" )
    message ( "${PREFIX}_MODULE_NAME  = ${${PREFIX}_MODULE_NAME}" )
    message ( "${PREFIX}_REVISION     = ${${PREFIX}_REVISION}" )
    message ( "${PREFIX}_MODULE_FILE  = ${${PREFIX}_MODULE_FILE}" )
    message ( "${PREFIX}_CONFIG_FILE  = ${${PREFIX}_CONFIG_FILE}" )
  endif ()

  find_package ( Java )

  set ( java ${Java_JAVA_EXECUTABLE} )
  set ( jar  ${Java_JAR_EXECUTABLE} )

  if ( NOT Java_JAVA_EXECUTABLE AND NOT Java_JAR_EXECUTABLE )

    message ( FATAL_ERROR "CMAKE-IVY: Cannot find a sane Java JRE installed." )
    message ( FATAL_ERROR "CMAKE-IVY: java path : ${Java_JAVA_EXECUTABLE}" )
    message ( FATAL_ERROR "CMAKE-IVY: jar path  : ${Java_JAR_EXECUTABLE}" )
  
  endif()

endmacro ()

#
# ivy_resolve - Resolves a package accoring to the parameters.
# Private method, not meant to be used by final user.
# 
#  ivy_resolve ( CWD           cwd
#                JAVA          java
#                IVYJAR        ivyjar 
#                PKG_ORG       organization 
#                PKG_NAME      name 
#                PKG_REV       revision 
#                CACHE_PATTERN pattern 
#                [CONFIG_FILE   config] )
#
#
macro ( ivy_resolve ) 

  parse_arguments ( _IVY_RES "CWD;JAVA;IVYJAR;PKG_ORG;PKG_NAME;PKG_REV;CACHE_PATTERN;CONFIG_FILE" "" ${ARGN} )

  if ( EXISTS "${IVY_TMP_FOLDER}/${_IVY_GET_MODULE_NAME}.jar" ) 

    message ( STATUS "CMAKE-IVY: Skipping resolve, ${_IVY_RES_PKG_ORG}.${_IVY_RES_PKG_NAME}-${_IVY_RES_PKG_REV} is already there, I'm lazy enough not to download it twice." )

  else ()

    message ( STATUS "CMAKE-IVY:  ======================= Ivy output =======================")  

    if ( _IVY_RES_CONFIG_FILE )
      # NOTE: -cache/-retrieve flags might be dismissed if CONFIG_FILE is passed and it defines its own caches. 
      jexecute ( ${_IVY_RES_CWD} ${_IVY_RES_JAVA} "-jar;${_IVY_RES_IVYJAR};-warn;-cache;${_IVY_RES_CWD};-dependency;${_IVY_RES_PKG_ORG};${_IVY_RES_PKG_NAME};${_IVY_RES_PKG_REV};-notransitive;-settings;${_IVY_RES_CONFIG_FILE};-retrieve;${_IVY_RES_CACHE_PATTERN}" )
    else ()
      jexecute ( ${_IVY_RES_CWD} ${_IVY_RES_JAVA} "-jar;${_IVY_RES_IVYJAR};-warn;-cache;${_IVY_RES_CWD};-dependency;${_IVY_RES_PKG_ORG};${_IVY_RES_PKG_NAME};${_IVY_RES_PKG_REV};-notransitive;-retrieve;${_IVY_RES_CACHE_PATTERN}" )
    endif ()

    message ( STATUS "CMAKE-IVY:  ===================== End Ivy output =====================")  

  endif ()

endmacro () 

# unjar - unjars the given file from the given jar file.
# Private method, not meant to be used by final user.
#
#  unjar ( JAR           jar 
#          JARFILE       jarfile 
#          FILE          file
#          UNJARRED_FILE unjarredfile 
#          CWD           cwd )
#
macro ( unjar JAR jar JARFILE jarfile FILE file UNJARRED_FILE unjarredfile CWD cwd )

  if ( NOT EXISTS "${cwd}/${file}" )

    jexecute ( ${cwd} ${jar} "-xf;${jarfile};${file}" )

  endif ()

  set ( ${unjarredfile} "${cwd}/${file}" )

endmacro () 

#
# untar - Untars the given tarball.
# Private method, not meant to be used by final user.
#
#  untar ( TARGZ )
#
# TARGZ points to the tarball to decompress.
#
macro ( untar TARGZ )

  execute_process ( COMMAND ${CMAKE_COMMAND} -E tar xfz ${TARGZ}
                    RESULT_VARIABLE _status
                    ERROR_VARIABLE  _status_message
                    WORKING_DIRECTORY ${IVY_TMP_FOLDER} ) 

  if ( NOT ${_status} EQUAL 0 )

    message ( FATAL_ERROR "CMAKE-IVY: '${filename}' could not be extracted from '${TARGZ}': ${_status_message}" )

  else ()
 
    message ( STATUS "CMAKE-IVY: '${TARGZ}' extracted successfully" )
  
  endif () 

endmacro ()

#
# download - Downloads the file pointed by the given URL to the given
# FILENAME. 
# Private method, not meant to be used by final user.
#
#  download ( URL FILENAME REQUIRED )
#
# URL points to a file to download. File is stored in FILENAME.
# If REQUIRED is passed, the macro will exit with a FATAL_ERROR.
#
#
macro ( download URL FILENAME )

  set ( REQUIRED ${ARGV2} )

  if ( NOT EXISTS "${FILENAME}" )

    file ( DOWNLOAD "${URL}" "${FILENAME}" STATUS status )

    list(GET status 0 _status ) 
    list(GET status 1 _status_message ) 

    if ( NOT ${_status} EQUAL 0 )

      set ( error "I couldn't download ${URL}: ${_status_message}" )

      if ( REQUIRED )
        message ( FATAL_ERROR "CMAKE-IVY: ${error}" )
      else ()
        message ( STATUS "CMAKE-IVY: ${error}" )
      endif ()

    else ()

      message ( STATUS "CMAKE-IVY: '${URL}' successfully downloaded to '${FILENAME}'" )

    endif () 

  else ()

    message ( STATUS "CMAKE-IVY: '${URL}' already downloaded to '${FILENAME}'. I'm too lazy to do it again." )

  endif ()

endmacro ()

#
# jexecute - Executesv the provided jvm executable with the given parameters.
# Private method, not meant to be used by final user.
#
#  jexecute ( JAVA_CMD [parameters...] )
#
# JAVA_CMD points to a java or java.exe executable, or any other executable. PARAMETERS
# will be appended to the call to JAVA_CMD.
#
macro ( jexecute CWD JAVA_CMD )

  #message ( STATUS "CMAKE-IVY: Executing '${JAVA_CMD} ${ARGN}'" )

  execute_process (
    COMMAND ${JAVA_CMD} ${ARGN}
    RESULT_VARIABLE result
    ERROR_VARIABLE error 
    WORKING_DIRECTORY ${CWD}
  ) 

  if ( NOT ${result} EQUAL 0 )

    message ( FATAL_ERROR "CMAKE-IVY: Error executing: ${error}" )

  endif ()

endmacro ()

