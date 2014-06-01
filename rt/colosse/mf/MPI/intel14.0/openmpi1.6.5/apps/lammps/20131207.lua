help(
[[
This module loads the Lammps molecular dynamics software to your environment.
]])

add_property("type_","chem")
local version = "20131207"
local base = pathJoin("/software6/apps/lammps/", version .. "_intel")

always_load("libs/mkl")
whatis("(Website________) http://lammps.sandia.gov/")

prepend_path("PATH",            pathJoin(base, "bin"))
setenv("LAMMPS_EXAMPLES", pathJoin(base,"examples"))

