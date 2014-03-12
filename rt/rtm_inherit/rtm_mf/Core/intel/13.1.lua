inherit()
local rtmMPRoot = os.getenv("RTM_MODULEPATH_ROOT")
local version   = "13.1"

setenv("INTEL_KIND","RTM")
prepend_path("MODULEPATH", pathJoin(rtmMPRoot, "Compiler/intel",version))
