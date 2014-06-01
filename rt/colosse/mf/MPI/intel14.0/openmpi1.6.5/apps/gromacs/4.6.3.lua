help(
[[
This module loads the GROMACS molecular dynamics software to your environment.
]])

add_property("type_","chem")
local version = "4.6.3"
local base = pathJoin("/software6/apps/gromacs/", "4.6.3_intel")

prereq("libs/mkl")
whatis("(Website________) http://www.gromacs.org")

prepend_path("PATH",            pathJoin(base, "bin"))
prepend_path("MANPATH",         pathJoin(base, "share/man"))
prepend_path("LIBRARY_PATH",    pathJoin(base, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("CPATH",           pathJoin(base, "include"))
prepend_path("PKG_CONFIG_PATH", pathJoin(base, "lib/pkgconfig"))
