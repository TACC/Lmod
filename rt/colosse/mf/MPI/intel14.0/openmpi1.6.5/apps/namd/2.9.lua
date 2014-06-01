help(
[[
This module loads the NAMD molecular dynamics software to your environment.
]])

add_property("type_","chem")
local version = "2.9"
local base = pathJoin("/software6/apps/namd/", "2.9_intel")

prereq("libs/fftw")
whatis("(Website________) http://www.ks.uiuc.edu/Research/namd/")

prepend_path("PATH",            pathJoin(base))

