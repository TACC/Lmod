local modname = "boost"
local version = "1.51.0"
local system_type = os.getenv("SYSTEM_DIR")
local modules_top_dir = "/opt/apps/ossw"
local compiler = "gcc"
local compiler_version = "4.6"


help(
"The boost module file defines the following environment variables:\n"..
"BOOST_DIR, BOOST_LIB, and BOOST_INC for the location of the \n"..
"BOOST distribution.\n\n"..
"To use the BOOST library, compile the source code with the option:\n"..
"-I$BOOST_INC \n"..
"and add the following options to the link step: \n"..
"-L$BOOST_LIB -lboost\n"..
"Version "..version..", compiled with "..compiler.." "..compiler_version.." compilers."
)

whatis( "Name: Boost C++ Library" )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version )
whatis( "Category: library" )
whatis( "URL: http://www.boost.org" )

local mpath_root = os.getenv("MODULEPATH_ROOT")
edit_derived_modulepaths(mpath_root, modname, version)

local boost_base = pathJoin(modules_top_dir, system_type, compiler, compiler_version, modname, version)

prepend_path( "LD_LIBRARY_PATH", pathJoin(boost_base, "lib") )
prepend_path( "INCLUDE", pathJoin(boost_base, "include" ) )

setenv( "BOOST_DIR", boost_base )
setenv( "BOOST_BIN", pathJoin(boost_base, "bin" ) )
setenv( "BOOST_INC", pathJoin(boost_base, "include" ) )
setenv( "BOOST_LIB", pathJoin(boost_base, "lib" ) )

setenv( "BOOST_VERSION", version )
