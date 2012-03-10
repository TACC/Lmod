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
local version      = barefilename(myFileName():gsub(".lua",""))
local mdir         = pathJoin("compiler",pkgName,version)

prepend_path('MODULEPATH',     pathJoin(os.getenv("MODULEPATH_ROOT"),mdir))
family("compiler")
