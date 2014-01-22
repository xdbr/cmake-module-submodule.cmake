# cmake-module-submodule.cmake

A cmake module taking care of a project's git submodules (and checking out specific commits/tags)

# PREREQUISITES

* cmake
* already added git submodules (preferably in `vendor/` but you can set this to another direcotory inside `submodules.cmake`)
* adjust `submodules.cmake` to the git submodules you have added to your repo:
  * in this example I am using two submodules under `vendor/serialization`, and `vendor/testing` respectively.

# USAGE

Include `submodules.cmake` in your main `CMakeLists.txt` file:

```
include(cmake/submodules.cmake)
```

Then run cmake as usual from the out-of-source build-directory:

```
build$ cmake ..
```