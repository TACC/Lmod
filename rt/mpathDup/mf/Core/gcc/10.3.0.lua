local app = "gcc"
local version = "10.3.0"
local mroot = os.getenv("MODULEPATH_ROOT") or ""
family("compiler")
prepend_path("MODULEPATH", pathJoin(mroot,"Compilers"))
