local version = "1.8.15"
local prefix = "/home/pcolberg/usr/centos6-x86_64/hdf5-" .. version

prepend_path("CMAKE_PREFIX_PATH", prefix)
prepend_path("CPATH", pathJoin(prefix, "include"))
prepend_path("LIBRARY_PATH", pathJoin(prefix, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(prefix, "lib"))
prepend_path("PATH", pathJoin(prefix, "bin"))
