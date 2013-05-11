-- -*- lua -*-
help(
[[
This module loads the intel compiler path and environment variables
To view movies and additional training, visit
http://www.intel.com/software/products.

]])
------------------------------------------------------------------------
-- Intel Compilers support
------------------------------------------------------------------------
local pkgName      = "intel"
local fn           = myFileName()
local fn2          = fn:gsub(".lua","")
local version      = barefilename(fn2)
local mdir         = pathJoin("compiler",pkgName,version)

prepend_path('MODULEPATH',     pathJoin(os.getenv("MODULEPATH_ROOT"),mdir))
family("compiler")
