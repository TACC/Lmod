help(
[[
This module loads the ParMetis library.
]])

local version = "4.0.3"
local base = pathJoin("/software6/libs/parmetis/",version .. "_intel")

add_property("type_","math")
whatis("(Website________) http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview")

family("metis")
prepend_path("PATH", pathJoin(base, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("CPATH", pathJoin(base, "include"))

