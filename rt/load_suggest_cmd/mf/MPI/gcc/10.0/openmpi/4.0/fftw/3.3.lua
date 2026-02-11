-- FFTW module ALSO available when gcc/10.0 AND openmpi/4.0 are loaded
-- This creates a module available at BOTH Compiler AND MPI levels
-- (different builds for MPI vs non-MPI)
setenv("FFTW_VERSION", myModuleVersion())
setenv("FFTW_DIR", "/software/fftw/3.3-mpi")
setenv("FFTW_MPI", "yes")
