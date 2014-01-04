-- -*- lua -*-
help(
[[
This module loads the intel compiler path and environment variables

]])
------------------------------------------------------------------------
-- Intel Compilers support
------------------------------------------------------------------------
local pkgName      = myModuleName()
local version      = myModuleVersion()
local pkgNameVer   = pathJoin(pkgName,version)

local composer_xe  = "composer_xe_2013"
local VTune_ex     = "vtune_amplifier_xe_2013"
local inspector_xe = "inspector_xe_2013"
local full_xe      = "composer_xe_2013.0.079"

local LMODarch     = os.getenv("LMOD_arch") or "x86_64"
local tbl          = { i686 = "ia32",  x86_64 = "intel64" }
local linuxT       = { i686 = "i386",  x86_64 = "x86_64"  }
local binT         = { i686 = "bin32", x86_64 = "bin64"  }
local binSz        = binT[LMODarch]
local mdir         = pathJoin("Compiler/intel",version)
local base         = pathJoin("/opt/apps/intel",version)
local archInclude  = linuxT[LMODarch] .. "-linux-gnu"
local arch         = tbl[LMODarch]
local installDir   = pathJoin(base,full_xe)
local tbb30Dir     = pathJoin(installDir,"tbb")
local mklRoot      = pathJoin(installDir,"mkl")
local ippRoot      = pathJoin(installDir,"ipp")

whatis("Description: Intel Compiler Collection")
-- general
prepend_path('LD_LIBRARY_PATH',    pathJoin(installDir,"compiler/lib",arch))
prepend_path('LIBRARY_PATH',       pathJoin(mklRoot,"lib",arch))

-- idb
prepend_path('NLSPATH',            pathJoin(installDir,"debugger",arch,"locale/%l_%t/%N"))

-- tbb
prepend_path('LD_LIBRARY_PATH',    pathJoin(tbb30Dir,"lib",arch))
prepend_path('LIBRARY_PATH',       pathJoin(tbb30Dir,"lib",arch))
prepend_path('CPATH',              pathJoin(tbb30Dir,"include"))

--mkl
prepend_path('LD_LIBRARY_PATH',    pathJoin(mklRoot,"lib",arch))
prepend_path('INCLUDE',            pathJoin(mklRoot,"include"))
prepend_path('CPATH',              pathJoin(mklRoot,"include"))
prepend_path('NLSPATH',            pathJoin(mklRoot,"lib",arch,"locale/%l_%t/%N"))

-- ipp
prepend_path('LD_LIBRARY_PATH',    pathJoin(ippRoot,"lib",arch))
prepend_path('LIBRARY_PATH',       pathJoin(ippRoot,"lib",arch))
prepend_path('NLSPATH',            pathJoin(ippRoot,"lib",arch,"locale/%l_%t/%N"))
prepend_path('CPATH',              pathJoin(ippRoot,"include"))

-- icc & ifort
prepend_path('LD_LIBRARY_PATH',    pathJoin(installDir,"mpirt/lib",arch))
prepend_path('NLSPATH',            pathJoin(installDir,"compiler/lib",arch,"locale/%l_%t/%N"))
prepend_path('INTEL_LICENSE_FILE', pathJoin(installDir,"licenses"))
prepend_path('MANPATH',            pathJoin(installDir,"man/en_US"))
prepend_path('PATH',               pathJoin(base,"bin"))
prepend_path('INCLUDE',            pathJoin("/usr/include",archInclude))
prepend_path('CPATH',              pathJoin("/usr/include",archInclude))
-- vtune
prepend_path('PATH',               pathJoin(base,VTune_ex,binSz))
-- inspector
prepend_path('PATH',               pathJoin(base,inspector_xe,binSz))


prepend_path('MODULEPATH',     pathJoin(os.getenv("MODULEPATH_ROOT"),mdir))
family("compiler")
