local version = "5.20150219"
local prefix = "/home/pcolberg/usr/centos6-x86_64/git-annex-" .. version

prepend_path("PATH", pathJoin(prefix, "bin"))
prepend_path("MANPATH", pathJoin(prefix, "share/man"))
