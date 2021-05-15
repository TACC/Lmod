-- -*- lua -*-
-- vim:ft=lua:et:ts=4
--
local pkg = {}

pkg.name = "foo"
pkg.version = "1.0"
pkg.id = pathJoin(pkg.name, pkg.version)
pkg.prefix = pathJoin(sitePkgRoot, pkg.id)
pkg.display_name = "Foo"
pkg.help = [[
Foobar!
]]

whatis("Name: " .. pkg.display_name)
whatis("Version: " .. pkg.version)
whatis("Category: Application")  -- Application, Development, Library
whatis("Keyword: ")              -- Compiler, Chemistry, ...
whatis("URL: ")
whatis("License: unknown")
whatis([[Description: ]])

checkRestrictedGroup(pkg, nil)

setenv("FOO_ROOT", pkg.prefix)

prepend_path("PATH", pathJoin(composer, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(composer, "lib"))
append_path("MANPATH", pathJoin(pkg.prefix, "man"))

logUsage(pkg)

