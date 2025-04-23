-- -*- lua -*-
local pkgName         = "mpich2"
local fn              = myFileName():gsub("%.lua$","")
local fullVersion     = barefilename(fn)
local pkgVersion      = fullVersion:match("([0-9]+%.[0-9]+)%.?")
local pkgNameFullV    = pathJoin(pkgName,fullVersion)
local pkgNameVer      = pathJoin(pkgName,pkgVersion)
local hierA           = hierarchyA(pkgNameFullV,1)
local compiler_dir    = hierA[1]
local pkgRoot         = "/unknown/apps"
local mdir            = pathJoin(os.getenv('MODULEPATH_ROOT'), "MPI",compiler_dir,pkgNameVer)
compiler_dir          = compiler_dir:gsub("/","-"):gsub("%.","_")
local mpihome         = pathJoin(pkgRoot, compiler_dir, pkgNameFullV)

family("MPI")
prepend_path('MODULEPATH', mdir)

