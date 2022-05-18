local app = "B"
local version = "10.3.0"
local mroot = os.getenv("MODULEPATH_ROOT") or ""
prepend_path("MODULEPATH", pathJoin(mroot,"Core"))
