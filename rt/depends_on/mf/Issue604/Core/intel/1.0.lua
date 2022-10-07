family("compiler")

-- The message printed by the module whatis command
whatis("intel")

-- Add second level module
local mroot = os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH", pathJoin(mroot, "intel"))
