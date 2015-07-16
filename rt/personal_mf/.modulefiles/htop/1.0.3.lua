local version = "1.0.3"
local prefix = "/home/pcolberg/usr/centos6-x86_64//htop-" .. version

prepend_path("PATH", pathJoin(prefix, "bin"))
prepend_path("MANPATH", pathJoin(prefix, "share/man"))
