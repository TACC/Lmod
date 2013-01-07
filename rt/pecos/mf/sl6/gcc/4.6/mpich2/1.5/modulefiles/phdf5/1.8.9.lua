local modname            = "phdf5"
local version            = "1.8.9"
local system_type        = "sl6"
local modules_top_dir    = "/opt/apps/ossw"
local compiler           = "gcc"
local compiler_version   = "4.6"
local mpi_implementation = "mpich2"
local mpi_version        = "1.5"


help(
"The phdf5 module file defines the following environment variables:\n"..
"PHDF5_DIR, PHDF5_LIB, and PHDF5_INC for the location of the \n"..
"PHDF5 distribution.\n"..
"To use the PHDF5 library, compile the source code with the option:\n"..
"-I$PHDF5_INC \n"..
"and add the following options to the link step: \n"..
"-L$PHDF5_LIB -lhdf5\n\n"..
"Version "..version..", compiled with "..compiler.." "..compiler_version.." compilers\n"..
"in parallel with "..mpi_implementation.." "..mpi_version
)

whatis( "Name: parallel HDF5 Library" )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version.." and "..mpi_implementation.." "..mpi_version )
whatis( "Category: library" )
whatis( "URL: http://www.hdfgroup.org/HDF5/" )

local phdf5_base = modules_top_dir.."/libraries/phdf5/phdf5-"..version.."/"..system_type.."/"..compiler.."-"..compiler_version.."/"..mpi_implementation.."-"..mpi_version

local mpath_root = os.getenv("MODULEPATH_ROOT")
edit_derived_modulepaths(mpath_root, modname, version)

prepend_path( "LD_LIBRARY_PATH", pathJoin(phdf5_base, "lib") )
prepend_path( "PATH", pathJoin(phdf5_base, "bin" ) )
prepend_path( "INCLUDE", pathJoin(phdf5_base, "include" ) )

setenv( "PHDF5_DIR", phdf5_base )
setenv( "PHDF5_BIN", pathJoin(phdf5_base, "bin" ) )
setenv( "PHDF5_INC", pathJoin(phdf5_base, "include" ) )
setenv( "PHDF5_LIB", pathJoin(phdf5_base, "lib" ) )

setenv( "PHDF5_VERSION", version )
