local modname = "gcc"
local version = "4.6"
local modules_top_dir = "/opt/apps/ossw"
family("compiler")


help(
"\n"..
"The gcc module enables the GCC family of compilers (C/C++\n"..
"and Fortran) and updates the $PATH, $LD_LIBRARY_PATH, and\n"..
"$MANPATH environment variables to access the compiler binaries,\n"..
"libraries, and available man pages, respectively.\n"..
"\n"..
"The following additional environment variables are also defined:\n"..
"\n"..
"GCC_BIN (path to gcc/g++/gfortran compilers)\n"..
"GCC_LIB (path to C/C++/Fortran  libraries  )\n"..
"\n"..
"See the man pages for gcc, g++, and gfortran for detailed information\n"..
"on available compiler options and command-line syntax\n"..
"Version "..version
)

whatis( "Name: GCC Compiler" )
whatis( "Version: "..version )
whatis( "Category: compiler, runtime support" )
whatis( "Description: GCC Compiler Family (C/C++/Fortran for x86_64)" )
whatis( "URL: http://gcc.gnu.org/" )


local gcc_prefix  = pathJoin(modules_top_dir, "applications/gcc","gcc-"..version)
prepend_path( "PATH",            pathJoin(gcc_prefix, "bin"))
prepend_path( "MANPATH",         pathJoin(gcc_prefix, "share/man"))
prepend_path( "LD_LIBRARY_PATH", pathJoin(gcc_prefix, "lib64"))

local mpath_root = os.getenv("MODULEPATH_ROOT")
edit_derived_modulepaths(mpath_root, modname, version)

