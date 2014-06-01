help(
[[
This module loads the AluGrid library.
]])

local version = "1.52"
local base = pathJoin("/software6/libs/alugrid/",version .. "_intel")

add_property("type_","math")
whatis("(Website________) http://aam.mathematik.uni-freiburg.de/IAM/Research/alugrid/")

load("apps/metis")
prepend_path("PATH", pathJoin(base, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("CPATH", pathJoin(base, "include"))
prepend_path("PKG_CONFIG_PATH",     pathJoin(base, "lib", "pkgconfig"))

