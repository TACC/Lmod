require("posix")

-- The message printed by the module whatis command
whatis("pkg v1.0")

-- The message printed by the module help command
help([[
primary package
]])

-- This package depends on a another package
depends_on("dependency")
