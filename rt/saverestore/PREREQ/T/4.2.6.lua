family("resourcemgr")

whatis("Loads the T resource manager into environment")



local base = "/apps/T"

prepend_path("PATH",pathJoin(base,"bin"))
prepend_path("PATH",pathJoin(base,"sbin"))
prepend_path("LD_LIBRARY_PATH",pathJoin(base,"lib"))
prepend_path("MANPATH",pathJoin(base,"share/man"))
