local version = "4.1.4"
local base    = "/opt/apps/papi"
local pkg     = pathJoin(base,version)




prepend_path("PATH",                    pathJoin(pkg,"bin"))
prepend_path("MANPATH",                 pathJoin(pkg,"share/man"))
prepend_path("LD_LIBRARY_PATH",         pathJoin(pkg,"lib"))
setenv(      "TACC_PAPI_DIR",           pkg)
setenv(      "TACC_PAPI_INC",           pathJoin(pkg,"include"))
setenv(      "TACC_PAPI_LIB",           pathJoin(pkg,"lib"))
setenv(      "PAPI_PERFMON_EVENT_FILE", pathJoin(pkg,"share/papi/papi_events.csv"))

whatis("PAPI: Performance Application Programming Interface")
whatis("Version: " .. version)
whatis("Category: library, performance measurement")
whatis("Description: Interface to monitor performance counter hardware for quantifying application behavior")
whatis("URL: http://icl.cs.utk.edu/papi/")

local msg =
[[The PAPI module file defines the following environment variables:
TACC_PAPI_DIR, TACC_PAPI_LIB, and TACC_PAPI_INC for
the location of the papi distribution, libraries, 
and include files, respectively.

To use the PAPI library, compile the source code with the option:

        -I$TACC_PAPI_INC 

and add the following options to the link step: 

        -Wl,-rpath,$TACC_PAPI_LIB -L$TACC_PAPI_LIB -lpapi

The -Wl,-rpath,$TACC_PAPI_LIB option is not required, however,
if it is used, then this module will not have to be loaded
to run the program during future login sessions.

   Version ]]
help(msg,version)

