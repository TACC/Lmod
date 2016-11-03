setenv("intel_version", myModuleVersion())
add_property("arch","mic")
local base = pathJoin("/app", myModuleFullName())
setenv( "LMOD_INTEL_DIR", base)
setenv( "LMOD_INTEL_LIB", pathJoin(base,"lib"))


whatis("Name: " .. myModuleName())
whatis("Version: " .. myModuleVersion())
whatis("Category: library, mathematics")
whatis("URL: http://www.intel.com")
whatis("Description: the intel compiler collection")

help([[ This is the compiler help message ]])
