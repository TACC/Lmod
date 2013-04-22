-- -*- lua -*-
local pkgName      = "mvapich2"
local fn           = myFileName():gsub("%.lua$","")
local fullVersion  = barefilename(fn)
local pkgVersion   = fullVersion:match("([0-9]+%.[0-9]+)%.?")
local pkgNameFullV = pathJoin(pkgName,fullVersion)
local pkgNameVer   = pathJoin(pkgName,pkgVersion)

local hierA        = hierarchyA(pkgNameFullV,1)
local compiler_dir = hierA[1]
local pkgRoot      = "/opt/apps"
local mdir         = pathJoin(os.getenv('MODULEPATH_ROOT'), "MPI",compiler_dir,pkgNameVer)
compiler_dir       = compiler_dir:gsub("/","-"):gsub("%.","_")
local mpihome      = pathJoin(pkgRoot, compiler_dir, pkgNameFullV)

whatis("Name: " .. pkgName)
whatis("Version: ".. fullVersion)
whatis("Category: library, runtime support")
whatis("Description: Mpich 2: Message Passing Interface Library version 2")
prepend_path('MODULEPATH',      mdir)
prepend_path('PATH',            pathJoin(mpihome,"bin"))
prepend_path('MANPATH',         pathJoin(mpihome,"man"))
setenv(      'MPIHOME',         mpihome)
setenv(      'MPICH_HOME',      mpihome)


prepend_path('LD_LIBRARY_PATH',   pathJoin(mpihome,"lib"))

family("MPI")
