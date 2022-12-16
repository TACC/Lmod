-- -*- lua -*-
whatis("Name: ParMETIS: Parallel Graph Partitioning")
whatis("Version: 3.1")
whatis("Category: library, mathematics")
whatis("Description: Parallel graph partitioning and fill-reduction matrix ordering routines")
whatis("URL: http://glaros.dtc.umn.edu/gkhome/views/metis")

local pkgRoot      = "/vol/pkg/Parmetis"
local compiler_dir = ""
local mpi_dir      = ""
local pkg          = "parmetis/3.1"
local base         = pathJoin(pkgRoot, compiler_dir, pkg)
setenv("TACC_PMETIS_DIR",base)
setenv("TACC_PMETIS_BIN",base)
setenv("TACC_PMETIS_LIB",base)
setenv("TACC_PMETIS_INC",base)
setenv("TACC_PMETIS_DOC",pathJoin(base,"Manual"))
add_property("arch","mic")
