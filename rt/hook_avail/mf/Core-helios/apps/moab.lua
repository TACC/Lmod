help(
[[
This module loads the Moab utilities client binaries.
]])

add_property("lmod","sticky")
local version = "moab"
local base = pathJoin("/software6/apps/moab/", version)

family("moab")
whatis("(Website________) http://www.cmake.org/")

prepend_path("PATH",     pathJoin(base, "bin"))
prepend_path("MANPATH",  pathJoin(base, "share/man"))
setenv("MOABHOMEDIR", "/software6/apps/moab/config_colosse")

