-- PETSc module available when gcc/10.0 AND openmpi/4.0 are loaded
-- This tests a 2-level deep dependency
setenv("PETSC_VERSION", myModuleVersion())
setenv("PETSC_DIR", "/software/petsc/3.17")
