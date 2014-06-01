help(
[[
This module loads the MrBayes program for Bayesian inference and model choices.
]])

add_property("type_","math")
local version = "3.2.2"
local base = pathJoin("/software6/apps/mrbayes/", version .. "_intel_openmpi")

load("libs/beagle")
whatis("(Website________) http://mrbayes.sourceforge.net/")
prepend_path("PATH",     pathJoin(base, "bin"))

