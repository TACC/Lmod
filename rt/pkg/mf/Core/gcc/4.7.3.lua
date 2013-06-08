-- -*- lua -*-
local pkgName         = myModuleName()
local apps            = "/opt/apps/"
local pkgVersion      = myModuleVersion()
local pkgV            = pkgVersion:match("([0-9]+%.[0-9]+)%.?")
local pkgNameVer      = myModuleFullName()
local pkgNV           = pathJoin(pkgName,pkgV)
local modulepath_root = os.getenv("MODULEPATH_ROOT")


whatis("Description: Gnu Compiler Collection")
prepend_path('MODULEPATH',           pathJoin(modulepath_root,"Compiler",pkgNV))

family("compiler")

local base    = pathJoin(apps,pkgName,pkgVersion)
