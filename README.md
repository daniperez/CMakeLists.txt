Available scripts
=================

<a href="http://cmake.org"><img alt="CMake logo" src="http://www.cmake.org/opensourcelogos/cmake100.png" align="right"/></a>

1.  **SuperInclude**
2.  **Win32 Application Cross-Compilation**

All the scripts are found in this folder. Examples of usage can be found
in the corresponding subfolders.

* * *

1 - SuperInclude
================

Provides ``github_include`` macro that works like ``include`` but it downloads
the macro from github if it's not present in the local file system.
Just include ``SuperInclude.cmake`` and call the macro (see the
 [example](https://github.com/daniperez/CMakeLists.txt/blob/master/super_include_example/CMakeLists.txt)).
You can find the available macros in [SuperInclude.cmake](https://github.com/daniperez/CMakeLists.txt/blob/master/SuperInclude.cmake).

2 - Win32 Application Cross-Compilation
=======================================

This script is split in a functional basis. They can be used together or individually:

1.  ``Win32CC.cmake``: main script. In order to use it, include it
    in your CMake script:

        set ( CMAKE_MODULE_PATH <location of Win32CC script if no default location> )

        include ( Win32CC )

    Find in [Win32CC.cmake](https://github.com/daniperez/CMakeLists.txt/blob/master/Win32CC.cmake)
    the available macros. The macros set some variables that help at cross-compiling and
    cross-testing (i.e. testing Windows binaries in a POSIX system).

2.  ``Windows-mingw-i686.cmake``: toolchain file. This is the minimum CMake configuration needed 
    if you wanted to compile for Windows. To use it call cmake as follows:

        cmake -DCMAKE_TOOLCHAIN_FILE=<path to Windows-mingw-i686.cmake> <path to the folder containing CMakeLists.txt>

    In principle, you don't need to provide any other config file or
    variable, it will detect your configuration if your distribution is
    supported. For the time being, the supported distributions are: Fedora 15.

3.  ``FindWine.cmake``: used by ``Win32CC.cmake`` to check if
    Wine is present. If it is, WINE_FOUND and WINE_CMD are set accordingly.

You can find an example [here](https://github.com/daniperez/CMakeLists.txt/blob/master/win32cc_example/CMakeLists.txt).

