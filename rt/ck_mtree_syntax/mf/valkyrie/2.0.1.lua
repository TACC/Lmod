local pkgName      = myModuleName()
local fullVersion  = myModuleVersion()

local pkgRoot      = "/opt/apps"
local base         = pathJoin(pkgRoot, pkgName, fullVersion)

prepend_path("PATH",            pathJoin(base,"bin"))

whatis("Name: valkyrie")
whatis("Version: " .. fullVersion)
whatis("Category: tools")
whatis("URL: http://www.valgrind.org/downloads/guis.html/")
whatis("Description: GUI frontend for valgrind")

