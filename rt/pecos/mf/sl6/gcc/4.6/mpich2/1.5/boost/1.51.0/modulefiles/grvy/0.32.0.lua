local version = "0.32.0"
local system_type = "sl6"
local modules_top_dir = "/opt/apps/ossw"
local compiler = "gcc"
local compiler_version = "4.6"
local boost_version = "1.51.0"
local hdf5_version = "1.8.9"


local modname = "grvy"

help(
"The grvy module file defines the following environment variables:\n"..
"GRVY_DIR, GRVY_LIB, and GRVY_INC for the location of the \n"..
"grvy distribution.\n\n"..
"To use the grvy library, compile the source code with the option:\n"..
"-I$GRVY_INC \n"..
"and add the following options to the link step: \n"..
"-L$GRVY_LIB -lgrvy\n"..
"Version "..version..", compiled with "..compiler.." "..compiler_version.." compilers."
)

whatis( "Name: GRVY Toolkit " )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version )
whatis( "Category: library" )
whatis( "URL: https://red.ices.utexas.edu/projects/software/wiki/GRVY" )

local mpath_root = os.getenv("MODULEPATH_ROOT")
edit_derived_modulepaths(mpath_root, modname, version)

local grvy_base = modules_top_dir.."/libraries/grvy/grvy-"..version.."/"..system_type.."/"..compiler.."-"..compiler_version.."/boost-"..boost_version.."/hdf5-"..hdf5_version
prepend_path( "LD_LIBRARY_PATH", pathJoin(grvy_base, "lib") )
prepend_path( "PATH", pathJoin(grvy_base, "bin" ) )
prepend_path( "INCLUDE", pathJoin(grvy_base, "include" ) )

setenv( "GRVY_DIR", grvy_base )
setenv( "GRVY_BIN", pathJoin(grvy_base, "bin" ) )
setenv( "GRVY_INC", pathJoin(grvy_base, "include" ) )
setenv( "GRVY_LIB", pathJoin(grvy_base, "lib" ) )

setenv( "GRVY_VERSION", version )
