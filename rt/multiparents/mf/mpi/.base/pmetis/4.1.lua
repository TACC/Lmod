-- -*- lua -*-
local pkgName      = "pmetis"
local fn           = myFileName():gsub(".lua","")
local version      = barefilename(fn)
local pkgNameVer   = pathJoin(pkgName,version)

local hierA        = hierarchyA(pkgNameVer,2)
local mpi_dir      = hierA[1]:gsub("/","-"):gsub("%.","_")
local compiler_dir = hierA[2]:gsub("/","-"):gsub("%.","_")

local pkgRoot      = "/opt/apps"
local base         = pathJoin(pkgRoot, compiler_dir, mpi_dir, pkgName)
setenv(      "TACC_PMETIS_DIR", base)
setenv(      "TACC_PMETIS_INC", pathJoin(base,"include"))
setenv(      "TACC_PMETIS_LIB", pathJoin(base,"lib"))

