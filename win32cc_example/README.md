Cross-compiling and cross-testing for Win32 platform
====================================================

This folder contains an example on how to use CMake, Wine and Mingw
to develop an application for Win32 without leaving your POSIX
system.

The code is in ```src``` folder and a contrived unit test can be
found in ```test```. Both the code and the test can be cross-compiled
for Win32 and, thanks to the Wine magic, even tested. Have a look
at [CMakeLists.txt](https://github.com/daniperez/CMakeLists.txt/blob/master/win32cc_example/CMakeLists.txt)
for a quick start.

Example compilation & testing
-----------------------------

```shell
> mkdir build
> cd build
> cmake ../
> make
> make check
```

If you didn't check out the full [daniperez/CMakeLists.txt](https://github.com/daniperez/CMakeLists.txt)
repo, you'll have to provide the path to the CMake scripts used in this example, e.g.:

```shell
> cmake -DCMAKE_MODULE_PATH=<path to my scripts> ../
```

