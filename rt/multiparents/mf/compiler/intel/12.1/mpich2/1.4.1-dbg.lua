-- -*- lua -*-
local pkgName       = "mpich2"
local fn            = myFileName():gsub(".lua","")
local version       = barefilename(fn)
local pkgNameVerDbg = pathJoin(pkgName,version)
local pkgNameVer    = pkgNameVerDbg:gsub("-dbg","")

local hierA         = hierarchyA(pkgNameVerDbg,1)
local compiler_dir = hierA[1]
local pkgRoot      = "/opt/apps"
local mdir         = pathJoin(os.getenv('MODULEPATH_ROOT'), "mpi",compiler_dir,pkgNameVer)
compiler_dir       = compiler_dir:gsub("/","-"):gsub("%.","_")

prepend_path('MODULEPATH',           mdir)
family("MPI")
