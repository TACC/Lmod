help(
[[
This module loads the NetCDF4 library with parallel support
]])

family("netcdf")
local version = "4.3.0"
local base = pathJoin("/software6/libs/netcdf/",version .. "_intel")
always_load("libs/phdf5")

whatis("(Website________) http://www.unidata.ucar.edu/software/netcdf/")

prepend_path("PATH", pathJoin(base, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("CPATH", pathJoin(base, "include"))
prepend_path("MANPATH", pathJoin(base, "share", "man"))

