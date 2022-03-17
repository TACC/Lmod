-- -*- lua -*-
local name          = myModuleName()
local fullVersion   = myModuleVersion()
local pkgName       = pathJoin(name, fullVersion)
local hierA         = hierarchyA(pkgName,1)
local compiler_dir  = hierA[1]
local pkgVersion    = fullVersion:match('(%d+%.%d+)%.?')
local compiler_name = compiler_dir:gsub("/","-"):gsub("%.","_") -- :gsub("intel%.14_1","intel-14_1")
local mroot         = os.getenv("MODULEPATH_ROOT")
local appsDir       = os.getenv("APPS_DIR")
local base          = pathJoin(appsDir,compiler_name, pkgName)


prepend_path("PATH",            pathJoin(base,"bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib"))
prepend_path("MODULEPATH",      pathJoin(mroot, "2MPI", compiler_dir, name, pkgVersion))

family("MPI")
