-- -*- lua -*-
-- $Id: .settarg.lua 194 2008-06-25 21:43:50Z mclay $
MethodTbl = { 
   i686                              = "dbg",
   i386                              = "dbg",
   x86_64                            = "dbg",
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
   mvapich                = 'M1',
   mvapich2               = 'M2',
   openmpi                = "O",
   mpich                  = "M",
   mpich2                 = "M",
   intel                  = "icc",
   tau                    = 'Tau',
}

ModuleTbl = {
   method             = {"mdbg", "dbg", "chk", "opt", "gopt",},
   mpi                = {"mpich", "mpich2", "openmpi", "mvapich2", "impi"},
   compiler           = {"intel", "pgi", "gcc", "sun",},
   blas               = {"gotoblas", "mkl",},
   solver             = {"petsc","trilinos"},
   pointer_validation = { "mudflap", "mudflapth","dmalloc"},
   valgrind           = { "memgrind","cachegrind"},
   profiling          = { "mpiP", "tau"},
   file_io            = { "hdf5", "phdf5" },
}

TargetList = { "mach", "method",  "compiler", "mpi", "profiling"} 

NoFamilyList = {"mach", "method",}
