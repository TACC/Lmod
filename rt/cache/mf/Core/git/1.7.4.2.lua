local version = myModuleVersion()
help(
     [[The git module file defines the following environment variables:
TACC_GIT_DIR, TACC_GIT_LIB, and for
the location of the git distribution and its libraries.

Version ]],version,"\n")
whatis("Name: Git")
whatis("Version: " .. version)
whatis("Category: library, tools")
whatis("URL: http://git-scm.com")
whatis("Description: Fast Version Control System")
local base = pathJoin("/opt/apps/git",version)
setenv("TACC_GIT_DIR", base)
prepend_path("PATH",   pathJoin(base,"bin"))
setenv("TACC_GIT_LIB", pathJoin(base,"lib"))
setenv("TACC_GIT_BIN", pathJoin(base,"bin"))

