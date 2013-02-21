-- -*- lua -*-
local pkgName         = "mpi/mpich2"
local cmplrV          = "cmplr/gcc/4.7"
local fn              = myFileName():gsub("%.lua$","")
local fullVersion     = barefilename(fn)
local pkgVersion      = fullVersion:match("([0-9]+%.[0-9]+)%.?")
local pkgNameVer      = pathJoin(pkgName,pkgVersion)
local modulepath_root = os.getenv("MODULEPATH_ROOT")



prepend_path('MODULEPATH',           pathJoin(modulepath_root,pkgNameVer,cmplrV))

family("MPI")

