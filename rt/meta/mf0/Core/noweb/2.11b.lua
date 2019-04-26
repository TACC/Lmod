-- -*- lua -*-

------------------------------------------------------------------------
-- Noweb 
------------------------------------------------------------------------
local pkgName     = myModuleName()
local fullVersion = myModuleVersion()
local base        = pathJoin("/opt/apps",pkgName,fullVersion)


whatis("Description: "..pkgName.." "..fullVersion)
prepend_path('PATH',           '/opt/apps/icon/icon/bin')
prepend_path('PATH',           pathJoin(base,"bin"))
prepend_path('MANPATH',        pathJoin(base,"man"))
