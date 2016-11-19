help([[HPL is a software package that solves a (random) dense linear system in double precision (64 bits) arithmetic 
 on distributed-memory computers. It can thus be regarded as a portable as well as freely available implementation of the 
 High Performance Computing Linpack Benchmark. - Homepage: http://www.netlib.org/benchmark/hpl/]])

whatis([[Description: HPL is a software package that solves a (random) dense linear system in double precision (64 bits) arithmetic 
 on distributed-memory computers. It can thus be regarded as a portable as well as freely available implementation of the 
 High Performance Computing Linpack Benchmark. - Homepage: http://www.netlib.org/benchmark/hpl/]])

local root = "/cvmfs/soft.cc/nix/1/easybuild/generic/software/MPI/intel2017.1/openmpi2.0/hpl/2.2"

conflict("hpl")

load("icc/.2017.1.132")

load("ifort/.2017.1.132")

load("imkl/2017.1.132")

prepend_path("PATH", pathJoin(root, "bin"))
setenv("EBROOTHPL", root)
setenv("EBVERSIONHPL", "2.2")
setenv("EBDEVELHPL", pathJoin(root, "easybuild/MPI-intel2017.1-openmpi2.0-hpl-2.2-easybuild-devel"))

-- Built with EasyBuild version 3.0.0.dev0-r81f50b882092338a620b4a51b5bea0c4a27bbb2b
