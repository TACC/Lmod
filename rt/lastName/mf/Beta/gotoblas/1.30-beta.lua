local name         = "gotoblas"
local fn           = myFileName():gsub("%.lua$","")
local version      = barefilename(fn)
local pkgName      = pathJoin(name,version)

local hierA        = hierarchyA(pkgName,1)
local compiler_dir = hierA[1]

local pkgRoot      = "/vol/pkg"
local base         = pathJoin(pkgRoot, compiler_dir, pkgName)

whatis("Name: Gotoblas")
whatis("Version: " .. version)
whatis("Category: library, mathematics")
whatis("Description: Blas Level 1, 2, 3 routines")
whatis("URL: http://www.tacc.utexas.edu")

setenv("TACC_GOTOBLAS_DIR",base)
setenv("TACC_GOTOBLAS_LIB",base)
