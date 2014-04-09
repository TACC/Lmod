-- -*- lua -*-

BuildScenarioTbl = {
   default                = "empty",
}

HostnameTbl = { 2 }

TitleTbl = {
   mic                    = "MIC",
   dbg                    = 'D',
   mdbg                   = 'M',
   opt                    = 'O',
   gopt                   = 'G',
   impi                   = "IM",
   mvapich2               = 'M',
   openmpi                = "O",
   mpich                  = "M",
   mpich2                 = "M2",
   intel                  = "I",
   gcc                    = "G",
   clang                  = "C",
   tau                    = 'Tau',
}

ModuleTbl = {
   build_scenario     = { "mdbg", "dbg", "opt", "gopt", "empty"},
   mpi                = { "mpich", "mpich2", "openmpi", "mvapich2", "impi"},
   compiler           = { "intel", "pgi", "gcc", "sun",'clang'},
   blas               = { "gotoblas", "mkl",},
   solver             = { "petsc","trilinos"},
   pointer_validation = { "mudflap", "mudflapth","dmalloc"},
   valgrind           = { "memgrind","cachegrind"},
   profiling          = { "mpiP", "tau"},
   file_io            = { "hdf5", "phdf5" },
}

TargetList = { "mach", "build_scenario", "compiler", "mpi"}

SettargDirTemplate = { "$SETTARG_TAG1", "/", "$SETTARG_TAG2", "$TARG_SUMMARY" }

NoFamilyList = {"mach", "build_scenario",}

TargPathLoc = "first"
