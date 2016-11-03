local name         = "boost"
local fn           = myFileName():gsub(".lua","")
local version      = barefilename(fn)
local pkgName      = pathJoin(name,version)
local pkgRoot      = "/unknown/apps"
local base         = pathJoin(pkgRoot, pkgName)
setenv(      "TACC_BOOST_DIR",   base)
