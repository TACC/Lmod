local name         = myModuleName()
local fullVersion  = myModuleVersion()
local pkgName      = pathJoin(name,fullVersion)

local hierA        = hierarchyA(pkgName,1)
local compiler     = hierA[1]
local compiler_dir = compiler:gsub("/","-"):gsub("%.","_")
local pkgRoot      = "/opt/apps"
local base         = pathJoin(pkgRoot, compiler_dir, pkgName)

prepend_path("PATH", pathJoin(base,"bin"))
setenv(      "TACC_MPICH_DIR",   base)
setenv(      "TACC_MPICH_INC",   pathJoin(base,"include"))
setenv(      "TACC_MPICH_LIB",   pathJoin(base,"lib"))


whatis("Name: "..name )
whatis("Version: " .. fullVersion)
whatis("Category: library")
whatis("Description: MPI library")

------------------------------------------------------------------------
-- Form modulepath

local version         = fullVersion:match("(%d+%.%d+)%.?")
local pkgNameVer      = pathJoin(pkgName,pkgVersion)
local modulepath_root = os.getenv("MODULEPATH_ROOT")
prepend_path('MODULEPATH',  pathJoin(modulepath_root,"MPI",compiler,pkgNameVer))
family("MPI")