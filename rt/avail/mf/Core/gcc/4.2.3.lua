-- -*- lua -*-
local pkgVersion      = "4.2.3"
local pkgName         = "gcc"
local pkgNameVer      = pathJoin(pkgName,pkgVersion)
local modulepath_root = os.getenv("MODULEPATH_ROOT")
family("compiler")

prepend_path('MODULEPATH',     pathJoin(modulepath_root,"Compiler",pkgNameVer))
add_property("state","unsupported")
