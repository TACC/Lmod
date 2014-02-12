-- -*- lua -*-
local help =
[[
This module loads the intel compiler path and environment variables

To get started using Intel(R) VTune(TM) Amplifier XE 2013 Update 4:
    - To set your environment variables: source
/opt/apps/intel/13.1/vtune_amplifier_xe_2013/amplxe-vars.sh
    - To start the graphical user interface: amplxe-gui
    - To use the command-line interface: amplxe-cl
    - For more getting started resources:
/opt/apps/intel/13.1/vtune_amplifier_xe_2013/
      documentation/en/welcomepage/get_started.html.
To get started using Intel(R) Inspector XE 2013 Update 4:
    - To set your environment variables: source
/opt/apps/intel/13.1/inspector_xe_2013/inspxe-vars.sh
    - To start the graphical user interface: inspxe-gui
    - To use the command-line interface: inspxe-cl
    - For more getting started resources:
/opt/apps/intel/13.1/inspector_xe_2013/
      documentation/en/welcomepage/get_started.html.
To get started using Intel(R) Advisor XE 2013 Update 2:
    - To set your environment variables: source
/opt/apps/intel/13.1/advisor_xe_2013/advixe-vars.sh
    - To start the graphical user interface: advixe-gui
    - To use the command-line interface: advixe-cl
    - For more getting started resources: /opt/apps/intel/13.1/advisor_xe_2013/
      documentation/en/welcomepage/get_started.html.

      To get help, append the -help option or precede with the man command.
    - For more getting started resources:

To view movies and additional training, visit
http://www.intel.com/software/products.

]]
------------------------------------------------------------------------
-- Intel Compilers support
------------------------------------------------------------------------
local pkg = Pkg:new{Category     = "Compiler",
                    Keywords     = "Compiler",
                    URL          = "http://intel.com",
                    Description  = "The Intel Compiler Collection",
                    level        = 0,
                    help         = help
}

local base         = pkg:pkgBase()
local mdir         = pkg:moduleDir()

local composer_xe  = "composer_xe_2013"
local VTune_ex     = "vtune_amplifier_xe_2013"
local inspector_xe = "inspector_xe_2013"
local full_xe      = "composer_xe_2013.2.146"

local LMODarch     = "x86_64"
local tbl          = { i686 = "ia32",  x86_64 = "intel64" }
local linuxT       = { i686 = "i386",  x86_64 = "x86_64"  }
local binT         = { i686 = "bin32", x86_64 = "bin64"  }
local binSz        = binT[LMODarch]

local archInclude  = linuxT[LMODarch] .. "-linux-gnu"
local arch         = tbl[LMODarch]
local installDir   = pathJoin(base,full_xe)
local tbb30Dir     = pathJoin(installDir,"tbb")
local mklRoot      = pathJoin(installDir,"mkl")
local ippRoot      = pathJoin(installDir,"ipp")

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


prepend_path('MODULEPATH',         mdir)
family("compiler")
