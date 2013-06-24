-- -*- lua -*-
local help = [[
The Gnu Compiler Collecton
]]

local pkg = Pkg:new{Category     = "System Environment/Base",
                    URL          = "http://gcc.gnu.org",
                    Description  = "The Gnu Compiler Collection",
                    display_name = "GCC",
                    level        = 0,
                    help         = help
}

local base = pkg:pkgBase()
local mdir = pkg:moduleDir()

whatis("Description: Gnu Compiler Collection")
prepend_path('MODULEPATH',   mdir)

family("compiler")

