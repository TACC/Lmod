defaultMpathA = {
  "/opt/apps/modulefiles/Linux",
  "/opt/apps/modulefiles/Core",
}
moduleT = {
  ["/opt/apps/modulefiles/Core/PrgEnv.lua"] = {
    ["Description"] = "Program Environment for this system.",
    children = {
    },
    ["full"] = "PrgEnv",
    ["full_lower"] = "prgenv",
    ["name"] = "PrgEnv",
    ["name_lower"] = "prgenv",
    ["path"] = "/opt/apps/modulefiles/Core/PrgEnv.lua",
    whatis = {
      "Description: Program Environment for this system.",
    },
  },
  ["/opt/apps/modulefiles/Core/admin/admin-1.0.lua"] = {
    ["Description"] = "System Admin Paths",
    children = {
    },
    ["full"] = "admin/admin-1.0",
    ["full_lower"] = "admin/admin-1.0",
    ["name"] = "admin",
    ["name_lower"] = "admin",
    ["path"] = "/opt/apps/modulefiles/Core/admin/admin-1.0.lua",
    pathA = {
      ["/sbin"] = 1,
      ["/usr/sbin"] = 1,
    },
    whatis = {
      "Description: System Admin Paths",
    },
  },
  ["/opt/apps/modulefiles/Core/autotools/1.2.lua"] = {
    ["Description"] = "latest autotools",
    children = {
    },
    ["full"] = "autotools/1.2",
    ["full_lower"] = "autotools/1.2",
    ["name"] = "autotools",
    ["name_lower"] = "autotools",
    ["path"] = "/opt/apps/modulefiles/Core/autotools/1.2.lua",
    pathA = {
      ["/opt/apps/autotools/1.2/bin"] = 1,
    },
    whatis = {
      "Description: latest autotools",
    },
  },
  ["/opt/apps/modulefiles/Core/ddt/ddt.lua"] = {
    ["Description"] = "ddt: source code debugger",
    children = {
    },
    ["full"] = "ddt/ddt",
    ["full_lower"] = "ddt/ddt",
    ["help"] = [[
This is the ddt debugger

]],
    ["name"] = "ddt",
    ["name_lower"] = "ddt",
    ["path"] = "/opt/apps/modulefiles/Core/ddt/ddt.lua",
    pathA = {
      ["/opt/apps/ddt/ddt/bin"] = 1,
    },
    whatis = {
      "Description: ddt: source code debugger",
    },
  },
  ["/opt/apps/modulefiles/Core/dmalloc/dmalloc.lua"] = {
    ["Description"] = "Dmalloc: memory checking tool",
    children = {
    },
    ["full"] = "dmalloc/dmalloc",
    ["full_lower"] = "dmalloc/dmalloc",
    lpathA = {
      ["/usr/lib"] = 1,
    },
    ["name"] = "dmalloc",
    ["name_lower"] = "dmalloc",
    ["path"] = "/opt/apps/modulefiles/Core/dmalloc/dmalloc.lua",
    whatis = {
      "Description: Dmalloc: memory checking tool",
    },
  },
  ["/opt/apps/modulefiles/Core/fdepend/1.2.lua"] = {
    ["Description"] = "fdepend: a fortran dependency generator",
    children = {
    },
    ["full"] = "fdepend/1.2",
    ["full_lower"] = "fdepend/1.2",
    ["name"] = "fdepend",
    ["name_lower"] = "fdepend",
    ["path"] = "/opt/apps/modulefiles/Core/fdepend/1.2.lua",
    pathA = {
      ["/opt/apps/fdepend/1.2/bin"] = 1,
    },
    whatis = {
      "Description: fdepend: a fortran dependency generator",
    },
  },
  ["/opt/apps/modulefiles/Core/fdepend/fdepend.lua"] = {
    ["Description"] = "fdepend: a fortran dependency generator",
    children = {
    },
    ["full"] = "fdepend/fdepend",
    ["full_lower"] = "fdepend/fdepend",
    ["name"] = "fdepend",
    ["name_lower"] = "fdepend",
    ["path"] = "/opt/apps/modulefiles/Core/fdepend/fdepend.lua",
    pathA = {
      ["/opt/apps/fdepend/fdepend/bin"] = 1,
    },
    whatis = {
      "Description: fdepend: a fortran dependency generator",
    },
  },
  ["/opt/apps/modulefiles/Core/gcc/4.4.lua"] = {
    ["Description"] = "Gnu Compiler Collection",
    children = {
    },
    ["full"] = "gcc/4.4",
    ["full_lower"] = "gcc/4.4",
    ["name"] = "gcc",
    ["name_lower"] = "gcc",
    ["path"] = "/opt/apps/modulefiles/Core/gcc/4.4.lua",
    pathA = {
      ["/opt/apps/gcc/4.4/bin"] = 1,
    },
    whatis = {
      "Description: Gnu Compiler Collection",
    },
  },
  ["/opt/apps/modulefiles/Core/gcc/4.5.lua"] = {
    ["Description"] = "Gnu Compiler Collection",
    children = {
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/boost/1.46.0.lua"] = {
        ["Description"] = "Boost library",
        children = {
        },
        ["full"] = "boost/1.46.0",
        ["full_lower"] = "boost/1.46.0",
        lpathA = {
          ["/opt/apps/gcc-4_5/boost/1.46.0/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/boost/1.46.0.lua",
        whatis = {
          "Description: Boost library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/boost/1.46.1.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.41.0",
        children = {
        },
        ["full"] = "boost/1.46.1",
        ["full_lower"] = "boost/1.46.1",
        lpathA = {
          ["/opt/apps/gcc-4_5/boost/1.46.1/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/boost/1.46.1.lua",
        whatis = {
          "Name: boost",
          "Version: 1.41.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/gotoblas2/1.13.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "Goto Blas 2 library",
        ["Name"] = "Gotoblas2",
        ["URL"] = "http://www.tacc.utexas.edu",
        ["Version"] = "1.13",
        children = {
        },
        ["full"] = "gotoblas2/1.13",
        ["full_lower"] = "gotoblas2/1.13",
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
        lpathA = {
          ["/opt/apps/gcc-4_5/gotoblas2/1.13"] = 1,
        },
        ["name"] = "gotoblas2",
        ["name_lower"] = "gotoblas2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/gotoblas2/1.13.lua",
        whatis = {
          "Name: Gotoblas2",
          "Version: 1.13",
          "Category: library, mathematics",
          "Description: Blas Level 1, 2, 3 routines",
          "URL: http://www.tacc.utexas.edu",
          "Description: Goto Blas 2 library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/hdf5/1.8.9-dbg.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.9-dbg",
        children = {
        },
        ["full"] = "hdf5/1.8.9-dbg",
        ["full_lower"] = "hdf5/1.8.9-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_5/hdf5/1.8.9-dbg/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/hdf5/1.8.9-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_5/hdf5/1.8.9-dbg/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.9-dbg",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/hdf5/1.8.9.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.9",
        children = {
        },
        ["full"] = "hdf5/1.8.9",
        ["full_lower"] = "hdf5/1.8.9",
        lpathA = {
          ["/opt/apps/gcc-4_5/hdf5/1.8.9/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/hdf5/1.8.9.lua",
        pathA = {
          ["/opt/apps/gcc-4_5/hdf5/1.8.9/bin"] = 1,
        },
        propT = {
          arch = {
            ["mic"] = 1,
          },
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.9",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/mpich2/1.3.2-dbg.lua"] = {
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_3_2/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/petsc/3.1-debug.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["full_lower"] = "petsc/3.1-debug",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_3_2/petsc/3.1.p8/gcc_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/petsc/3.1-debug.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_3_2/petsc/3.1.p8/gcc_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1-p5 debug",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/petsc/3.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p8",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["full_lower"] = "petsc/3.1",
            lpathA = {
              ["/opt/apps/mpich2-1_3_2/petsc-3_1/petsc/3.1.p8/mpich2_opt-petsc/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/petsc/3.1.lua",
            pathA = {
              ["/opt/apps/mpich2-1_3_2/petsc-3_1/petsc/3.1.p8/mpich2_opt-petsc/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1.p8",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_3_2/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
        },
        ["full"] = "mpich2/1.3.2-dbg",
        ["full_lower"] = "mpich2/1.3.2-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_5/mpich2/1.3.2-dbg/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/mpich2/1.3.2-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_5/mpich2/1.3.2-dbg/bin"] = 1,
        },
        whatis = {
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/mpich2/1.3.2.lua"] = {
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_3_2/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/petsc/3.1-debug.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["full_lower"] = "petsc/3.1-debug",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_3_2/petsc/3.1.p8/gcc_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/petsc/3.1-debug.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_3_2/petsc/3.1.p8/gcc_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1-p5 debug",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/petsc/3.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p8",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["full_lower"] = "petsc/3.1",
            lpathA = {
              ["/opt/apps/mpich2-1_3_2/petsc-3_1/petsc/3.1.p8/mpich2_opt-petsc/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/petsc/3.1.lua",
            pathA = {
              ["/opt/apps/mpich2-1_3_2/petsc-3_1/petsc/3.1.p8/mpich2_opt-petsc/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1.p8",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_3_2/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.3.2/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
        },
        ["full"] = "mpich2/1.3.2",
        ["full_lower"] = "mpich2/1.3.2",
        lpathA = {
          ["/opt/apps/gcc-4_5/mpich2/1.3.2/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/mpich2/1.3.2.lua",
        pathA = {
          ["/opt/apps/gcc-4_5/mpich2/1.3.2/bin"] = 1,
        },
        whatis = {
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/mpich2/1.4-dbg.lua"] = {
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/petsc/3.1-debug.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["full_lower"] = "petsc/3.1-debug",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/petsc/3.1.p8/gcc_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/petsc/3.1-debug.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/petsc/3.1.p8/gcc_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1-p5 debug",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/petsc/3.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p8",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["full_lower"] = "petsc/3.1",
            lpathA = {
              ["/opt/apps/mpich2-1_4/petsc-3_1/petsc/3.1.p8/mpich2_opt-petsc/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/petsc/3.1.lua",
            pathA = {
              ["/opt/apps/mpich2-1_4/petsc-3_1/petsc/3.1.p8/mpich2_opt-petsc/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1.p8",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "mpich2/1.4-dbg",
        ["full_lower"] = "mpich2/1.4-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_5/mpich2/1.4-dbg/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/mpich2/1.4-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_5/mpich2/1.4-dbg/bin"] = 1,
        },
        whatis = {
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/mpich2/1.4.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        ["Name"] = "mpich2",
        ["Version"] = "1.4",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/petsc/3.1-debug.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["full_lower"] = "petsc/3.1-debug",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/petsc/3.1.p8/gcc_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/petsc/3.1-debug.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/petsc/3.1.p8/gcc_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1-p5 debug",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/petsc/3.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p8",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["full_lower"] = "petsc/3.1",
            lpathA = {
              ["/opt/apps/mpich2-1_4/petsc-3_1/petsc/3.1.p8/mpich2_opt-petsc/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/petsc/3.1.lua",
            pathA = {
              ["/opt/apps/mpich2-1_4/petsc-3_1/petsc/3.1.p8/mpich2_opt-petsc/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1.p8",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/mpich2/1.4/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/mpich2-1_4/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "mpich2/1.4",
        ["full_lower"] = "mpich2/1.4",
        lpathA = {
          ["/opt/apps/gcc-4_5/mpich2/1.4/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/mpich2/1.4.lua",
        pathA = {
          ["/opt/apps/gcc-4_5/mpich2/1.4/bin"] = 1,
        },
        whatis = {
          "Name: mpich2",
          "Version: 1.4",
          "Category: library, runtime support",
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/openmpi/1.5.1-dbg.lua"] = {
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        children = {
        },
        ["full"] = "openmpi/1.5.1-dbg",
        ["full_lower"] = "openmpi/1.5.1-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_5/openmpi/1.5.1-dbg/lib"] = 1,
          ["/opt/apps/gcc-4_5/openmpi/1.5.1-dbg/lib/openmpi"] = 1,
        },
        ["name"] = "openmpi",
        ["name_lower"] = "openmpi",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/openmpi/1.5.1-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_5/openmpi/1.5.1-dbg/bin"] = 1,
        },
        whatis = {
          "Description: Openmpi Version of the Message Passing Interface Library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/openmpi/1.5.1.lua"] = {
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.1/petsc/3.1-debug.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["full_lower"] = "petsc/3.1-debug",
            lpathA = {
              ["/opt/apps/gcc-4_5/openmpi-1_5_1/petsc/3.1.p8/gcc_opt-openmpi-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.1/petsc/3.1-debug.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/openmpi-1_5_1/petsc/3.1.p8/gcc_opt-openmpi-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1-p5 debug",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.1/petsc/3.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p8",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["full_lower"] = "petsc/3.1",
            lpathA = {
              ["/opt/apps/openmpi-1_5_1/petsc-3_1/petsc/3.1.p8/openmpi_opt-petsc/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.1/petsc/3.1.lua",
            pathA = {
              ["/opt/apps/openmpi-1_5_1/petsc-3_1/petsc/3.1.p8/openmpi_opt-petsc/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1.p8",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.1/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/gcc-4_5/openmpi-1_5_1/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.1/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
        },
        ["full"] = "openmpi/1.5.1",
        ["full_lower"] = "openmpi/1.5.1",
        lpathA = {
          ["/opt/apps/gcc-4_5/openmpi/1.5.1/lib"] = 1,
          ["/opt/apps/gcc-4_5/openmpi/1.5.1/lib/openmpi"] = 1,
        },
        ["name"] = "openmpi",
        ["name_lower"] = "openmpi",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/openmpi/1.5.1.lua",
        pathA = {
          ["/opt/apps/gcc-4_5/openmpi/1.5.1/bin"] = 1,
        },
        whatis = {
          "Description: Openmpi Version of the Message Passing Interface Library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.5/openmpi/1.5.3.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        ["Name"] = "openmpi",
        ["Version"] = "1.5.3",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.3/petsc/3.1-debug.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1-p5 debug",
            children = {
            },
            ["full"] = "petsc/3.1-debug",
            ["full_lower"] = "petsc/3.1-debug",
            lpathA = {
              ["/opt/apps/gcc-4_5/openmpi-1_5_3/petsc/3.1.p8/gcc_opt-openmpi-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.3/petsc/3.1-debug.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/openmpi-1_5_3/petsc/3.1.p8/gcc_opt-openmpi-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1-p5 debug",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.3/petsc/3.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.1.p8",
            children = {
            },
            ["full"] = "petsc/3.1",
            ["full_lower"] = "petsc/3.1",
            lpathA = {
              ["/opt/apps/openmpi-1_5_3/petsc-3_1/petsc/3.1.p8/openmpi_opt-petsc/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.3/petsc/3.1.lua",
            pathA = {
              ["/opt/apps/openmpi-1_5_3/petsc-3_1/petsc/3.1.p8/openmpi_opt-petsc/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.1.p8",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.3/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/gcc-4_5/openmpi-1_5_3/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.3/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.3/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/gcc-4_5/openmpi-1_5_3/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.5/openmpi/1.5.3/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/gcc-4_5/openmpi-1_5_3/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "openmpi/1.5.3",
        ["full_lower"] = "openmpi/1.5.3",
        lpathA = {
          ["/opt/apps/gcc-4_5/openmpi/1.5.3/lib"] = 1,
          ["/opt/apps/gcc-4_5/openmpi/1.5.3/lib/openmpi"] = 1,
        },
        ["name"] = "openmpi",
        ["name_lower"] = "openmpi",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.5/openmpi/1.5.3.lua",
        pathA = {
          ["/opt/apps/gcc-4_5/openmpi/1.5.3/bin"] = 1,
        },
        whatis = {
          "Name: openmpi",
          "Version: 1.5.3",
          "Category: library, runtime support",
          "Description: Openmpi Version of the Message Passing Interface Library",
        },
      },
    },
    ["full"] = "gcc/4.5",
    ["full_lower"] = "gcc/4.5",
    ["name"] = "gcc",
    ["name_lower"] = "gcc",
    ["path"] = "/opt/apps/modulefiles/Core/gcc/4.5.lua",
    whatis = {
      "Description: Gnu Compiler Collection",
    },
  },
  ["/opt/apps/modulefiles/Core/gcc/4.6.2.lua"] = {
    ["Description"] = "Gnu Compiler Collection",
    children = {
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.46.1.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.41.0",
        children = {
        },
        ["full"] = "boost/1.46.1",
        ["full_lower"] = "boost/1.46.1",
        lpathA = {
          ["/opt/apps/gcc-4_6/boost/1.46.1/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.46.1.lua",
        whatis = {
          "Name: boost",
          "Version: 1.41.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.48.0.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.48.0",
        children = {
        },
        ["full"] = "boost/1.48.0",
        ["full_lower"] = "boost/1.48.0",
        lpathA = {
          ["/opt/apps/gcc-4_6/boost/1.48.0/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.48.0.lua",
        whatis = {
          "Name: boost",
          "Version:1.48.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.49.0.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.49.0",
        children = {
        },
        ["full"] = "boost/1.49.0",
        ["full_lower"] = "boost/1.49.0",
        lpathA = {
          ["/opt/apps/gcc-4_6/boost/1.49.0/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.49.0.lua",
        propT = {
          arch = {
            ["mic"] = 1,
          },
        },
        whatis = {
          "Name: boost",
          "Version:1.49.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/gotoblas2/1.13.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "Goto Blas 2 library",
        ["Name"] = "Gotoblas2",
        ["URL"] = "http://www.tacc.utexas.edu",
        ["Version"] = "1.13",
        children = {
        },
        ["full"] = "gotoblas2/1.13",
        ["full_lower"] = "gotoblas2/1.13",
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
        lpathA = {
          ["/opt/apps/gcc-4_6/gotoblas2/1.13"] = 1,
        },
        ["name"] = "gotoblas2",
        ["name_lower"] = "gotoblas2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/gotoblas2/1.13.lua",
        whatis = {
          "Name: Gotoblas2",
          "Version: 1.13",
          "Category: library, mathematics",
          "Description: Blas Level 1, 2, 3 routines",
          "URL: http://www.tacc.utexas.edu",
          "Description: Goto Blas 2 library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.8-dbg.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.8-dbg",
        children = {
        },
        ["full"] = "hdf5/1.8.8-dbg",
        ["full_lower"] = "hdf5/1.8.8-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.8-dbg/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.8-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.8-dbg/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.8-dbg",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.8.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.8",
        children = {
        },
        ["full"] = "hdf5/1.8.8",
        ["full_lower"] = "hdf5/1.8.8",
        lpathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.8/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.8.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.8/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.8",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.9-dbg.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.9-dbg",
        children = {
        },
        ["full"] = "hdf5/1.8.9-dbg",
        ["full_lower"] = "hdf5/1.8.9-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.9-dbg/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.9-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.9-dbg/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.9-dbg",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.9.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.9",
        children = {
        },
        ["full"] = "hdf5/1.8.9",
        ["full_lower"] = "hdf5/1.8.9",
        lpathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.9/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.9.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.9/bin"] = 1,
        },
        propT = {
          arch = {
            ["mic"] = 1,
          },
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.9",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/metis/5.0.2.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "Graph partitioning and fill-reduction matrix ordering routines",
        ["Name"] = "METIS: Graph Partitioning",
        ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
        ["Version"] = "5.0.2",
        children = {
        },
        ["full"] = "metis/5.0.2",
        ["full_lower"] = "metis/5.0.2",
        lpathA = {
          ["/opt/apps/gcc-4_6/metis/5.0.2/lib"] = 1,
        },
        ["name"] = "metis",
        ["name_lower"] = "metis",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/metis/5.0.2.lua",
        whatis = {
          "Name:METIS: Graph Partitioning",
          "Version: 5.0.2",
          "Category: library, mathematics",
          "Description: Graph partitioning and fill-reduction matrix ordering routines",
          "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/mpich2/1.4.1-dbg.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        ["Name"] = "mpich2",
        ["Version"] = "1.4.1-dbg",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2-dbg",
            children = {
            },
            ["full"] = "petsc/3.2-dbg",
            ["full_lower"] = "petsc/3.2-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2-dbg",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2",
            children = {
            },
            ["full"] = "petsc/3.2",
            ["full_lower"] = "petsc/3.2",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.8-dbg",
            ["full_lower"] = "phdf5/1.8.8-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8",
            children = {
            },
            ["full"] = "phdf5/1.8.8",
            ["full_lower"] = "phdf5/1.8.8",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "mpich2/1.4.1-dbg",
        ["full_lower"] = "mpich2/1.4.1-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_6/mpich2/1.4.1-dbg/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/mpich2/1.4.1-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/mpich2/1.4.1-dbg/bin"] = 1,
        },
        whatis = {
          "Name: mpich2",
          "Version: 1.4.1-dbg",
          "Category: library, runtime support",
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/mpich2/1.4.1.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        ["Name"] = "mpich2",
        ["Version"] = "1.4.1",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2-dbg",
            children = {
            },
            ["full"] = "petsc/3.2-dbg",
            ["full_lower"] = "petsc/3.2-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2-dbg",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2",
            children = {
            },
            ["full"] = "petsc/3.2",
            ["full_lower"] = "petsc/3.2",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.8-dbg",
            ["full_lower"] = "phdf5/1.8.8-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8",
            children = {
            },
            ["full"] = "phdf5/1.8.8",
            ["full_lower"] = "phdf5/1.8.8",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "mpich2/1.4.1",
        ["full_lower"] = "mpich2/1.4.1",
        lpathA = {
          ["/opt/apps/gcc-4_6/mpich2/1.4.1/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/mpich2/1.4.1.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/mpich2/1.4.1/bin"] = 1,
        },
        whatis = {
          "Name: mpich2",
          "Version: 1.4.1",
          "Category: library, runtime support",
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/openmpi/1.5.4.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        ["Name"] = "openmpi",
        ["Version"] = "1.5.4",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/petsc/3.2-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2-dbg",
            children = {
            },
            ["full"] = "petsc/3.2-dbg",
            ["full_lower"] = "petsc/3.2-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/petsc/3.2/gcc_opt-openmpi-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/petsc/3.2-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/petsc/3.2/gcc_opt-openmpi-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2-dbg",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/petsc/3.2.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2",
            children = {
            },
            ["full"] = "petsc/3.2",
            ["full_lower"] = "petsc/3.2",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/petsc/3.2/gcc_opt-openmpi/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/petsc/3.2.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/petsc/3.2/gcc_opt-openmpi/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.8-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.8-dbg",
            ["full_lower"] = "phdf5/1.8.8-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.8-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.8-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.8-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.8.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8",
            children = {
            },
            ["full"] = "phdf5/1.8.8",
            ["full_lower"] = "phdf5/1.8.8",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.8/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.8.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.8/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "openmpi/1.5.4",
        ["full_lower"] = "openmpi/1.5.4",
        lpathA = {
          ["/opt/apps/gcc-4_6/openmpi/1.5.4/lib"] = 1,
          ["/opt/apps/gcc-4_6/openmpi/1.5.4/lib/openmpi"] = 1,
        },
        ["name"] = "openmpi",
        ["name_lower"] = "openmpi",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/openmpi/1.5.4.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/openmpi/1.5.4/bin"] = 1,
        },
        whatis = {
          "Name: openmpi",
          "Version: 1.5.4",
          "Category: library, runtime support",
          "Description: Openmpi Version of the Message Passing Interface Library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/openmpi/1.6.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        ["Name"] = "openmpi",
        ["Version"] = "1.6",
        children = {
        },
        ["full"] = "openmpi/1.6",
        ["full_lower"] = "openmpi/1.6",
        lpathA = {
          ["/opt/apps/gcc-4_6/openmpi/1.6/lib"] = 1,
          ["/opt/apps/gcc-4_6/openmpi/1.6/lib/openmpi"] = 1,
        },
        ["name"] = "openmpi",
        ["name_lower"] = "openmpi",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/openmpi/1.6.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/openmpi/1.6/bin"] = 1,
        },
        whatis = {
          "Name: openmpi",
          "Version: 1.6",
          "Category: library, runtime support",
          "Description: Openmpi Version of the Message Passing Interface Library",
        },
      },
    },
    ["full"] = "gcc/4.6.2",
    ["full_lower"] = "gcc/4.6.2",
    lpathA = {
      ["/opt/apps/cloog/0.15.11/lib"] = 1,
      ["/opt/apps/gcc/4.6.2/lib/gcc/x86_64-unknown-linux-gnu/4.6.2"] = 1,
      ["/opt/apps/gcc/4.6.2/lib64"] = 1,
      ["/opt/apps/gcc/4.6.2/libexec/gcc/x86_64-unknown-linux-gnu/4.6.2"] = 1,
    },
    ["name"] = "gcc",
    ["name_lower"] = "gcc",
    ["path"] = "/opt/apps/modulefiles/Core/gcc/4.6.2.lua",
    pathA = {
      ["/opt/apps/gcc/4.6.2/bin"] = 1,
    },
    whatis = {
      "Description: Gnu Compiler Collection",
    },
  },
  ["/opt/apps/modulefiles/Core/gcc/4.6.lua"] = {
    ["Description"] = "Gnu Compiler Collection",
    children = {
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.46.1.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.41.0",
        children = {
        },
        ["full"] = "boost/1.46.1",
        ["full_lower"] = "boost/1.46.1",
        lpathA = {
          ["/opt/apps/gcc-4_6/boost/1.46.1/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.46.1.lua",
        whatis = {
          "Name: boost",
          "Version: 1.41.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.48.0.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.48.0",
        children = {
        },
        ["full"] = "boost/1.48.0",
        ["full_lower"] = "boost/1.48.0",
        lpathA = {
          ["/opt/apps/gcc-4_6/boost/1.48.0/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.48.0.lua",
        whatis = {
          "Name: boost",
          "Version:1.48.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.49.0.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.49.0",
        children = {
        },
        ["full"] = "boost/1.49.0",
        ["full_lower"] = "boost/1.49.0",
        lpathA = {
          ["/opt/apps/gcc-4_6/boost/1.49.0/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/boost/1.49.0.lua",
        propT = {
          arch = {
            ["mic"] = 1,
          },
        },
        whatis = {
          "Name: boost",
          "Version:1.49.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/gotoblas2/1.13.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "Goto Blas 2 library",
        ["Name"] = "Gotoblas2",
        ["URL"] = "http://www.tacc.utexas.edu",
        ["Version"] = "1.13",
        children = {
        },
        ["full"] = "gotoblas2/1.13",
        ["full_lower"] = "gotoblas2/1.13",
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
        lpathA = {
          ["/opt/apps/gcc-4_6/gotoblas2/1.13"] = 1,
        },
        ["name"] = "gotoblas2",
        ["name_lower"] = "gotoblas2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/gotoblas2/1.13.lua",
        whatis = {
          "Name: Gotoblas2",
          "Version: 1.13",
          "Category: library, mathematics",
          "Description: Blas Level 1, 2, 3 routines",
          "URL: http://www.tacc.utexas.edu",
          "Description: Goto Blas 2 library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.8-dbg.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.8-dbg",
        children = {
        },
        ["full"] = "hdf5/1.8.8-dbg",
        ["full_lower"] = "hdf5/1.8.8-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.8-dbg/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.8-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.8-dbg/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.8-dbg",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.8.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.8",
        children = {
        },
        ["full"] = "hdf5/1.8.8",
        ["full_lower"] = "hdf5/1.8.8",
        lpathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.8/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.8.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.8/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.8",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.9-dbg.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.9-dbg",
        children = {
        },
        ["full"] = "hdf5/1.8.9-dbg",
        ["full_lower"] = "hdf5/1.8.9-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.9-dbg/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.9-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.9-dbg/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.9-dbg",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.9.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.9",
        children = {
        },
        ["full"] = "hdf5/1.8.9",
        ["full_lower"] = "hdf5/1.8.9",
        lpathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.9/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/hdf5/1.8.9.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/hdf5/1.8.9/bin"] = 1,
        },
        propT = {
          arch = {
            ["mic"] = 1,
          },
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.9",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/metis/5.0.2.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "Graph partitioning and fill-reduction matrix ordering routines",
        ["Name"] = "METIS: Graph Partitioning",
        ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
        ["Version"] = "5.0.2",
        children = {
        },
        ["full"] = "metis/5.0.2",
        ["full_lower"] = "metis/5.0.2",
        lpathA = {
          ["/opt/apps/gcc-4_6/metis/5.0.2/lib"] = 1,
        },
        ["name"] = "metis",
        ["name_lower"] = "metis",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/metis/5.0.2.lua",
        whatis = {
          "Name:METIS: Graph Partitioning",
          "Version: 5.0.2",
          "Category: library, mathematics",
          "Description: Graph partitioning and fill-reduction matrix ordering routines",
          "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/mpich2/1.4.1-dbg.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        ["Name"] = "mpich2",
        ["Version"] = "1.4.1-dbg",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2-dbg",
            children = {
            },
            ["full"] = "petsc/3.2-dbg",
            ["full_lower"] = "petsc/3.2-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2-dbg",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2",
            children = {
            },
            ["full"] = "petsc/3.2",
            ["full_lower"] = "petsc/3.2",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.8-dbg",
            ["full_lower"] = "phdf5/1.8.8-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8",
            children = {
            },
            ["full"] = "phdf5/1.8.8",
            ["full_lower"] = "phdf5/1.8.8",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "mpich2/1.4.1-dbg",
        ["full_lower"] = "mpich2/1.4.1-dbg",
        lpathA = {
          ["/opt/apps/gcc-4_6/mpich2/1.4.1-dbg/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/mpich2/1.4.1-dbg.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/mpich2/1.4.1-dbg/bin"] = 1,
        },
        whatis = {
          "Name: mpich2",
          "Version: 1.4.1-dbg",
          "Category: library, runtime support",
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/mpich2/1.4.1.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        ["Name"] = "mpich2",
        ["Version"] = "1.4.1",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2-dbg",
            children = {
            },
            ["full"] = "petsc/3.2-dbg",
            ["full_lower"] = "petsc/3.2-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2-dbg",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2",
            children = {
            },
            ["full"] = "petsc/3.2",
            ["full_lower"] = "petsc/3.2",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/petsc/3.2.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/petsc/3.2/gcc_opt-mpich2/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.8-dbg",
            ["full_lower"] = "phdf5/1.8.8-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8",
            children = {
            },
            ["full"] = "phdf5/1.8.8",
            ["full_lower"] = "phdf5/1.8.8",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.8.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.8/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/mpich2/1.4.1/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/mpich2-1_4_1/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "mpich2/1.4.1",
        ["full_lower"] = "mpich2/1.4.1",
        lpathA = {
          ["/opt/apps/gcc-4_6/mpich2/1.4.1/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/mpich2/1.4.1.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/mpich2/1.4.1/bin"] = 1,
        },
        whatis = {
          "Name: mpich2",
          "Version: 1.4.1",
          "Category: library, runtime support",
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/openmpi/1.5.4.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        ["Name"] = "openmpi",
        ["Version"] = "1.5.4",
        children = {
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/petsc/3.2-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2-dbg",
            children = {
            },
            ["full"] = "petsc/3.2-dbg",
            ["full_lower"] = "petsc/3.2-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/petsc/3.2/gcc_opt-openmpi-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/petsc/3.2-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/petsc/3.2/gcc_opt-openmpi-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2-dbg",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/petsc/3.2.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2",
            children = {
            },
            ["full"] = "petsc/3.2",
            ["full_lower"] = "petsc/3.2",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/petsc/3.2/gcc_opt-openmpi/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/petsc/3.2.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/petsc/3.2/gcc_opt-openmpi/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.8-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.8-dbg",
            ["full_lower"] = "phdf5/1.8.8-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.8-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.8-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.8-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.8.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8",
            children = {
            },
            ["full"] = "phdf5/1.8.8",
            ["full_lower"] = "phdf5/1.8.8",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.8/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.8.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.8/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/gcc/4.6/openmpi/1.5.4/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/gcc-4_6/openmpi-1_5_4/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "openmpi/1.5.4",
        ["full_lower"] = "openmpi/1.5.4",
        lpathA = {
          ["/opt/apps/gcc-4_6/openmpi/1.5.4/lib"] = 1,
          ["/opt/apps/gcc-4_6/openmpi/1.5.4/lib/openmpi"] = 1,
        },
        ["name"] = "openmpi",
        ["name_lower"] = "openmpi",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/openmpi/1.5.4.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/openmpi/1.5.4/bin"] = 1,
        },
        whatis = {
          "Name: openmpi",
          "Version: 1.5.4",
          "Category: library, runtime support",
          "Description: Openmpi Version of the Message Passing Interface Library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/gcc/4.6/openmpi/1.6.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        ["Name"] = "openmpi",
        ["Version"] = "1.6",
        children = {
        },
        ["full"] = "openmpi/1.6",
        ["full_lower"] = "openmpi/1.6",
        lpathA = {
          ["/opt/apps/gcc-4_6/openmpi/1.6/lib"] = 1,
          ["/opt/apps/gcc-4_6/openmpi/1.6/lib/openmpi"] = 1,
        },
        ["name"] = "openmpi",
        ["name_lower"] = "openmpi",
        ["path"] = "/opt/apps/modulefiles/Compiler/gcc/4.6/openmpi/1.6.lua",
        pathA = {
          ["/opt/apps/gcc-4_6/openmpi/1.6/bin"] = 1,
        },
        whatis = {
          "Name: openmpi",
          "Version: 1.6",
          "Category: library, runtime support",
          "Description: Openmpi Version of the Message Passing Interface Library",
        },
      },
    },
    ["full"] = "gcc/4.6",
    ["full_lower"] = "gcc/4.6",
    lpathA = {
      ["/opt/apps/cloog/0.15.11/lib"] = 1,
      ["/opt/apps/gcc/4.6.1/lib/gcc/x86_64-unknown-linux-gnu/4.6.1"] = 1,
      ["/opt/apps/gcc/4.6.1/lib64"] = 1,
      ["/opt/apps/gcc/4.6.1/libexec/gcc/x86_64-unknown-linux-gnu/4.6.1"] = 1,
    },
    ["name"] = "gcc",
    ["name_lower"] = "gcc",
    ["path"] = "/opt/apps/modulefiles/Core/gcc/4.6.lua",
    pathA = {
      ["/opt/apps/gcc/4.6.1/bin"] = 1,
    },
    whatis = {
      "Description: Gnu Compiler Collection",
    },
  },
  ["/opt/apps/modulefiles/Core/handbrake/0.9.5.lua"] = {
    children = {
    },
    ["full"] = "handbrake/0.9.5",
    ["full_lower"] = "handbrake/0.9.5",
    ["name"] = "handbrake",
    ["name_lower"] = "handbrake",
    ["path"] = "/opt/apps/modulefiles/Core/handbrake/0.9.5.lua",
    pathA = {
      ["/opt/apps/handbrake/0.9.5/bin"] = 1,
    },
  },
  ["/opt/apps/modulefiles/Core/hashrf/6.0.1.lua"] = {
    ["Category"] = "phylogenetics",
    ["Description"] = "hash phylo trees",
    ["Name"] = "hashrf",
    ["Version"] = "6.0.1",
    children = {
    },
    ["full"] = "hashrf/6.0.1",
    ["full_lower"] = "hashrf/6.0.1",
    ["name"] = "hashrf",
    ["name_lower"] = "hashrf",
    ["path"] = "/opt/apps/modulefiles/Core/hashrf/6.0.1.lua",
    pathA = {
      ["/opt/apps/hashrf/6.0.1/bin"] = 1,
    },
    whatis = {
      "Name: hashrf",
      "Version: 6.0.1",
      "Category: phylogenetics",
      "Description: hash phylo trees",
    },
  },
  ["/opt/apps/modulefiles/Core/intel/12.1.lua"] = {
    ["Description"] = "Intel Compiler Collection",
    children = {
      ["/opt/apps/modulefiles/Compiler/intel/12.1/boost/1.46.1.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.41.0",
        children = {
        },
        ["full"] = "boost/1.46.1",
        ["full_lower"] = "boost/1.46.1",
        lpathA = {
          ["/opt/apps/intel-12_1/boost/1.46.1/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/boost/1.46.1.lua",
        whatis = {
          "Name: boost",
          "Version: 1.41.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/boost/1.48.0.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.48.0",
        children = {
        },
        ["full"] = "boost/1.48.0",
        ["full_lower"] = "boost/1.48.0",
        lpathA = {
          ["/opt/apps/intel-12_1/boost/1.48.0/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/boost/1.48.0.lua",
        whatis = {
          "Name: boost",
          "Version:1.48.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/boost/1.49.0.lua"] = {
        ["Category"] = "System Environment/Base",
        ["Description"] = "Boost provides free peer-reviewed portable C++ source libraries.",
        ["Name"] = "boost",
        ["URL"] = "http://www.boost.org",
        ["Version"] = "1.49.0",
        children = {
        },
        ["full"] = "boost/1.49.0",
        ["full_lower"] = "boost/1.49.0",
        lpathA = {
          ["/opt/apps/intel-12_1/boost/1.49.0/lib"] = 1,
        },
        ["name"] = "boost",
        ["name_lower"] = "boost",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/boost/1.49.0.lua",
        propT = {
          arch = {
            ["mic"] = 1,
          },
        },
        whatis = {
          "Name: boost",
          "Version:1.49.0",
          "Category: System Environment/Base",
          "URL: http://www.boost.org",
          "Description: Boost provides free peer-reviewed portable C++ source libraries.",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/gotoblas2/1.13.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "Goto Blas 2 library",
        ["Name"] = "Gotoblas2",
        ["URL"] = "http://www.tacc.utexas.edu",
        ["Version"] = "1.13",
        children = {
        },
        ["full"] = "gotoblas2/1.13",
        ["full_lower"] = "gotoblas2/1.13",
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
        lpathA = {
          ["/opt/apps/intel-12_1/gotoblas2/1.13"] = 1,
        },
        ["name"] = "gotoblas2",
        ["name_lower"] = "gotoblas2",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/gotoblas2/1.13.lua",
        whatis = {
          "Name: Gotoblas2",
          "Version: 1.13",
          "Category: library, mathematics",
          "Description: Blas Level 1, 2, 3 routines",
          "URL: http://www.tacc.utexas.edu",
          "Description: Goto Blas 2 library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/hdf5/1.8.8-dbg.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.8-dbg",
        children = {
        },
        ["full"] = "hdf5/1.8.8-dbg",
        ["full_lower"] = "hdf5/1.8.8-dbg",
        lpathA = {
          ["/opt/apps/intel-12_1/hdf5/1.8.8-dbg/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/hdf5/1.8.8-dbg.lua",
        pathA = {
          ["/opt/apps/intel-12_1/hdf5/1.8.8-dbg/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.8-dbg",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/hdf5/1.8.8.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.8",
        children = {
        },
        ["full"] = "hdf5/1.8.8",
        ["full_lower"] = "hdf5/1.8.8",
        lpathA = {
          ["/opt/apps/intel-12_1/hdf5/1.8.8/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/hdf5/1.8.8.lua",
        pathA = {
          ["/opt/apps/intel-12_1/hdf5/1.8.8/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.8",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/hdf5/1.8.9-dbg.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.9-dbg",
        children = {
        },
        ["full"] = "hdf5/1.8.9-dbg",
        ["full_lower"] = "hdf5/1.8.9-dbg",
        lpathA = {
          ["/opt/apps/intel-12_1/hdf5/1.8.9-dbg/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/hdf5/1.8.9-dbg.lua",
        pathA = {
          ["/opt/apps/intel-12_1/hdf5/1.8.9-dbg/bin"] = 1,
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.9-dbg",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/hdf5/1.8.9.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "General purpose library and file format for storing scientific data",
        ["Name"] = "HDF5",
        ["URL"] = "http://www.hdfgroup.org/HDF5",
        ["Version"] = "1.8.9",
        children = {
        },
        ["full"] = "hdf5/1.8.9",
        ["full_lower"] = "hdf5/1.8.9",
        lpathA = {
          ["/opt/apps/intel-12_1/hdf5/1.8.9/lib"] = 1,
        },
        ["name"] = "hdf5",
        ["name_lower"] = "hdf5",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/hdf5/1.8.9.lua",
        pathA = {
          ["/opt/apps/intel-12_1/hdf5/1.8.9/bin"] = 1,
        },
        propT = {
          arch = {
            ["mic"] = 1,
          },
        },
        whatis = {
          "Name: HDF5",
          "Version: 1.8.9",
          "Category: library, mathematics",
          "URL: http://www.hdfgroup.org/HDF5",
          "Description: General purpose library and file format for storing scientific data",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/metis/4.0.1.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "Serial mesh partitioner",
        ["Name"] = "metis",
        ["Version"] = "4.0.1",
        children = {
        },
        ["full"] = "metis/4.0.1",
        ["full_lower"] = "metis/4.0.1",
        lpathA = {
          ["/opt/apps/intel-12_1/metis/4.0.1/lib"] = 1,
        },
        ["name"] = "metis",
        ["name_lower"] = "metis",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/metis/4.0.1.lua",
        whatis = {
          "Name: metis",
          "Version: 4.0.1",
          "Category: library, mathematics",
          "Description: Serial mesh partitioner",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/metis/5.0.2.lua"] = {
        ["Category"] = "library, mathematics",
        ["Description"] = "Graph partitioning and fill-reduction matrix ordering routines",
        ["Name"] = "METIS: Graph Partitioning",
        ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
        ["Version"] = "5.0.2",
        children = {
        },
        ["full"] = "metis/5.0.2",
        ["full_lower"] = "metis/5.0.2",
        lpathA = {
          ["/opt/apps/intel-12_1/metis/5.0.2/lib"] = 1,
        },
        ["name"] = "metis",
        ["name_lower"] = "metis",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/metis/5.0.2.lua",
        whatis = {
          "Name:METIS: Graph Partitioning",
          "Version: 5.0.2",
          "Category: library, mathematics",
          "Description: Graph partitioning and fill-reduction matrix ordering routines",
          "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/mpich2/1.4.1-dbg.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        ["Name"] = "mpich2",
        ["Version"] = "1.4.1-dbg",
        children = {
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/petsc/3.2-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2-dbg",
            children = {
            },
            ["full"] = "petsc/3.2-dbg",
            ["full_lower"] = "petsc/3.2-dbg",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/petsc/3.2/intel_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/petsc/3.2-dbg.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/petsc/3.2/intel_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2-dbg",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/petsc/3.2.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2",
            children = {
            },
            ["full"] = "petsc/3.2",
            ["full_lower"] = "petsc/3.2",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/petsc/3.2/intel_opt-mpich2/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/petsc/3.2.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/petsc/3.2/intel_opt-mpich2/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.8-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.8-dbg",
            ["full_lower"] = "phdf5/1.8.8-dbg",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.8-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.8-dbg.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.8-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.8.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8",
            children = {
            },
            ["full"] = "phdf5/1.8.8",
            ["full_lower"] = "phdf5/1.8.8",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.8/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.8.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.8/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "mpich2/1.4.1-dbg",
        ["full_lower"] = "mpich2/1.4.1-dbg",
        lpathA = {
          ["/opt/apps/intel-12_1/mpich2/1.4.1-dbg/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/mpich2/1.4.1-dbg.lua",
        pathA = {
          ["/opt/apps/intel-12_1/mpich2/1.4.1-dbg/bin"] = 1,
        },
        whatis = {
          "Name: mpich2",
          "Version: 1.4.1-dbg",
          "Category: library, runtime support",
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/mpich2/1.4.1.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Mpich 2: Message Passing Interface Library version 2",
        ["Name"] = "mpich2",
        ["Version"] = "1.4.1",
        children = {
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/petsc/3.2-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2-dbg",
            children = {
            },
            ["full"] = "petsc/3.2-dbg",
            ["full_lower"] = "petsc/3.2-dbg",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/petsc/3.2/intel_opt-mpich2-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/petsc/3.2-dbg.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/petsc/3.2/intel_opt-mpich2-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2-dbg",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/petsc/3.2.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2",
            children = {
            },
            ["full"] = "petsc/3.2",
            ["full_lower"] = "petsc/3.2",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/petsc/3.2/intel_opt-mpich2/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/petsc/3.2.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/petsc/3.2/intel_opt-mpich2/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.8-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.8-dbg",
            ["full_lower"] = "phdf5/1.8.8-dbg",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.8-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.8-dbg.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.8-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.8.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8",
            children = {
            },
            ["full"] = "phdf5/1.8.8",
            ["full_lower"] = "phdf5/1.8.8",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.8/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.8.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.8/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/mpich2/1.4.1/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/intel-12_1/mpich2-1_4_1/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "mpich2/1.4.1",
        ["full_lower"] = "mpich2/1.4.1",
        lpathA = {
          ["/opt/apps/intel-12_1/mpich2/1.4.1/lib"] = 1,
        },
        ["name"] = "mpich2",
        ["name_lower"] = "mpich2",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/mpich2/1.4.1.lua",
        pathA = {
          ["/opt/apps/intel-12_1/mpich2/1.4.1/bin"] = 1,
        },
        whatis = {
          "Name: mpich2",
          "Version: 1.4.1",
          "Category: library, runtime support",
          "Description: Mpich 2: Message Passing Interface Library version 2",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/openmpi/1.5.4.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        ["Name"] = "openmpi",
        ["Version"] = "1.5.4",
        children = {
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/mpiP/3.3.lua"] = {
            ["Category"] = "MPI profiling library",
            ["Description"] = "Lightweight, Scalable MPI Profiling",
            ["Name"] = "mpiP",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.3",
            children = {
            },
            ["full"] = "mpiP/3.3",
            ["full_lower"] = "mpip/3.3",
            ["help"] = [[
The mpiP modulefile defines the following environment variables:
TACC_MPIP_DIR, TACC_MPIP_LIB for the location of the 
mpiP distribution and libraries respectively.


To use the mpiP library, relink your MPI code with the following option:

   -L$TACC_MPIP_LIB -lmpiP -lbfd -liberty

Version: 3.3

]],
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/mpiP/3.3/lib"] = 1,
            },
            ["name"] = "mpiP",
            ["name_lower"] = "mpip",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/mpiP/3.3.lua",
            whatis = {
              "Name: mpiP",
              "Version: 3.3",
              "Category: MPI profiling library",
              "Description: Lightweight, Scalable MPI Profiling",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/petsc/3.2-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2-dbg",
            children = {
            },
            ["full"] = "petsc/3.2-dbg",
            ["full_lower"] = "petsc/3.2-dbg",
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/petsc/3.2/intel_opt-openmpi-debug/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/petsc/3.2-dbg.lua",
            pathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/petsc/3.2/intel_opt-openmpi-debug/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2-dbg",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/petsc/3.2.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Numerical library for sparse linear algebra.",
            ["Name"] = "PETSc: Portable solver",
            ["URL"] = "http://www-unix.mcs.anl.gov/petsc/petsc-as",
            ["Version"] = "3.2",
            children = {
            },
            ["full"] = "petsc/3.2",
            ["full_lower"] = "petsc/3.2",
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/petsc/3.2/intel_opt-openmpi/lib"] = 1,
            },
            ["name"] = "petsc",
            ["name_lower"] = "petsc",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/petsc/3.2.lua",
            pathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/petsc/3.2/intel_opt-openmpi/bin"] = 1,
            },
            whatis = {
              "Name: PETSc: Portable solver",
              "Version: 3.2",
              "Category: library, mathematics",
              "Description: Numerical library for sparse linear algebra.",
              "URL: http://www-unix.mcs.anl.gov/petsc/petsc-as",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/phdf5/1.8.8-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.8-dbg",
            ["full_lower"] = "phdf5/1.8.8-dbg",
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/phdf5/1.8.8-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/phdf5/1.8.8-dbg.lua",
            pathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/phdf5/1.8.8-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/phdf5/1.8.8.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.8",
            children = {
            },
            ["full"] = "phdf5/1.8.8",
            ["full_lower"] = "phdf5/1.8.8",
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/phdf5/1.8.8/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/phdf5/1.8.8.lua",
            pathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/phdf5/1.8.8/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.8",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/phdf5/1.8.9-dbg.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9-dbg",
            children = {
            },
            ["full"] = "phdf5/1.8.9-dbg",
            ["full_lower"] = "phdf5/1.8.9-dbg",
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/phdf5/1.8.9-dbg/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/phdf5/1.8.9-dbg.lua",
            pathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/phdf5/1.8.9-dbg/bin"] = 1,
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9-dbg",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/phdf5/1.8.9.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "General purpose library and file format for storing scientific data (parallel I/O version)",
            ["Name"] = "Parallel HDF5",
            ["URL"] = "http://www.hdfgroup.org/HDF5",
            ["Version"] = "1.8.9",
            children = {
            },
            ["full"] = "phdf5/1.8.9",
            ["full_lower"] = "phdf5/1.8.9",
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/phdf5/1.8.9/lib"] = 1,
            },
            ["name"] = "phdf5",
            ["name_lower"] = "phdf5",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/phdf5/1.8.9.lua",
            pathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/phdf5/1.8.9/bin"] = 1,
            },
            propT = {
              arch = {
                ["mic"] = 1,
              },
            },
            whatis = {
              "Name: Parallel HDF5",
              "Version: 1.8.9",
              "Category: library, mathematics",
              "URL: http://www.hdfgroup.org/HDF5",
              "Description: General purpose library and file format for storing scientific data (parallel I/O version)",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/pmetis/3.1.1.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "3.1.1",
            children = {
            },
            ["full"] = "pmetis/3.1.1",
            ["full_lower"] = "pmetis/3.1.1",
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/pmetis/3.1.1/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/pmetis/3.1.1.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 3.1.1",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/pmetis/4.0.lua"] = {
            ["Category"] = "library, mathematics",
            ["Description"] = "Parallel graph partitioning and fill-reduction matrix ordering routines",
            ["Name"] = "ParMETIS: Parallel Graph Partitioning",
            ["URL"] = "http://glaros.dtc.umn.edu/gkhome/views/metis",
            ["Version"] = "4.0",
            children = {
            },
            ["full"] = "pmetis/4.0",
            ["full_lower"] = "pmetis/4.0",
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/pmetis/lib"] = 1,
            },
            ["name"] = "pmetis",
            ["name_lower"] = "pmetis",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/pmetis/4.0.lua",
            whatis = {
              "Name: ParMETIS: Parallel Graph Partitioning",
              "Version: 4.0",
              "Category: library, mathematics",
              "Description: Parallel graph partitioning and fill-reduction matrix ordering routines",
              "URL: http://glaros.dtc.umn.edu/gkhome/views/metis",
            },
          },
          ["/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/tau/2.20.3.lua"] = {
            ["Category"] = "library, profiling and optimization",
            ["Description"] = "Tool for profiling",
            ["Keyword"] = "rtm",
            ["Name"] = "TAU",
            ["URL"] = "http://www.cs.uoregon.edu/research/tau/home.php",
            ["Version"] = "2.20.3",
            children = {
            },
            ["full"] = "tau/2.20.3",
            ["full_lower"] = "tau/2.20.3",
            ["help"] = [[
The tau module defines the following standard environment variables:
TACC_TAU_DIR and TAU, TACC_TAU_BIN, TACC_TAU_LIB, and TACC_TAU_DOC 
for the location of the TAU distribution, binaries, libraries, and
documents, respectively.  It also defines defaults:
   TAU_TRACE=0,
   TAU_PROFILE=1,
   TAU_CALLPATH=0,
   TAU_MAKEFILE=Makefile.tau-icpc-papi-mpi-pdt,
   TAU_METRICS=LINUXTIMERS:PAPI_FP_OPS:PAPI_L2_DCM.
TAU_MAKEFILE sets the tools (pdt), compilers (intel) and parallel 
paradigm (serial, or mpi and/or openmp) to be used in the instrumentation.
See the pdf Quickstart and User Guide in the $TACC_TAU_DOC directory. 
Man pages are available for commands (e.g. paraprof, tauf90, etc.),
and the application program interface. 

Load command:

    module load tau

Specify the Tau makefile (for the Tau compiler wrappers to use) in the 
TAU_MAKEFILE environement variable to access specific Tau components:

    <path>/Makefile.<hyphen_separated_component_list>

Components:
    Intel Compilers (icpc)
    MPI (mpi)
    OMP (openmp-opari)
    PAPI (papi is now included by default)
    PDtoolkit(pdt)
    Phase (phase)
    Callpath (callpath)
    Trace (trace)
    serial execution (just use icpc/pgi and pdt)
(papi and pdt are common to all, and are not required to be used.)

To change to a different TAU Makefile, set the variable TAU_MAKEFILE to

    $TACC_TAU_LIB/<makefile>  (Makefile.tau-icpc-papi-mpi-pdt is the default)

where <makefile> is one of the Tau Makefile files in the 
$TACC_TAU_LIB directory.

To compile your code with TAU, use one of the TAU compiler wrappers:

   tau_f90.sh
   tau_cc.sh
   tau_cxx.sh

for constructing an instrumented code (instead of mpif90, mpicc, etc.).

E.g.  tau_f90.sh mpihello.f90, tau_cc.sh mpihello.c, etc.

These may also be used in make files, using macro definitions:

E.g.  F90=tau_f90.sh, CC=tau_cc.sh, Cxx=tau_cxx.sh.

To collect callpath information set TAU_CALLPATH to 1.
To collect traces set TAU_TRACE to 1.

Version 2.20.3
]],
            lpathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/tau/2.20.3/x86_64/lib"] = 1,
            },
            ["name"] = "tau",
            ["name_lower"] = "tau",
            ["path"] = "/opt/apps/modulefiles/MPI/intel/12.1/openmpi/1.5.4/tau/2.20.3.lua",
            pathA = {
              ["/opt/apps/intel-12_1/openmpi-1_5_4/tau/2.20.3/x86_64/bin"] = 1,
              ["/opt/apps/pdtoolkit/3.16/x86_64/bin"] = 1,
            },
            whatis = {
              "Name: TAU",
              "Description: Tool for profiling",
              "Version: 2.20.3",
              "Category: library, profiling and optimization",
              "Keyword: rtm",
              "URL: http://www.cs.uoregon.edu/research/tau/home.php",
            },
          },
        },
        ["full"] = "openmpi/1.5.4",
        ["full_lower"] = "openmpi/1.5.4",
        lpathA = {
          ["/opt/apps/intel-12_1/openmpi/1.5.4/lib"] = 1,
          ["/opt/apps/intel-12_1/openmpi/1.5.4/lib/openmpi"] = 1,
        },
        ["name"] = "openmpi",
        ["name_lower"] = "openmpi",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/openmpi/1.5.4.lua",
        pathA = {
          ["/opt/apps/intel-12_1/openmpi/1.5.4/bin"] = 1,
        },
        whatis = {
          "Name: openmpi",
          "Version: 1.5.4",
          "Category: library, runtime support",
          "Description: Openmpi Version of the Message Passing Interface Library",
        },
      },
      ["/opt/apps/modulefiles/Compiler/intel/12.1/openmpi/1.6.lua"] = {
        ["Category"] = "library, runtime support",
        ["Description"] = "Openmpi Version of the Message Passing Interface Library",
        ["Name"] = "openmpi",
        ["Version"] = "1.6",
        children = {
        },
        ["full"] = "openmpi/1.6",
        ["full_lower"] = "openmpi/1.6",
        lpathA = {
          ["/opt/apps/intel-12_1/openmpi/1.6/lib"] = 1,
          ["/opt/apps/intel-12_1/openmpi/1.6/lib/openmpi"] = 1,
        },
        ["name"] = "openmpi",
        ["name_lower"] = "openmpi",
        ["path"] = "/opt/apps/modulefiles/Compiler/intel/12.1/openmpi/1.6.lua",
        pathA = {
          ["/opt/apps/intel-12_1/openmpi/1.6/bin"] = 1,
        },
        whatis = {
          "Name: openmpi",
          "Version: 1.6",
          "Category: library, runtime support",
          "Description: Openmpi Version of the Message Passing Interface Library",
        },
      },
    },
    ["full"] = "intel/12.1",
    ["full_lower"] = "intel/12.1",
    ["help"] = [[
This module loads the intel compiler path and environment variables

To get started using Intel(R) VTune(TM) Amplifier XE 2011 Update 5:
      To start the graphical user interface: amplxe-gui
      To use the command-line interface: amplxe-cl
    - To view a table of getting started documents:
     /opt/apps/intel/12.1/vtune_amplifier_xe_2011/documentation/en/documentation_amplifier.htm.

To get started using Intel(R) Inspector XE 2011 Update 6:
      To start the graphical user interface: inspxe-gui
      To use the command-line interface: inspxe-cl
    - To view a table of getting started documents:
      /opt/apps/intel/12.1/inspector_xe_2011/documentation/en/documentation_inspector_xe.htm.

To get started using Intel(R) Composer XE 2011 Update 6 for Linux*:
      To invoke the installed compilers:
           For C++: icpc
           For C: icc
           For Fortran: ifort
      To get help, append the -help option or precede with the man command.
    - To view a table of getting started documents:
      /opt/apps/intel/12.1/composerxe-2011/Documentation/en_US/documentation_c.htm.
      
To view movies and additional training, visit
http://www.intel.com/software/products.


]],
    lpathA = {
      ["/opt/apps/intel/12.1/composer_xe_2011_sp1.7.256/compiler/lib/intel64"] = 1,
      ["/opt/apps/intel/12.1/composer_xe_2011_sp1.7.256/ipp/lib/intel64"] = 1,
      ["/opt/apps/intel/12.1/composer_xe_2011_sp1.7.256/mkl/lib/intel64"] = 1,
      ["/opt/apps/intel/12.1/composer_xe_2011_sp1.7.256/mpirt/lib/intel64"] = 1,
      ["/opt/apps/intel/12.1/composer_xe_2011_sp1.7.256/tbb/lib/intel64/cc4.1.0_libc2.4_kernel2.6.16.21"] = 1,
    },
    ["name"] = "intel",
    ["name_lower"] = "intel",
    ["path"] = "/opt/apps/modulefiles/Core/intel/12.1.lua",
    pathA = {
      ["/opt/apps/intel/12.1/bin"] = 1,
      ["/opt/apps/intel/12.1/inspector_xe_2011/bin64"] = 1,
      ["/opt/apps/intel/12.1/vtune_amplifier_xe_2011/bin64"] = 1,
    },
    whatis = {
      "Description: Intel Compiler Collection",
    },
  },
  ["/opt/apps/modulefiles/Core/lmod/lmod.lua"] = {
    ["Description"] = "Lmod: An Environment Module System",
    children = {
    },
    ["full"] = "lmod/lmod",
    ["full_lower"] = "lmod/lmod",
    ["name"] = "lmod",
    ["name_lower"] = "lmod",
    ["path"] = "/opt/apps/modulefiles/Core/lmod/lmod.lua",
    pathA = {
      ["/opt/apps/lmod/lmod/libexec"] = 1,
    },
    whatis = {
      "Description: Lmod: An Environment Module System",
    },
  },
  ["/opt/apps/modulefiles/Core/local/local.lua"] = {
    ["Description"] = "Local paths",
    children = {
    },
    ["full"] = "local/local",
    ["full_lower"] = "local/local",
    ["name"] = "local",
    ["name_lower"] = "local",
    ["path"] = "/opt/apps/modulefiles/Core/local/local.lua",
    pathA = {
      ["/opt/local/bin"] = 1,
      ["/usr/local/share/bin"] = 1,
    },
    whatis = {
      "Description: Local paths",
    },
  },
  ["/opt/apps/modulefiles/Core/luatools/1.1.lua"] = {
    children = {
    },
    ["full"] = "luatools/1.1",
    ["full_lower"] = "luatools/1.1",
    ["name"] = "luatools",
    ["name_lower"] = "luatools",
    ["path"] = "/opt/apps/modulefiles/Core/luatools/1.1.lua",
  },
  ["/opt/apps/modulefiles/Core/metalua/0.5.lua"] = {
    children = {
    },
    ["full"] = "metalua/0.5",
    ["full_lower"] = "metalua/0.5",
    ["name"] = "metalua",
    ["name_lower"] = "metalua",
    ["path"] = "/opt/apps/modulefiles/Core/metalua/0.5.lua",
    pathA = {
      ["/opt/apps/metalua/0.5/bin"] = 1,
    },
  },
  ["/opt/apps/modulefiles/Core/mkl/mkl.lua"] = {
    ["Description"] = "Intel Math Kernel Library",
    children = {
    },
    ["full"] = "mkl/mkl",
    ["full_lower"] = "mkl/mkl",
    ["help"] = [[
This module loads the intel mkl library and environment variables

]],
    lpathA = {
      ["/opt/apps/intel/intel/mkl/lib/intel64"] = 1,
    },
    ["name"] = "mkl",
    ["name_lower"] = "mkl",
    ["path"] = "/opt/apps/modulefiles/Core/mkl/mkl.lua",
    propT = {
      arch = {
        ["mic:offload"] = 1,
      },
    },
    whatis = {
      "Description: Intel Math Kernel Library",
    },
  },
  ["/opt/apps/modulefiles/Core/noweb/2.11b.lua"] = {
    ["Description"] = "Noweb 2.11b",
    children = {
    },
    ["full"] = "noweb/2.11b",
    ["full_lower"] = "noweb/2.11b",
    ["name"] = "noweb",
    ["name_lower"] = "noweb",
    ["path"] = "/opt/apps/modulefiles/Core/noweb/2.11b.lua",
    pathA = {
      ["/opt/apps/icon/icon/bin"] = 1,
      ["/opt/apps/noweb/2.11b/bin"] = 1,
    },
    whatis = {
      "Description: Noweb 2.11b",
    },
  },
  ["/opt/apps/modulefiles/Core/papi/4.1.4.lua"] = {
    ["Category"] = "library, performance measurement",
    ["Description"] = "Interface to monitor performance counter hardware for quantifying application behavior",
    ["URL"] = "http://icl.cs.utk.edu/papi/",
    ["Version"] = "4.1.4",
    children = {
    },
    ["full"] = "papi/4.1.4",
    ["full_lower"] = "papi/4.1.4",
    ["help"] = [[
The PAPI module file defines the following environment variables:
TACC_PAPI_DIR, TACC_PAPI_LIB, and TACC_PAPI_INC for
the location of the papi distribution, libraries, 
and include files, respectively.

To use the PAPI library, compile the source code with the option:

        -I$TACC_PAPI_INC 

and add the following options to the link step: 

        -Wl,-rpath,$TACC_PAPI_LIB -L$TACC_PAPI_LIB -lpapi

The -Wl,-rpath,$TACC_PAPI_LIB option is not required, however,
if it is used, then this module will not have to be loaded
to run the program during future login sessions.

   Version 4.1.4
]],
    lpathA = {
      ["/opt/apps/papi/4.1.4/lib"] = 1,
    },
    ["name"] = "papi",
    ["name_lower"] = "papi",
    ["path"] = "/opt/apps/modulefiles/Core/papi/4.1.4.lua",
    pathA = {
      ["/opt/apps/papi/4.1.4/bin"] = 1,
    },
    whatis = {
      "PAPI: Performance Application Programming Interface",
      "Version: 4.1.4",
      "Category: library, performance measurement",
      "Description: Interface to monitor performance counter hardware for quantifying application behavior",
      "URL: http://icl.cs.utk.edu/papi/",
    },
  },
  ["/opt/apps/modulefiles/Core/scite/2.27.lua"] = {
    ["Description"] = "SciTE: an editor",
    children = {
    },
    ["full"] = "scite/2.27",
    ["full_lower"] = "scite/2.27",
    ["name"] = "scite",
    ["name_lower"] = "scite",
    ["path"] = "/opt/apps/modulefiles/Core/scite/2.27.lua",
    pathA = {
      ["/opt/apps/scite/2.27/bin"] = 1,
    },
    whatis = {
      "Description: SciTE: an editor",
    },
  },
  ["/opt/apps/modulefiles/Core/scite/2.28.lua"] = {
    ["Description"] = "SciTE: an editor",
    children = {
    },
    ["full"] = "scite/2.28",
    ["full_lower"] = "scite/2.28",
    ["name"] = "scite",
    ["name_lower"] = "scite",
    ["path"] = "/opt/apps/modulefiles/Core/scite/2.28.lua",
    pathA = {
      ["/opt/apps/scite/2.28/bin"] = 1,
    },
    whatis = {
      "Description: SciTE: an editor",
    },
  },
  ["/opt/apps/modulefiles/Core/szip/2.1.lua"] = {
    ["Category"] = "System Environment/Base",
    ["Description"] = "Szip",
    ["Name"] = "szip",
    ["URL"] = "http://www.hdf5.org",
    ["Version"] = "2.1",
    children = {
    },
    ["full"] = "szip/2.1",
    ["full_lower"] = "szip/2.1",
    lpathA = {
      ["/opt/apps/szip/2.1/lib"] = 1,
    },
    ["name"] = "szip",
    ["name_lower"] = "szip",
    ["path"] = "/opt/apps/modulefiles/Core/szip/2.1.lua",
    whatis = {
      "Name: szip",
      "Version: 2.1",
      "Category: System Environment/Base",
      "URL: http://www.hdf5.org",
      "Description: Szip",
    },
  },
  ["/opt/apps/modulefiles/Core/tex/2010.lua"] = {
    children = {
    },
    ["full"] = "tex/2010",
    ["full_lower"] = "tex/2010",
    ["name"] = "tex",
    ["name_lower"] = "tex",
    ["path"] = "/opt/apps/modulefiles/Core/tex/2010.lua",
    pathA = {
      ["/opt/apps/texlive/2010/bin/x86_64-linux"] = 1,
    },
  },
  ["/opt/apps/modulefiles/Core/unix/unix.lua"] = {
    ["Description"] = "Standard Unix paths",
    children = {
    },
    ["full"] = "unix/unix",
    ["full_lower"] = "unix/unix",
    ["name"] = "unix",
    ["name_lower"] = "unix",
    ["path"] = "/opt/apps/modulefiles/Core/unix/unix.lua",
    whatis = {
      "Description: Standard Unix paths",
    },
  },
  ["/opt/apps/modulefiles/Core/valgrind/3.7.0.lua"] = {
    ["Category"] = "tools",
    ["Description"] = "memory usage tester",
    ["Name"] = "valgrind",
    ["URL"] = "http://www.valgrind.org",
    ["Version"] = "3.7.0",
    children = {
    },
    ["full"] = "valgrind/3.7.0",
    ["full_lower"] = "valgrind/3.7.0",
    lpathA = {
      ["/opt/apps/valgrind/3.7.0/lib"] = 1,
    },
    ["name"] = "valgrind",
    ["name_lower"] = "valgrind",
    ["path"] = "/opt/apps/modulefiles/Core/valgrind/3.7.0.lua",
    pathA = {
      ["/opt/apps/valgrind/3.7.0/bin"] = 1,
    },
    whatis = {
      "Name: valgrind",
      "Version: 3.7.0",
      "Category: tools",
      "URL: http://www.valgrind.org",
      "Description: memory usage tester",
    },
  },
  ["/opt/apps/modulefiles/Core/valkyrie/2.0.1.lua"] = {
    ["Category"] = "tools",
    ["Description"] = "GUI frontend for valgrind",
    ["Name"] = "valkyrie",
    ["URL"] = "http://www.valgrind.org/downloads/guis.html/",
    ["Version"] = "2.0.1",
    children = {
    },
    ["full"] = "valkyrie/2.0.1",
    ["full_lower"] = "valkyrie/2.0.1",
    ["name"] = "valkyrie",
    ["name_lower"] = "valkyrie",
    ["path"] = "/opt/apps/modulefiles/Core/valkyrie/2.0.1.lua",
    pathA = {
      ["/opt/apps/valkyrie/2.0.1/bin"] = 1,
    },
    whatis = {
      "Name: valkyrie",
      "Version: 2.0.1",
      "Category: tools",
      "URL: http://www.valgrind.org/downloads/guis.html/",
      "Description: GUI frontend for valgrind",
    },
  },
  ["/opt/apps/modulefiles/Core/visit/visit.lua"] = {
    ["Description"] = "Visit: A visualization tool",
    children = {
    },
    ["full"] = "visit/visit",
    ["full_lower"] = "visit/visit",
    ["name"] = "visit",
    ["name_lower"] = "visit",
    ["path"] = "/opt/apps/modulefiles/Core/visit/visit.lua",
    pathA = {
      ["/vol/pkg/Visit/visit/bin"] = 1,
    },
    whatis = {
      "Description: Visit: A visualization tool",
    },
  },
  ["/opt/apps/modulefiles/Core/xine/xine.lua"] = {
    children = {
    },
    ["full"] = "xine/xine",
    ["full_lower"] = "xine/xine",
    lpathA = {
      ["/opt/apps/xine/xine/lib"] = 1,
    },
    ["name"] = "xine",
    ["name_lower"] = "xine",
    ["path"] = "/opt/apps/modulefiles/Core/xine/xine.lua",
    pathA = {
      ["/opt/apps/xine/xine/bin"] = 1,
    },
  },
}

