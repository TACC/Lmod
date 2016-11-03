-- -*- lua -*-
local version = "1.32"
whatis("Name: Gotoblas")
whatis("Version: " .. version)
whatis("Category: library, mathematics")
whatis("Description: Blas Level 1, 2, 3 routines")
whatis("URL: http://www.tacc.utexas.edu")

help([[
The gotoblas module defines the following environment variables:
TACC_GOTOBLAS_DIR and TACC_GOTOBLAS_LIB for the location
of the gotoblas distribution and libraries.

To use the gotoblas library, include compilation directives
of the following form in your link command:

 Single Threaded: -L$TACC_GOTOBLAS_LIB -lgoto_lp64

You can control the number threads with the SMP version using the
OMP_NUM_THREADS environment variable.
     ]])

local pkgRoot      = "/vol/pkg"
local pkgName      = pathJoin("gotoblas",version)
local hierA        = hierarchyA(pkgName,1)
local compiler_dir = hierA[1]
local base         = pathJoin(pkgRoot, compiler_dir, pkgName)
setenv("TACC_GOTOBLAS_DIR",base)
setenv("TACC_GOTOBLAS_LIB",base)

prepend_path("LD_LIBRARY_PATH",base)
