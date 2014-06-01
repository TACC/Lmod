help(
[[
This module loads the lua interpretor.
]])

add_property("type_","script")
local version = "5.1.4.6"
local base = pathJoin("/software6/apps/lua/", version)

whatis("(Website________) http://www.lua.org/")

prepend_path("PATH",            pathJoin(base, "bin"))
prepend_path("MANPATH",         pathJoin(base, "man"))
prepend_path("LIBRARY_PATH",    pathJoin(base, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("CPATH",           pathJoin(base, "include"))
