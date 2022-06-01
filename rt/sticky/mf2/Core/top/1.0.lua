-- The message printed by the module whatis command
whatis("top v1.0")

-- The message printed by the module help command
help([[
top level module
]])

-- A module should be harder to remove
add_property("lmod","sticky")

-- Add second level module
local mroot = myFileName():match('(.*)/Core/top/.*')
prepend_path("MODULEPATH", pathJoin(mroot, "Lev2"))
