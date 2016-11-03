help([[The git module file defines the following environment variables:
TACC_GIT_DIR, TACC_GIT_LIB, and for
the location of the git distribution and its libraries.

Version 1.7.4
]])
whatis("Name: Git")
whatis("Version: 1.7.4")
whatis("Category: library, tools")
whatis("URL: http://git-scm.com")
whatis("Description: Fast Version Control System")
prepend_path("PATH", "//opt/apps/git/1.7.4/bin/")
setenv("TACC_GIT_DIR", "/opt/apps/git/1.7.4/")
setenv("TACC_GIT_LIB", "/opt/apps/git///1.7.4/lib//")
setenv("TACC_GIT_BIN", "/opt/apps/git/1.7.4/bin")
