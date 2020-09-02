-- -*- lua -*-
help(
[[
This module loads the intel mkl library and environment variables
]])      
------------------------------------------------------------------------
-- Intel MKL support
------------------------------------------------------------------------

local base    = "/opt/apps/intel/intel"
local mkl     = pathJoin(base,"mkl")
local tbl     = { i686 = "ia32", x86_64 = "intel64" }
local arch    = tbl[os.getenv("LMOD_arch")] or "x86_64"
local mkl_lib = pathJoin(mkl,"lib",arch)
local mkl_inc = pathJoin(mkl,"include")

whatis("Description: Intel Math Kernel Library")
prepend_path('MANPATH',          pathJoin(mkl,"man"))
setenv(      'MKL_DIR',	         mkl)
setenv(      'MKL_LIB',	         mkl_lib)
setenv(      'MKL_INCLUDE',      mkl_inc)
setenv(      'TACC_MKL_DIR',     mkl)
setenv(      'TACC_MKL_LIB',     mkl_lib)
setenv(      'TACC_MKL_INCLUDE', mkl_inc)

add_property("arch","mic:offload")
