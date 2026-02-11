-- FFTW module available when gcc/10.0 is loaded (1-level deep)
-- This creates a module available at Compiler level only
setenv("FFTW_VERSION", myModuleVersion())
setenv("FFTW_DIR", "/software/fftw/3.3")
