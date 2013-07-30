-- -*- lua -*-
local helpMsg = [[
Mpich implementation MPI 3.0
]]

local pkg = Pkg:new{Category     = "MPI library",
                    URL          = "http://www.mpich.org",
                    Description  = "High-Performance Portable MPI",
                    display_name = "MPICH",
                    level        = 1,
                    help         = helpMsg,
}

pkg:setStandardPaths("LIB","DIR","BIN","MAN")
prepend_path('MODULEPATH',      pkg:moduleDir())
local base = pkg:pkgBase()
setenv( "MPICH_HOME", base)
family("MPI")
