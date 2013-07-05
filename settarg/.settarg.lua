-- -*- lua -*-

BuildScenarioTbl = { 
   default                = "empty",
}

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
   mpich2                 = "M",
   intel                  = "I",
   gcc                    = "G",
   tau                    = 'Tau',
}

ModuleTbl = {
   build_scenario     = { "mdbg", "dbg", "opt", "gopt", "empty"},
   mpi                = { "mpich", "mpich2", "openmpi", "mvapich2", "impi"},
   compiler           = { "intel", "pgi", "gcc", "sun",},
   blas               = { "gotoblas", "mkl",},
   solver             = { "petsc","trilinos"},
   pointer_validation = { "mudflap", "mudflapth","dmalloc"},
   valgrind           = { "memgrind","cachegrind"},
   profiling          = { "mpiP", "tau"},
   file_io            = { "hdf5", "phdf5" },
}

TargetList = { "mach", "build_scenario", "compiler", "mpi"} 

NoFamilyList = {"mach", "build_scenario",}
