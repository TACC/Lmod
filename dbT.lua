-- -*- lua -*-
-- created: Sat Jan  1 10:04:46 2011 --
dbT = {
  PrgEnv = {
    ["/local/lmod/modulefiles/Core/PrgEnv.lua"] = {
      ["Description"] = "Program Environment for this system",
      ["full"] = "PrgEnv",
      ["name"] = "PrgEnv",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/PrgEnv.lua",
    },
  },
  admin = {
    ["/local/lmod/modulefiles/Core/admin/admin-1.0.lua"] = {
      ["Description"] = "System Admin Paths",
      ["full"] = "admin/admin-1.0",
      ["name"] = "admin",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/admin/admin-1.0.lua",
    },
  },
  boost = {
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/boost/1.42.0.lua"] = {
      ["Description"] = "Boost library",
      ["full"] = "boost/1.42.0",
      ["name"] = "boost",
      ["parent"] = "default:gcc/4.4.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/boost/1.42.0.lua",
    },
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.3/boost/1.43.0.lua"] = {
      ["Description"] = "Boost library",
      ["full"] = "boost/1.43.0",
      ["name"] = "boost",
      ["parent"] = "default:gcc/4.4.3",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.3/boost/1.43.0.lua",
    },
    ["/local/lmod/modulefiles/Compiler/intel/11.1/boost/1.43.0.lua"] = {
      ["Description"] = "Boost library",
      ["full"] = "boost/1.43.0",
      ["name"] = "boost",
      ["parent"] = "default:intel/11.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/intel/11.1/boost/1.43.0.lua",
    },
  },
  ddt = {
    ["/local/lmod/modulefiles/Core/ddt/ddt.lua"] = {
      ["Description"] = "ddt: source code debugger",
      ["full"] = "ddt/ddt",
      ["help"] = [[
This is the ddt debugger

]],
      ["name"] = "ddt",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/ddt/ddt.lua",
    },
  },
  dmalloc = {
    ["/local/lmod/modulefiles/Core/dmalloc/dmalloc.lua"] = {
      ["Description"] = "Dmalloc: memory checking tool",
      ["full"] = "dmalloc/dmalloc",
      ["name"] = "dmalloc",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/dmalloc/dmalloc.lua",
    },
  },
  gcc = {
    ["/local/lmod/modulefiles/Core/gcc/4.4.1.lua"] = {
      ["Description"] = "Gnu Compiler Collection",
      ["full"] = "gcc/4.4.1",
      ["name"] = "gcc",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/gcc/4.4.1.lua",
    },
    ["/local/lmod/modulefiles/Core/gcc/4.4.3.lua"] = {
      ["Description"] = "Gnu Compiler Collection",
      ["full"] = "gcc/4.4.3",
      ["name"] = "gcc",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/gcc/4.4.3.lua",
    },
  },
  gotoblas = {
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/gotoblas/1.26.lua"] = {
      ["Description"] = "Goto Blas library",
      ["Name"] = "Gotoblas",
      ["URL"] = "http://www.tacc.utexas.edu",
      ["Version"] = "1.26",
      ["full"] = "gotoblas/1.26",
      ["help"] = [[
The gotoblas module defines the following environment variables:
TACC_GOTOBLAS_DIR and TACC_GOTOBLAS_LIB for the location 
of the gotoblas distribution and libraries.

To use the gotoblas library, include compilation directives
of the following form in your link command:
 
 Single Threaded: -L$TACC_GOTOBLAS_LIB -lgoto_lp64
 
You can control the number threads with the SMP version using the
OMP_NUM_THREADS environment variable.

Version 1.26
     
]],
      ["name"] = "gotoblas",
      ["parent"] = "default:gcc/4.4.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/gotoblas/1.26.lua",
    },
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.3/gotoblas/1.26.lua"] = {
      ["Description"] = "Goto Blas library",
      ["Name"] = "Gotoblas",
      ["URL"] = "http://www.tacc.utexas.edu",
      ["Version"] = "1.26",
      ["full"] = "gotoblas/1.26",
      ["help"] = [[
The gotoblas module defines the following environment variables:
TACC_GOTOBLAS_DIR and TACC_GOTOBLAS_LIB for the location 
of the gotoblas distribution and libraries.

To use the gotoblas library, include compilation directives
of the following form in your link command:
 
 Single Threaded: -L$TACC_GOTOBLAS_LIB -lgoto_lp64
 
You can control the number threads with the SMP version using the
OMP_NUM_THREADS environment variable.

Version 1.26
     
]],
      ["name"] = "gotoblas",
      ["parent"] = "default:gcc/4.4.3",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.3/gotoblas/1.26.lua",
    },
    ["/local/lmod/modulefiles/Compiler/intel/11.1/gotoblas/1.26.lua"] = {
      ["Description"] = "Goto Blas library",
      ["Name"] = "Gotoblas",
      ["URL"] = "http://www.tacc.utexas.edu",
      ["Version"] = "1.26",
      ["full"] = "gotoblas/1.26",
      ["help"] = [[
The gotoblas module defines the following environment variables:
TACC_GOTOBLAS_DIR and TACC_GOTOBLAS_LIB for the location 
of the gotoblas distribution and libraries.

To use the gotoblas library, include compilation directives
of the following form in your link command:
 
 Single Threaded: -L$TACC_GOTOBLAS_LIB -lgoto_lp64
 
You can control the number threads with the SMP version using the
OMP_NUM_THREADS environment variable.

Version 1.26
     
]],
      ["name"] = "gotoblas",
      ["parent"] = "default:intel/11.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/intel/11.1/gotoblas/1.26.lua",
    },
  },
  intel = {
    ["/local/lmod/modulefiles/Core/intel/11.1.lua"] = {
      ["Description"] = "Intel Compiler Collection",
      ["full"] = "intel/11.1",
      ["help"] = [[
This module loads the intel compiler path and environment variables
Used by the intel compiler.      

]],
      ["name"] = "intel",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/intel/11.1.lua",
    },
    ["/local/lmod/modulefiles/Core/intel/intel.lua"] = {
      ["Description"] = "Intel Compiler Collection",
      ["full"] = "intel/intel",
      ["help"] = [[
This module loads the intel compiler path and environment variables
Used by the intel compiler.      

]],
      ["name"] = "intel",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/intel/intel.lua",
    },
  },
  lmod = {
    ["/local/lmod/modulefiles/Core/lmod/lmod.lua"] = {
      ["Description"] = "Lmod: An Environment Module System",
      ["full"] = "lmod/lmod",
      ["name"] = "lmod",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/lmod/lmod.lua",
    },
  },
  local = {
    ["/local/lmod/modulefiles/Core/local/local.lua"] = {
      ["Description"] = "Local paths",
      ["full"] = "local/local",
      ["name"] = "local",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/local/local.lua",
    },
  },
  mkl = {
    ["/local/lmod/modulefiles/Core/mkl/mkl.lua"] = {
      ["Description"] = "Intel Math Kernel Library",
      ["full"] = "mkl/mkl",
      ["help"] = [[
This module loads the intel mkl library and environment variables

]],
      ["name"] = "mkl",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/mkl/mkl.lua",
    },
  },
  mpich2 = {
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.1.1.lua"] = {
      ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
      ["full"] = "mpich2/1.1.1",
      ["name"] = "mpich2",
      ["parent"] = "default:gcc/4.4.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.1.1.lua",
    },
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.1.1p1.lua"] = {
      ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
      ["full"] = "mpich2/1.1.1p1",
      ["name"] = "mpich2",
      ["parent"] = "default:gcc/4.4.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.1.1p1.lua",
    },
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.2.1p1.lua"] = {
      ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
      ["full"] = "mpich2/1.2.1p1",
      ["name"] = "mpich2",
      ["parent"] = "default:gcc/4.4.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.2.1p1.lua",
    },
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.3/mpich2/1.2.1p1.lua"] = {
      ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
      ["full"] = "mpich2/1.2.1p1",
      ["name"] = "mpich2",
      ["parent"] = "default:gcc/4.4.3",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.3/mpich2/1.2.1p1.lua",
    },
    ["/local/lmod/modulefiles/Compiler/intel/11.1/mpich2/1.2.1p1.lua"] = {
      ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
      ["full"] = "mpich2/1.2.1p1",
      ["name"] = "mpich2",
      ["parent"] = "default:intel/11.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/intel/11.1/mpich2/1.2.1p1.lua",
    },
  },
  noweb = {
    ["/local/lmod/modulefiles/Core/noweb/2.10c.lua"] = {
      ["Description"] = "Noweb 2.10c",
      ["full"] = "noweb/2.10c",
      ["name"] = "noweb",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/noweb/2.10c.lua",
    },
  },
  openmpi = {
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.3.3-debug.lua"] = {
      ["Description"] = "Openmpi Version of the Message Passing Interface Library",
      ["full"] = "openmpi/1.3.3-debug",
      ["name"] = "openmpi",
      ["parent"] = "default:gcc/4.4.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.3.3-debug.lua",
    },
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.3.3.lua"] = {
      ["Description"] = "Openmpi Version of the Message Passing Interface Library",
      ["full"] = "openmpi/1.3.3",
      ["name"] = "openmpi",
      ["parent"] = "default:gcc/4.4.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.3.3.lua",
    },
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.4.2.lua"] = {
      ["Description"] = "Openmpi Version of the Message Passing Interface Library",
      ["full"] = "openmpi/1.4.2",
      ["name"] = "openmpi",
      ["parent"] = "default:gcc/4.4.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.4.2.lua",
    },
    ["/local/lmod/modulefiles/Compiler/gcc/4.4.3/openmpi/1.4.2.lua"] = {
      ["Description"] = "Openmpi Version of the Message Passing Interface Library",
      ["full"] = "openmpi/1.4.2",
      ["name"] = "openmpi",
      ["parent"] = "default:gcc/4.4.3",
      ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.3/openmpi/1.4.2.lua",
    },
    ["/local/lmod/modulefiles/Compiler/intel/11.1/openmpi/1.4.2.lua"] = {
      ["Description"] = "Openmpi Version of the Message Passing Interface Library",
      ["full"] = "openmpi/1.4.2",
      ["name"] = "openmpi",
      ["parent"] = "default:intel/11.1",
      ["path"] = "/local/lmod/modulefiles/Compiler/intel/11.1/openmpi/1.4.2.lua",
    },
  },
  parmetis = {
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/parmetis/3.1.1.lua"] = {
      ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
      ["Name"] = "ParMETIS: Parallel Graph Partitioning",
      ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
      ["Version"] = "3.1.1",
      ["full"] = "parmetis/3.1.1",
      ["name"] = "parmetis",
      ["parent"] = "default:gcc/4.4.1:mpich2/1.1.1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/parmetis/3.1.1.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/parmetis/3.1.1.lua"] = {
      ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
      ["Name"] = "ParMETIS: Parallel Graph Partitioning",
      ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
      ["Version"] = "3.1.1",
      ["full"] = "parmetis/3.1.1",
      ["name"] = "parmetis",
      ["parent"] = "default:gcc/4.4.1:mpich2/1.1.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/parmetis/3.1.1.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/parmetis/3.1.1.lua"] = {
      ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
      ["Name"] = "ParMETIS: Parallel Graph Partitioning",
      ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
      ["Version"] = "3.1.1",
      ["full"] = "parmetis/3.1.1",
      ["name"] = "parmetis",
      ["parent"] = "default:gcc/4.4.1:openmpi/1.3.3",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/parmetis/3.1.1.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/parmetis/3.1.1.lua"] = {
      ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
      ["Name"] = "ParMETIS: Parallel Graph Partitioning",
      ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
      ["Version"] = "3.1.1",
      ["full"] = "parmetis/3.1.1",
      ["name"] = "parmetis",
      ["parent"] = "default:gcc/4.4.3:mpich2/1.2.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/parmetis/3.1.1.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/parmetis/3.1.1.lua"] = {
      ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
      ["Name"] = "ParMETIS: Parallel Graph Partitioning",
      ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
      ["Version"] = "3.1.1",
      ["full"] = "parmetis/3.1.1",
      ["name"] = "parmetis",
      ["parent"] = "default:gcc/4.4.3:openmpi/1.4.2",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/parmetis/3.1.1.lua",
    },
    ["/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/parmetis/3.1.1.lua"] = {
      ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
      ["Name"] = "ParMETIS: Parallel Graph Partitioning",
      ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
      ["Version"] = "3.1.1",
      ["full"] = "parmetis/3.1.1",
      ["name"] = "parmetis",
      ["parent"] = "default:intel/11.1:mpich2/1.2.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/parmetis/3.1.1.lua",
    },
    ["/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/parmetis/3.1.1.lua"] = {
      ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
      ["Name"] = "ParMETIS: Parallel Graph Partitioning",
      ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
      ["Version"] = "3.1.1",
      ["full"] = "parmetis/3.1.1",
      ["name"] = "parmetis",
      ["parent"] = "default:intel/11.1:openmpi/1.4.2",
      ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/parmetis/3.1.1.lua",
    },
  },
  petsc = {
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/petsc/3.0.0-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.0.0-p5",
      ["full"] = "petsc/3.0.0-debug",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:mpich2/1.1.1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/petsc/3.0.0-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/petsc/3.0.0.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.0.0-p5",
      ["full"] = "petsc/3.0.0",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:mpich2/1.1.1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/petsc/3.0.0.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/2.3.3-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "2.3.3",
      ["full"] = "petsc/2.3.3-debug",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:mpich2/1.1.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/2.3.3-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/2.3.3.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "2.3.3",
      ["full"] = "petsc/2.3.3",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:mpich2/1.1.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/2.3.3.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.0.0-p5",
      ["full"] = "petsc/3.0.0-debug",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:mpich2/1.1.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0-uni-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.0.0-p8",
      ["full"] = "petsc/3.0.0-uni-debug",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:mpich2/1.1.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0-uni-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.0.0-p5",
      ["full"] = "petsc/3.0.0",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:mpich2/1.1.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/2.3.3-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "2.3.3",
      ["full"] = "petsc/2.3.3-debug",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:openmpi/1.3.3",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/2.3.3-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/2.3.3.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "2.3.3",
      ["full"] = "petsc/2.3.3",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:openmpi/1.3.3",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/2.3.3.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.0.0-p5",
      ["full"] = "petsc/3.0.0-debug",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:openmpi/1.3.3",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0-uni-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.0.0-p8",
      ["full"] = "petsc/3.0.0-uni-debug",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:openmpi/1.3.3",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0-uni-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.0.0-p5",
      ["full"] = "petsc/3.0.0",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.1:openmpi/1.3.3",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/petsc/3.1-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.1-p5 debug",
      ["full"] = "petsc/3.1-debug",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.3:mpich2/1.2.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/petsc/3.1-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/petsc/3.1.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.1.p2",
      ["full"] = "petsc/3.1",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.3:mpich2/1.2.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/petsc/3.1.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/petsc/3.1-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.1-p5 debug",
      ["full"] = "petsc/3.1-debug",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.3:openmpi/1.4.2",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/petsc/3.1-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/petsc/3.1.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.1.p2",
      ["full"] = "petsc/3.1",
      ["name"] = "petsc",
      ["parent"] = "default:gcc/4.4.3:openmpi/1.4.2",
      ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/petsc/3.1.lua",
    },
    ["/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/petsc/3.1-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.1-p5 debug",
      ["full"] = "petsc/3.1-debug",
      ["name"] = "petsc",
      ["parent"] = "default:intel/11.1:mpich2/1.2.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/petsc/3.1-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/petsc/3.1.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.1.p2",
      ["full"] = "petsc/3.1",
      ["name"] = "petsc",
      ["parent"] = "default:intel/11.1:mpich2/1.2.1p1",
      ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/petsc/3.1.lua",
    },
    ["/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/petsc/3.1-debug.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.1-p5 debug",
      ["full"] = "petsc/3.1-debug",
      ["name"] = "petsc",
      ["parent"] = "default:intel/11.1:openmpi/1.4.2",
      ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/petsc/3.1-debug.lua",
    },
    ["/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/petsc/3.1.lua"] = {
      ["Description"] = "Numerical library for sparse linear algebra",
      ["Name"] = "PETSc: Portable solver",
      ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
      ["Version"] = "3.1.p2",
      ["full"] = "petsc/3.1",
      ["name"] = "petsc",
      ["parent"] = "default:intel/11.1:openmpi/1.4.2",
      ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/petsc/3.1.lua",
    },
  },
  unix = {
    ["/local/lmod/modulefiles/Core/unix/unix.lua"] = {
      ["Description"] = "Standard Unix paths",
      ["full"] = "unix/unix",
      ["name"] = "unix",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/unix/unix.lua",
    },
  },
  visit = {
    ["/local/lmod/modulefiles/Core/visit/visit.lua"] = {
      ["Description"] = "Visit: A visualization tool",
      ["full"] = "visit/visit",
      ["name"] = "visit",
      ["parent"] = "default",
      ["path"] = "/local/lmod/modulefiles/Core/visit/visit.lua",
    },
  },
}
