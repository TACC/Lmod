-- -*- lua -*-
local help = [[
The pmetis module defines the following environment variables:
TACC_PMETIS_DIR, TACC_PMETIS_DOC, TACC_PMETIS_BIN,
TACC_PMETIS_LIB, and TACC_PMETIS_INC for the location
of the ParMetis distribution, documentation, binaries,
libraries, and include files.


To use the parmetis library, include compilation and link directives
of the form: -L$TACC_PMETIS_LIB -I$TACC_PMETIS_INC -lparmetis -lmetis

Here is an example command to compile pmetis_test.c:

mpicc -I$TACC_PMETIS_INC pmetis_test.c -L$TACC_PMETIS_LIB -lparmetis
]]

local pkg = Pkg:new{Category     = "Library, Mathematics",
                    Keywords     = "Library, Parallel, Mathematics, Graph Partitioning",
                    URL          = "http://glaros.dtc.umn.edu/gkhome/views/metis",
                    Description  = "Parallel graph partitioning and fill-reduction "..
                                   "matrix ordering routines",
                    display_name = "PMETIS",
                    level        = 2,
                    help         = help
}

pkg:setStandardPaths("DIR","INC","LIB")
