-- -*- lua -*-
-- vim:ft=lua:et:ts=4
--
local pkg = loadPkgDefaults()
setPkgInfo(pkg)



checkRestrictedGroup(pkg, nil)

prepend_path("PATH", pathJoin(pkg.prefix, "bin"))
prepend_path("MANPATH", pathJoin(pkg.prefix, "man"))
prepend_path("LD_LIBRARY_PATH", pathJoin(pkg.prefix, "lib"))

logUsage(pkg)

