local name         = "hashrf"
local fn           = myFileName():gsub("%.lua$","")
local version      = barefilename(fn)
local pkgName      = pathJoin(name,version)

local pkgRoot      = "/opt/apps"
local base         = pathJoin(pkgRoot, pkgName)

prepend_path("PATH",            pathJoin(base,"bin"))

whatis("Name: hashrf")
whatis("Version: " .. version)
whatis("Category: phylogenetics")
whatis("Description: hash phylo trees")

WTF("ABC")
