local pkgRoot      = "/vol/pkg"
local name         = "gotoblas"
local fn           = myFileName():gsub("%.lua$","")
local version      = barefilename(fn)
local pkgName      = pathJoin(name,version)
local base         = pathJoin(pkgRoot, pkgName)
whatis("Name: Gotoblas")
whatis("Version: " .. version)
whatis("Category: library, mathematics")
whatis("Description: Blas Level 1, 2, 3 routines")
whatis("URL: http://www.tacc.utexas.edu")

setenv("TACC_GOTOBLAS_DIR",base)
setenv("TACC_GOTOBLAS_LIB",base)

