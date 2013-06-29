-- -*- lua -*-
-- $Id: .settarg.lua 194 2008-06-25 21:43:50Z mclay $
MethodTbl = { 
   default                           = "empty",
   i686                              = "dbg",
   i386                              = "dbg",
   x86_64                            = "empty",
   ['stampede.tacc.utexas.edu']      = "opt",
   ['ls4.tacc.utexas.edu']           = "opt",
   longhorn                          = "opt",
   sapphire                          = "opt",
}

TitleTbl = {
   mic                    = "MIC",
   dbg                    = 'D',
   mdbg                   = 'M',
   opt                    = 'O',
   gopt                   = 'G',
   chk                    = 'C',
   impi                   = "IM",
   mvapich2               = 'M',
   openmpi                = "O",
   mpich                  = "M",
   mpich2                 = "M",
   intel                  = "icc",
   tau                    = 'Tau',
}

ModuleTbl = {
   build_scenario     = {"mdbg", "dbg", "chk", "opt", "gopt", "empty"},
   mpi                = {"mpich", "mpich2", "openmpi", "mvapich2", "impi"},
   compiler           = {"intel", "pgi", "gcc", "sun",},
   blas               = {"gotoblas", "mkl",},
   solver             = {"petsc","trilinos"},
   pointer_validation = { "mudflap", "mudflapth","dmalloc"},
   valgrind           = { "memgrind","cachegrind"},
   profiling          = { "mpiP", "tau"},
   file_io            = { "hdf5", "phdf5" },
}

TargetList = { "mach", "build_scenario", "compiler", "mpi"} 

NoFamilyList = {"mach", "build_scenario",}
