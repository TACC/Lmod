local modname          = "mpich2"
local version          = "1.5"
local system_type      = os.getenv("SYSTEM_DIR")
local modules_top_dir  = "/opt/apps/ossw"
local compiler         = "gcc"
local compiler_version = "4.6"

-- Instead of trying to list all possible MPI conflicts
-- we just tell it "mpi" family and it will error if any
-- other mpi family is loaded already
family("mpi")


help(
"MPICH2 MPI-2 Library\n"..
"Adds MPICH2 "..version.." built with "..compiler.." "..compiler_version.." compilers to environment.\n"..
"Adds lib directory to LD_LIBRARY_PATH\n"..
"Adds bin directory to PATH\n"..
"Adds man directory to MANPATH\n"
)

whatis( "Name: MPICH2 MPI-2 Library" )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version )
whatis( "Category: library, runtime support" )
whatis( "URL: http://www.mcs.anl.gov/research/projects/mpich2/" )

local mpi_base = modules_top_dir.."/libraries/mpich2/mpich2-"..version.."/"..system_type.."/"..compiler.."-"..compiler_version

local mpath_root = os.getenv("MODULEPATH_ROOT")
edit_derived_modulepaths(mpath_root, modname, version)

prepend_path( "LD_LIBRARY_PATH",    pathJoin(mpi_base, "lib") )
prepend_path( "PATH",               pathJoin(mpi_base, "bin" ) )
prepend_path( "MANPATH",            pathJoin(mpi_base, "share/man" ) )
setenv(       "MPI_DIR",            mpi_base )

setenv(       "MPICH2_VERSION",     version )
setenv(       "MPI_IMPLEMENTATION", "mpich2" )
setenv(       "MPI_VERSION",        version )
