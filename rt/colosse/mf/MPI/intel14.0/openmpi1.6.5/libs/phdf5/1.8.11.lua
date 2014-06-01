help(
[[
This module loads the parallel version of the HDF5 library.
]])

family("hdf5")
local version = "1.8.11"
local base = pathJoin("/software6/libs/phdf5/","1.8.11_intel")

whatis("(Website________) http://www.hdfgroup.org/HDF5/")

prepend_path("PATH", pathJoin(base, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("CPATH", pathJoin(base, "include"))
prepend_path("FPATH", pathJoin(base, "include"))

