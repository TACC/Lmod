help(
[[
This module loads the Paraview visualization program.
]])

add_property("type_","vis")
local version = "4.1.0"
local base = pathJoin("/software6/apps/paraview/", version .. "_intel_llvmpipe")

local module_root = "/software6/modulefiles"
assert(loadfile(pathJoin(module_root,"Core/libs/mesa-llvmpipe/.10.0.4.lua")))()
load("apps/python/2.7.5")
load("compilers/llvm/3.4")

whatis("(Website________) http://www.paraview.org")

prepend_path("PATH",            pathJoin(base, "bin"))
prepend_path("LIBRARY_PATH",    pathJoin(base, "lib", "paraview-4.1"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib", "paraview-4.1"))

