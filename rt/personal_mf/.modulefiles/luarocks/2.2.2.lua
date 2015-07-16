local version = "2.2.2"
local prefix = "/home/pcolberg/usr/centos6-x86_64/luarocks-" .. version

prepend_path("PATH", pathJoin(prefix, "bin"))
