local version = "1.30-beta"
whatis("Name: Gotoblas")
whatis("Version: " .. version)
whatis("Category: library, mathematics")
whatis("Description: Blas Level 1, 2, 3 routines")
whatis("URL: http://www.tacc.utexas.edu")

local pkgName      = pathJoin("gotoblas",version)

local hierA        = hierarchyA(pkgName,1)
local compiler_dir = hierA[1]
local pkgRoot      = "/vol/pkg"
local base         = pathJoin(pkgRoot, compiler_dir, pkgName)
setenv("TACC_GOTOBLAS_DIR",base)
setenv("TACC_GOTOBLAS_LIB",base)
