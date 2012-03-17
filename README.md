Some useful CMake scripts written by me. Enjoy it!

# Win32 Application Cross-Compilation

CMake tooling for cross-compilation is quite good but still there
are some few variables and targets that can be defined for a better
user experience.

Scripts
-------

I wrote several scripts that can be used together or individually.

1.  **``Win32CC.cmake``**: main script. In order to use it, include it
   in your CMake script:

    set ( CMAKE_MODULE_PATH <location of Win32CC script if no default location> )

    include ( Win32CC )

2.  **``Windows-mingw-i686.cmake``**: toolchain file. This is the only 
    requisite if you wanted to compile for Windows. To use it call cmake
    as follows:

    cmake -DCMAKE_TOOLCHAIN_FILE=<path to Windows-mingw-i686.cmake> <path to the folder containing CMakeLists.txt>

    In principle, you don't need to provide any other config file or
    variable, it will detect your configuration if your distribution is
    supported. For the time being, the supported distributions are: Fedora 15.

3.  **``FindWine.cmake``**: used by ``Win32CC.cmake`` script to check if
    Wine is present. If it is, WINE_FOUND and WINE_CMD are set accordingly.

Dani.
~              
