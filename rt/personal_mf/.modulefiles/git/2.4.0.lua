local version = "2.4.0"
local prefix = "/home/pcolberg/usr/centos6-x86_64/git-" .. version

prepend_path("PATH", pathJoin(prefix, "bin"))
prepend_path("MANPATH", pathJoin(prefix, "share/man"))
