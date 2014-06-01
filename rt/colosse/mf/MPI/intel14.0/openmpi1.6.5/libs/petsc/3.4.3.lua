help(
[[
This module loads the PETSc library.
]])

add_property("type_","math")

local version = "3.4.3"
local base = pathJoin("/software6/libs/petsc/","3.4.3_intel")

whatis("(Website________) http://www.mcs.anl.gov/petsc")
always_load("libs/mkl")
prepend_path("PATH", pathJoin(base, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("CPATH", pathJoin(base, "include"))
prepend_path("FPATH", pathJoin(base, "include"))

