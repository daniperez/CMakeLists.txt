Some useful CMake scripts written by me. Enjoy it!

# Win32 Application Cross-Compilation

CMake tooling for cross-compilation is quite good but still there
are some few variables and targets that can be defined for a better
user experience.

Several scripts are provided which can be used together or individually.

1.  ``Win32CC.cmake``: main script. In order to use it, include it
    in your CMake script:

        set ( CMAKE_MODULE_PATH <location of Win32CC script if no default location> )

        include ( Win32CC )

    In [Win32CC.cmake](https://github.com/daniperez/CMakeLists.txt/blob/master/Win32CC.cmake) you can find
    the available macros.

2.  ``Windows-mingw-i686.cmake``: toolchain file. This is the only 
    requisite if you wanted to compile for Windows. To use it call cmake
    as follows:

        cmake -DCMAKE_TOOLCHAIN_FILE=<path to Windows-mingw-i686.cmake> <path to the folder containing CMakeLists.txt>

    In principle, you don't need to provide any other config file or
    variable, it will detect your configuration if your distribution is
    supported. For the time being, the supported distributions are: Fedora 15.

3.  ``FindWine.cmake``: used by ``Win32CC.cmake`` script to check if
    Wine is present. If it is, WINE_FOUND and WINE_CMD are set accordingly.

# Super Include

The original idea was to provide a ``github_include`` that would allow to 
include scripts located in github.com (or bitbucket.org or wherever). Since
``include`` has parent scope, that didn't work and I had to content with
a macro that would download to a local folder and set module path's accordingly.

Just include ``SuperInclude.cmake`` and call the provided macros. After 
using SuperInclude, you'll still have to do an ``include`` of your module
(see the [example](https://github.com/daniperez/CMakeLists.txt/tree/master/super_include_example) ).

In [SuperInclude.cmake](https://github.com/daniperez/CMakeLists.txt/blob/master/SuperInclude.cmake) you can find
the available macros.

