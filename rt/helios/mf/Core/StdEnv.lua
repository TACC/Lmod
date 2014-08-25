add_property(   "lmod", "sticky")

require("os")
if (os.getenv("LMOD_SYSTEM_NAME") == "gpu") then
  load("apps/buildtools")
  load("compilers/gcc/4.8")
  load("cuda/6.0.37")
  load("mpi/openmpi/1.8.1")
else
  load("apps/moab")
  load("apps/buildtools")
  load("compilers/intel")
  load("mpi/openmpi/1.6.5")
end

