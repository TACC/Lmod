family("scheduler")
local base = "/apps/M"

prepend_path("PATH",pathJoin(base,"bin"))
prepend_path("PATH",pathJoin(base,"sbin"))
prepend_path("MANPATH",pathJoin(base,"share/man"))
