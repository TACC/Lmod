local modname          = "openmpi"
local version          = "1.6"
local system_type      = os.getenv("SYSTEM_DIR")
local modules_top_dir  = "/opt/apps/ossw"
local compiler         = "gcc"
local compiler_version = "4.6"

-- Instead of trying to list all possible MPI conflicts
-- we just tell it "mpi" family and it will error if any
-- other mpi family is loaded already
family("mpi")


help(
"Openmpi MPI-2 Library\n"..
"Adds Openmpi "..version.." built with "..compiler.." "..compiler_version.." compilers to environment.\n"..
"Adds lib directory to LD_LIBRARY_PATH\n"..
"Adds bin directory to PATH\n"..
"Adds man directory to MANPATH\n"
)

whatis( "Name: Openmpi MPI-2 Library" )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version )
whatis( "Category: library, runtime support" )
whatis( "URL: http://www.mcs.anl.gov/research/projects/openmpi/" )

local mpi_base = modules_top_dir.."/libraries/openmpi/openmpi-"..version.."/"..system_type.."/"..compiler.."-"..compiler_version

local mpath_root = os.getenv("MODULEPATH_ROOT")
edit_derived_modulepaths(mpath_root, modname, version)

prepend_path( "LD_LIBRARY_PATH",    pathJoin(mpi_base, "lib") )
prepend_path( "PATH",               pathJoin(mpi_base, "bin" ) )
prepend_path( "MANPATH",            pathJoin(mpi_base, "share/man" ) )
setenv(       "MPI_DIR",            mpi_base )
setenv(       "Openmpi_VERSION",    version )
setenv(       "MPI_IMPLEMENTATION", "openmpi" )
setenv(       "MPI_VERSION",        version )
