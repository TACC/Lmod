-- -*- lua -*-
-- created: Sat Jan  1 10:04:46 2011 --
moduleT = {
  ["/local/lmod/modulefiles/Core/PrgEnv.lua"] = {
    ["Description"] = "Program Environment for this system",
    children = {
    },
    ["full"] = "PrgEnv",
    ["name"] = "PrgEnv",
    ["path"] = "/local/lmod/modulefiles/Core/PrgEnv.lua",
  },
  ["/local/lmod/modulefiles/Core/admin/admin-1.0.lua"] = {
    ["Description"] = "System Admin Paths",
    children = {
    },
    ["full"] = "admin/admin-1.0",
    ["name"] = "admin",
    ["path"] = "/local/lmod/modulefiles/Core/admin/admin-1.0.lua",
  },
  ["/local/lmod/modulefiles/Core/ddt/ddt.lua"] = {
    ["Description"] = "ddt: source code debugger",
    children = {
    },
    ["full"] = "ddt/ddt",
    ["help"] = [[
This is the ddt debugger

]],
    ["name"] = "ddt",
    ["path"] = "/local/lmod/modulefiles/Core/ddt/ddt.lua",
  },
  ["/local/lmod/modulefiles/Core/dmalloc/dmalloc.lua"] = {
    ["Description"] = "Dmalloc: memory checking tool",
    children = {
    },
    ["full"] = "dmalloc/dmalloc",
    ["name"] = "dmalloc",
    ["path"] = "/local/lmod/modulefiles/Core/dmalloc/dmalloc.lua",
  },
  ["/local/lmod/modulefiles/Core/gcc/4.4.1.lua"] = {
    ["Description"] = "Gnu Compiler Collection",
    children = {
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/boost/1.42.0.lua"] = {
        ["Description"] = "Boost library",
        children = {
        },
        ["full"] = "boost/1.42.0",
        ["name"] = "boost",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/boost/1.42.0.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/gotoblas/1.26.lua"] = {
        ["Description"] = "Goto Blas library",
        ["Name"] = "Gotoblas",
        ["URL"] = "http://www.tacc.utexas.edu",
        ["Version"] = "1.26",
        children = {
        },
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
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/gotoblas/1.26.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.1.1.lua"] = {
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        children = {
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/parmetis/3.1.1.lua"] = {
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "parmetis/3.1.1",
            ["name"] = "parmetis",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/parmetis/3.1.1.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/petsc/3.0.0-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.0.0-p5",
            children = {
            },
            ["full"] = "petsc/3.0.0-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/petsc/3.0.0-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/petsc/3.0.0.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.0.0-p5",
            children = {
            },
            ["full"] = "petsc/3.0.0",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1/petsc/3.0.0.lua",
          },
        },
        ["full"] = "mpich2/1.1.1",
        ["name"] = "mpich2",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.1.1.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.1.1p1.lua"] = {
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        children = {
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/parmetis/3.1.1.lua"] = {
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "parmetis/3.1.1",
            ["name"] = "parmetis",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/parmetis/3.1.1.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/2.3.3-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "2.3.3",
            children = {
            },
            ["full"] = "petsc/2.3.3-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/2.3.3-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/2.3.3.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "2.3.3",
            children = {
            },
            ["full"] = "petsc/2.3.3",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/2.3.3.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.0.0-p5",
            children = {
            },
            ["full"] = "petsc/3.0.0-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0-uni-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.0.0-p8",
            children = {
            },
            ["full"] = "petsc/3.0.0-uni-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0-uni-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.0.0-p5",
            children = {
            },
            ["full"] = "petsc/3.0.0",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/mpich2/1.1.1p1/petsc/3.0.0.lua",
          },
        },
        ["full"] = "mpich2/1.1.1p1",
        ["name"] = "mpich2",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.1.1p1.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.2.1p1.lua"] = {
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        children = {
        },
        ["full"] = "mpich2/1.2.1p1",
        ["name"] = "mpich2",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/mpich2/1.2.1p1.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.3.3-debug.lua"] = {
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        children = {
        },
        ["full"] = "openmpi/1.3.3-debug",
        ["name"] = "openmpi",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.3.3-debug.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.3.3.lua"] = {
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        children = {
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/parmetis/3.1.1.lua"] = {
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "parmetis/3.1.1",
            ["name"] = "parmetis",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/parmetis/3.1.1.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/2.3.3-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "2.3.3",
            children = {
            },
            ["full"] = "petsc/2.3.3-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/2.3.3-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/2.3.3.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "2.3.3",
            children = {
            },
            ["full"] = "petsc/2.3.3",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/2.3.3.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.0.0-p5",
            children = {
            },
            ["full"] = "petsc/3.0.0-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0-uni-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.0.0-p8",
            children = {
            },
            ["full"] = "petsc/3.0.0-uni-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0-uni-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.0.0-p5",
            children = {
            },
            ["full"] = "petsc/3.0.0",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.1/openmpi/1.3.3/petsc/3.0.0.lua",
          },
        },
        ["full"] = "openmpi/1.3.3",
        ["name"] = "openmpi",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.3.3.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.4.2.lua"] = {
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        children = {
        },
        ["full"] = "openmpi/1.4.2",
        ["name"] = "openmpi",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.1/openmpi/1.4.2.lua",
      },
    },
    ["full"] = "gcc/4.4.1",
    ["name"] = "gcc",
    ["path"] = "/local/lmod/modulefiles/Core/gcc/4.4.1.lua",
  },
  ["/local/lmod/modulefiles/Core/gcc/4.4.3.lua"] = {
    ["Description"] = "Gnu Compiler Collection",
    children = {
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.3/boost/1.43.0.lua"] = {
        ["Description"] = "Boost library",
        children = {
        },
        ["full"] = "boost/1.43.0",
        ["name"] = "boost",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.3/boost/1.43.0.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.3/gotoblas/1.26.lua"] = {
        ["Description"] = "Goto Blas library",
        ["Name"] = "Gotoblas",
        ["URL"] = "http://www.tacc.utexas.edu",
        ["Version"] = "1.26",
        children = {
        },
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
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.3/gotoblas/1.26.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.3/mpich2/1.2.1p1.lua"] = {
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        children = {
          ["/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/parmetis/3.1.1.lua"] = {
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "parmetis/3.1.1",
            ["name"] = "parmetis",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/parmetis/3.1.1.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/petsc/3.1-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/petsc/3.1-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/petsc/3.1.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p2",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/mpich2/1.2.1p1/petsc/3.1.lua",
          },
        },
        ["full"] = "mpich2/1.2.1p1",
        ["name"] = "mpich2",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.3/mpich2/1.2.1p1.lua",
      },
      ["/local/lmod/modulefiles/Compiler/gcc/4.4.3/openmpi/1.4.2.lua"] = {
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        children = {
          ["/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/parmetis/3.1.1.lua"] = {
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "parmetis/3.1.1",
            ["name"] = "parmetis",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/parmetis/3.1.1.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/petsc/3.1-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/petsc/3.1-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/petsc/3.1.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p2",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/gcc/4.4.3/openmpi/1.4.2/petsc/3.1.lua",
          },
        },
        ["full"] = "openmpi/1.4.2",
        ["name"] = "openmpi",
        ["path"] = "/local/lmod/modulefiles/Compiler/gcc/4.4.3/openmpi/1.4.2.lua",
      },
    },
    ["full"] = "gcc/4.4.3",
    ["name"] = "gcc",
    ["path"] = "/local/lmod/modulefiles/Core/gcc/4.4.3.lua",
  },
  ["/local/lmod/modulefiles/Core/intel/11.1.lua"] = {
    ["Description"] = "Intel Compiler Collection",
    children = {
      ["/local/lmod/modulefiles/Compiler/intel/11.1/boost/1.43.0.lua"] = {
        ["Description"] = "Boost library",
        children = {
        },
        ["full"] = "boost/1.43.0",
        ["name"] = "boost",
        ["path"] = "/local/lmod/modulefiles/Compiler/intel/11.1/boost/1.43.0.lua",
      },
      ["/local/lmod/modulefiles/Compiler/intel/11.1/gotoblas/1.26.lua"] = {
        ["Description"] = "Goto Blas library",
        ["Name"] = "Gotoblas",
        ["URL"] = "http://www.tacc.utexas.edu",
        ["Version"] = "1.26",
        children = {
        },
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
        ["path"] = "/local/lmod/modulefiles/Compiler/intel/11.1/gotoblas/1.26.lua",
      },
      ["/local/lmod/modulefiles/Compiler/intel/11.1/mpich2/1.2.1p1.lua"] = {
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        children = {
          ["/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/parmetis/3.1.1.lua"] = {
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "parmetis/3.1.1",
            ["name"] = "parmetis",
            ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/parmetis/3.1.1.lua",
          },
          ["/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/petsc/3.1-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/petsc/3.1-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/petsc/3.1.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p2",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/mpich2/1.2.1p1/petsc/3.1.lua",
          },
        },
        ["full"] = "mpich2/1.2.1p1",
        ["name"] = "mpich2",
        ["path"] = "/local/lmod/modulefiles/Compiler/intel/11.1/mpich2/1.2.1p1.lua",
      },
      ["/local/lmod/modulefiles/Compiler/intel/11.1/openmpi/1.4.2.lua"] = {
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        children = {
          ["/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/parmetis/3.1.1.lua"] = {
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "parmetis/3.1.1",
            ["name"] = "parmetis",
            ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/parmetis/3.1.1.lua",
          },
          ["/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/petsc/3.1-debug.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/petsc/3.1-debug.lua",
          },
          ["/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/petsc/3.1.lua"] = {
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p2",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["name"] = "petsc",
            ["path"] = "/local/lmod/modulefiles/MPI/intel/11.1/openmpi/1.4.2/petsc/3.1.lua",
          },
        },
        ["full"] = "openmpi/1.4.2",
        ["name"] = "openmpi",
        ["path"] = "/local/lmod/modulefiles/Compiler/intel/11.1/openmpi/1.4.2.lua",
      },
    },
    ["full"] = "intel/11.1",
    ["help"] = [[
This module loads the intel compiler path and environment variables
Used by the intel compiler.      

]],
    ["name"] = "intel",
    ["path"] = "/local/lmod/modulefiles/Core/intel/11.1.lua",
  },
  ["/local/lmod/modulefiles/Core/intel/intel.lua"] = {
    ["Description"] = "Intel Compiler Collection",
    children = {
    },
    ["full"] = "intel/intel",
    ["help"] = [[
This module loads the intel compiler path and environment variables
Used by the intel compiler.      

]],
    ["name"] = "intel",
    ["path"] = "/local/lmod/modulefiles/Core/intel/intel.lua",
  },
  ["/local/lmod/modulefiles/Core/lmod/lmod.lua"] = {
    ["Description"] = "Lmod: An Environment Module System",
    children = {
    },
    ["full"] = "lmod/lmod",
    ["name"] = "lmod",
    ["path"] = "/local/lmod/modulefiles/Core/lmod/lmod.lua",
  },
  ["/local/lmod/modulefiles/Core/local/local.lua"] = {
    ["Description"] = "Local paths",
    children = {
    },
    ["full"] = "local/local",
    ["name"] = "local",
    ["path"] = "/local/lmod/modulefiles/Core/local/local.lua",
  },
  ["/local/lmod/modulefiles/Core/mkl/mkl.lua"] = {
    ["Description"] = "Intel Math Kernel Library",
    children = {
    },
    ["full"] = "mkl/mkl",
    ["help"] = [[
This module loads the intel mkl library and environment variables

]],
    ["name"] = "mkl",
    ["path"] = "/local/lmod/modulefiles/Core/mkl/mkl.lua",
  },
  ["/local/lmod/modulefiles/Core/noweb/2.10c.lua"] = {
    ["Description"] = "Noweb 2.10c",
    children = {
    },
    ["full"] = "noweb/2.10c",
    ["name"] = "noweb",
    ["path"] = "/local/lmod/modulefiles/Core/noweb/2.10c.lua",
  },
  ["/local/lmod/modulefiles/Core/unix/unix.lua"] = {
    ["Description"] = "Standard Unix paths",
    children = {
    },
    ["full"] = "unix/unix",
    ["name"] = "unix",
    ["path"] = "/local/lmod/modulefiles/Core/unix/unix.lua",
  },
  ["/local/lmod/modulefiles/Core/visit/visit.lua"] = {
    ["Description"] = "Visit: A visualization tool",
    children = {
    },
    ["full"] = "visit/visit",
    ["name"] = "visit",
    ["path"] = "/local/lmod/modulefiles/Core/visit/visit.lua",
  },
}
