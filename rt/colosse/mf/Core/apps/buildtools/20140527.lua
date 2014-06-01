help(
[[
This module loads modules useful for compilation :
]])

local version = "20140527"
local base = "/software6/apps/buildtools/" .. version

prepend_path("PATH", pathJoin(base,"bin"))
prepend_path("LIBRARY_PATH", pathJoin(base,"lib"))
prepend_path("LIBRARY_PATH", pathJoin(base,"lib64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib64"))
prepend_path("CPATH", pathJoin(base,"include"))
prepend_path("MANPATH", pathJoin(base,"share","man"))

