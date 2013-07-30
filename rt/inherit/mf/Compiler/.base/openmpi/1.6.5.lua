-- -*- lua -*-

local helpMsg = [[
Open MPI help
]]

local pkg = Pkg:new{Category     = "MPI library",
                    URL          = "http://www.openmpi.org",
                    Description  = "Openmpi Version of the " ..
                                   "Message Passing Interface Library",
                    display_name = "OPENMPI",
                    level        = 1,
                    help         = helpMsg,
}

pkg:setStandardPaths("LIB","DIR","BIN","MAN")
prepend_path('MODULEPATH',      pkg:moduleDir())
local base = pkg:pkgBase()

prepend_path('LD_LIBRARY_PATH', pathJoin(mpihome,"lib"))
prepend_path('LD_LIBRARY_PATH', pathJoin(mpihome,"lib","openmpi"))
prepend_path('MANPATH',         pathJoin(mpihome,"man"))
setenv(      'MPIHOME',         base)
setenv(      'MPICH_HOME',      base)
family("MPI")
