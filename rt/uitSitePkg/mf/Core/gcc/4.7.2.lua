-- -*- lua -*-
-- vim:ft=lua:et:ts=4
--
family("compiler")
local pkg = loadPkgDefaults()
setPkgInfo(pkg)

setPkgInfo(pkg)
checkRestrictedGroup(pkg, nil)
prependModulePath(pathJoin("Compiler", pkg.id))
logUsage(pkg)

append_path("MANPATH", pathJoin(pkg.prefix, "share/man"))
prepend_path("PATH", pathJoin(pkg.prefix, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(pkg.prefix, "lib64"))
prepend_path("LIBRARY_PATH", pathJoin(pkg.prefix, "lib64"))
