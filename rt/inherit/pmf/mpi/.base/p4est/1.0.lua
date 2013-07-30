local pkgRoot  = "/work/12345/aterrel/opt/apps"
local hierA    = hierarchyA(myModuleFullName(),2)
local compiler = hierA[1]:gsub("/","-"):gsub("%.","_")
local mpi      = hierA[2]:gsub("/","-"):gsub("%.","_")
local base     = pathJoin(pkgRoot,compiler,mpi,myModuleFullName())
setenv("P4EST_DIR",base)
