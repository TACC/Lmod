family("compiler")

-- The message printed by the module whatis command
whatis("gcc")

-- Add second level module
local mroot = os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH", pathJoin(mroot, "gcc"))

depends_on("python3")

