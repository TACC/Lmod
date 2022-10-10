family("compiler")

-- Add second level module
local mroot = os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH", pathJoin(mroot, "intel"))

depends_on("python3")
