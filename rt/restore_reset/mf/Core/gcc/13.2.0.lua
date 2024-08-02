--[[ lmod for gcc 13.2.0

Installed as:

wget https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz
tar -xf gcc-13.2.0.tar.xz

cd gcc-13.2.0
./contrib/download_prerequisites

mkdir build-gcc-13.2.0 && cd build-gcc-13.2.0
../configure --prefix=/ford1/share/gmao_SIteam/gcc/gcc-13.2.0 \
       --enable-languages=c,c++,fortran --disable-multilib |& tee configure.log

make -j 6 |& tee make.log
make install |& tee makeinstall.log

--]]

family("Compiler")

local compilername = "gcc"
local version = "13.2.0"
local versioned_compiler = compilername .. "-" .. version
local siteamdir = "/ford1/share/gmao_SIteam"
local installdir = pathJoin(siteamdir,compilername,versioned_compiler)

-- Setup Modulepath for packages built by this compiler
local mroot = "/ford1/share/gmao_SIteam/lmodulefiles"
local mdir  = pathJoin(mroot,"Compiler/gcc-13.2.0")
prepend_path("MODULEPATH", mdir)

prepend_path("PATH",pathJoin(installdir,"bin"))
prepend_path("LD_LIBRARY_PATH",pathJoin(installdir,"lib64"))
prepend_path("LIBRARY_PATH",pathJoin(installdir,"lib64"))
prepend_path("INCLUDE",pathJoin(installdir,"include"))
prepend_path("INCLUDE",pathJoin(installdir,"include/c++",version))
prepend_path("MANPATH",pathJoin(installdir,"share/man"))

setenv("CC",pathJoin(installdir,"bin","gcc"))
setenv("CXX",pathJoin(installdir,"bin","g++"))
setenv("FC",pathJoin(installdir,"bin","gfortran"))
setenv("F90",pathJoin(installdir,"bin","gfortran"))
