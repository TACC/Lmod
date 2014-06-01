help(
[[
This module loads the FFTW library.
]])

family("fftw")
add_property("type_","math")

local version = "3.3.3"
local base = pathJoin("/software6/libs/fftw/",version .. "_intel")

whatis("(Website________) http://www.fftw.org/")

prepend_path("PATH", pathJoin(base, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("CPATH", pathJoin(base, "include"))
prepend_path("FPATH", pathJoin(base, "include"))
prepend_path("INFOPATH", pathJoin(base,"share/info"))
prepend_path("MANPATH", pathJoin(base, "share/man"))
prepend_path("PKG_CONFIG_PATH", pathJoin(base,"lib/pkgconfig"))

