help(
[[
This module loads the Erne Extended Randomized Numerical alignEr, version 1.4.3.
]])

add_property("type_","bio")
local version = "1.4.3"
local base = pathJoin("/software6/apps/erne/", version .. "_intel")

load("libs/boost")
whatis("(Website________) http://erne.sourceforge.net")
prepend_path("PATH",            pathJoin(base, "bin"))

