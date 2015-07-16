local version = "2.0.4"
local prefix = "/home/pcolberg/usr/centos6-x86_64/luajit-" .. version

prepend_path("PATH", pathJoin(prefix, "bin"))
prepend_path("MANPATH", pathJoin(prefix, "share/man"))
prepend_path("CMAKE_PREFIX_PATH", prefix)
prepend_path("CPATH", pathJoin(prefix, "include/luajit-2.0"))
prepend_path("LIBRARY_PATH", pathJoin(prefix, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(prefix, "lib"))
prepend_path("LD_RUN_PATH", pathJoin(prefix, "lib"))
prepend_path("PKG_CONFIG_PATH", pathJoin(prefix, "lib/pkgconfig"))
