-- -*- lua -*-


local version      = "4.0.1"
local pkgRoot      = "/vol/pkg/Parmetis"
local compiler_dir = "intel/10.1"
local mpi_dir      = "mpich2/1.0.7"
local pkg          = pathJoin("parmetis",version)
local base         = pathJoin(pkgRoot, compiler_dir, pkg)
setenv("TACC_PMETIS_DIR",base)
setenv("TACC_PMETIS_BIN",base)
setenv("TACC_PMETIS_LIB",base)
setenv("TACC_PMETIS_INC",base)
setenv("TACC_PMETIS_DOC",pathJoin(base,"Manual"))
add_property("arch","mic")

whatis("Name: ParMETIS: Parallel Graph Partitioning")
whatis("Version: ".. version)
whatis("Category: library, mathematics")
whatis("Description: Parallel graph partitioning and fill-reduction matrix ordering routines")
whatis("URL: http://glaros.dtc.umn.edu/gkhome/views/metis")
