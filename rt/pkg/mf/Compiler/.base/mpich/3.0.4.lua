-- -*- lua -*-
local pkgName      = myModuleName()
local pkgVersion   = myModuleVersion()
local pkgNameVer   = myModuleFullName()
local pkgV         = pkgVersion:match("([0-9]+%.[0-9]+)%.?")

local hierA        = hierarchyA(pkgNameVer,1)
local compiler_dir = hierA[1]:gsub("/","-"):gsub("%.","_")
local pkgRoot      = "/opt/apps/"
local base         = pathJoin(pkgRoot, compiler_dir, pkgNameVer)
local pkgNV        = pathJoin(pkgName,pkgV)
local mdir         = pathJoin(os.getenv('MODULEPATH_ROOT'), "MPI",hierA[1],pkgNV)
compiler_dir       = compiler_dir

whatis("Name: "    .. pkgName)
whatis("Version: " .. pkgVersion)
whatis("Category: library, runtime support")
whatis("Description: Mpich: Message Passing Interface Library version 3")
prepend_path('MODULEPATH',      mdir)
prepend_path('PATH',            pathJoin(base,"bin"))
prepend_path('MANPATH',         pathJoin(base,"man"))
setenv(      'MPIHOME',         base)
setenv(      'MPICH_HOME',      base)


if (os.getenv("LMOD_sys") == "Darwin") then
   prepend_path('DYLD_LIBRARY_PATH', pathJoin(base,"lib/trace_rlog"))
else
   prepend_path('LD_LIBRARY_PATH',   pathJoin(base,"lib"))
end
family("MPI")
