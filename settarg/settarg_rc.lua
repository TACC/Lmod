-- -*- lua -*-

BuildScenarioTbl = {
   default                = "empty",
}

HostnameTbl = { 2 }  -- extracts the 2nd part of `hostname -f` output, towards variable $TARG_HOST

TitleTbl = {
   mic                    = "MIC",
   dbg                    = "D",
   mdbg                   = "M",
   opt                    = "O",
   gopt                   = "G",
   impi                   = "IM",
   mvapich2               = "M",
   openmpi                = "O",
   mpich                  = "M",
   mpich2                 = "M2",
   intel                  = "I",
   gcc                    = "G",
   clang                  = "C",
   tau                    = "Tau",
   pgi                    = "P",
   MVAPICH2               = 'M',
   OpenMPI                = "O",
   MPICH                  = "M",
   MPICH2                 = "M2",
   INTEL                  = "I",
   GCC                    = "G",
   Clang                  = "C",
   TAU                    = 'Tau',
   PGI                    = "P",
}

ModuleTbl = {
   build_scenario     = { "mdbg", "dbg", "opt", "gopt", "empty"},
   mpi                = { "mpich", "mpich2", "openmpi", "mvapich2", "impi", "MPICH", "MPICH2", "MVAPICH2", 
                          "OpenMPI", "QLogicMPI", "psmpi", "psmpi2"},
   compiler           = { "intel", "pgi", "gcc", "sun", "clang", "Clang", "GCC", "LLVM", "PGI", "PCC", "TCC", "SDCC", "ispc", "Go"},
   blas               = { "gotoblas", "mkl", "imkl", "OpenBLAS", "GotoBLAS", "GotoBLAS2", "ATLAS"},
   toolchain          = { "ClangGCC", "CrayCCE", "CrayGNU", "CrayIntel", "CrayPGI", "GCCcore", 
                          "GNU", "PGI", "cgmpich", "cgmpolf", "cgmvapich2", "cgmvolf", "cgompi", "cgoolf", 
                          "dummy", "foss", "gcccuda", "gimkl", "gimpi", "gmacml", "gmpich", "gmpich2", 
                          "gmpolf", "gmvapich2", "gmvolf", "goalf", "gompi", "gompic", "goolf", "goolfc", 
                          "gpsmpi", "gpsolf", "gqacml", "iccifort", "iccifortcuda", "ictce", 
                          "iimkl", "iimpi", "iimpic", "iiqmpi", "impich", "impmkl", "intel", 
                          "intel-para", "intelcuda", "iomkl", "iompi", "ipsmpi", "iqacml", "ismkl", 
                          "pomkl", "pompi", "xlcxlf", "xlmpich", "xlmpich2", "xlmvapich2", "xlompi"},   
   solver             = { "petsc", "trilinos", "PETSc", "Trilinos"},
   acceleratings_libs = { "CUDA", "cuDNN"},
   pointer_validation = { "mudflap", "mudflapth", "dmalloc"},
   valgrind           = { "memgrind", "cachegrind"},
   profiling          = { "mpiP", "tau", "TAU"},
   file_io            = { "hdf5", "phdf5", "HDF5"},
}

TargetList = { "mach", "build_scenario", "compiler", "mpi"}

SettargDirTemplate = { "$SETTARG_TAG1", "/", "$SETTARG_TAG2", "$TARG_SUMMARY" }

NoFamilyList = {"mach", "build_scenario",}

TargPathLoc = "first"
