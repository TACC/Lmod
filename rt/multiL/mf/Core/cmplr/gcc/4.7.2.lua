-- -*- lua -*-
local pkgName         = "cmplr/gcc"
local apps            = "/opt/apps/"
local fn              = myFileName():gsub("%.lua$","")
local fullVersion     = barefilename(fn)
local pkgVersion      = fullVersion:match("([0-9]+%.[0-9]+)%.?")
local pkgNameVer      = pathJoin(pkgName,pkgVersion)
local modulepath_root = os.getenv("MODULEPATH_ROOT")


whatis("Description: Gnu Compiler Collection")
prepend_path('MODULEPATH',           pathJoin(modulepath_root,pkgNameVer))

family("compiler")

