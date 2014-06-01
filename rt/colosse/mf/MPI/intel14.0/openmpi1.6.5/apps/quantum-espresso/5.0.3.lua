help(
[[
This module loads the Quantum Espresso suite for electronic structure calculations and materials modeling.
]])

--add_property("type_","")
local version = "5.0.3"
local base = pathJoin("/software6/apps/quantum-espresso/", "5.0.3_intel")

always_load("libs/mkl")
whatis("(Website________) http://www.quantum-espresso.org")

prepend_path("PATH",            pathJoin(base, "bin"))

