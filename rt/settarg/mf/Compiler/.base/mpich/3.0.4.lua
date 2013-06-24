-- -*- lua -*-
local help = [[
Mpich implementation MPI 3.0
]]

local pkg = Pkg:new{Category     = "MPI",
                    URL          = "http://www.mpich.org",
                    Description  = "Message Passing Interface Library version 3",
                    level        = 1,
                    help         = help
}
local mdir = pkg:moduleDir()
local base = pkg:pkgBase()

prepend_path('MODULEPATH',      mdir)
prepend_path('PATH',            pathJoin(base,"bin"))
prepend_path('MANPATH',         pathJoin(base,"man"))
setenv(      'MPIHOME',         base)
setenv(      'MPICH_HOME',      base)


prepend_path('LD_LIBRARY_PATH',   pathJoin(base,"lib"))
family("MPI")
