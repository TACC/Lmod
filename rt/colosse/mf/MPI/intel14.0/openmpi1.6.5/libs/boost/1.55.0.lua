help(
[[
This module loads the Boost C++ template library.
]])

local version = "1.55.0"
local base = pathJoin("/software6/libs/boost/","1.55.0_intel")

add_property("type_","tools")
whatis("(Website________) http://www.boost.org/")

prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("CPATH", pathJoin(base, "include"))

