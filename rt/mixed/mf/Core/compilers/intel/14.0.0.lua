family("compilers")

local mroot = os.getenv("MODULEPATH_ROOT") or "unknown"
local mdir  = pathJoin(mroot,"Compilers","intel14.0")
append_path("MODULEPATH", mdir)
setenv("INTEL",myModuleVersion())
