-- The message printed by the module whatis command
whatis("second v1.0")

-- The message printed by the module help command
help([[
second-level module
]])

-- A module should be harder to remove
add_property("lmod","sticky")
