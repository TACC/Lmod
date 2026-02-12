-- OpenMPI module available when gcc/10.0 is loaded
-- This unlocks the MPI level of the hierarchy
local name        = myModuleName()
local version     = myModuleVersion()
local mroot       = os.getenv("MODULEPATH_ROOT")
local compiler    = "gcc/10.0"

prepend_path("MODULEPATH", pathJoin(mroot, "MPI", "gcc", "10.0", name, version))

setenv("OPENMPI_VERSION", version)
