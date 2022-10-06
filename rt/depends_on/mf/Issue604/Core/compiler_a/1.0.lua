require("posix")
family("compiler")

-- The message printed by the module whatis command
whatis("compiler_a v1.0")

-- The message printed by the module help command
help([[
compiler
]])

-- Add second level module
local mroot = os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH", pathJoin(mroot, "compiler_a"))
