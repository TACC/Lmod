local pkgName      = myModuleName()
local fn           = myFileName():gsub("%.lua$","")
local fullVersion  = barefilename(fn)
local pkgVersion   = fullVersion:match("([0-9]+%.[0-9]+)%.?")
local pkgNameFullV = pathJoin(pkgName,fullVersion)
local pkgNameVer   = pathJoin(pkgName,pkgVersion)
local hierA        = hierarchyA(pkgNameFullV,1)
local compiler_dir = hierA[1]
local mdir         = pathJoin(os.getenv('MODULEPATH_ROOT'), "MPI",compiler_dir,pkgNameVer)
prepend_path("MODULEPATH",mdir)
family("MPI")

