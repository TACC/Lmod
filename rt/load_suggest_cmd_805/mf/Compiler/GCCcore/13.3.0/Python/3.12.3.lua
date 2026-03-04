help([==[

Description
===========
Python is a programming language that lets you work more quickly and integrate your systems
 more effectively.


More information
================
 - Homepage: https://python.org/


Included extensions
===================
flit_core-3.9.0, packaging-24.0, pip-24.0, setuptools-70.0.0,
setuptools_scm-8.1.0, tomli-2.0.1, typing_extensions-4.11.0, wheel-0.43.0
]==])

whatis([==[Description: Python is a programming language that lets you work more quickly and integrate your systems
 more effectively.]==])
whatis([==[Homepage: https://python.org/]==])
whatis([==[URL: https://python.org/]==])
whatis([==[Extensions: flit_core-3.9.0, packaging-24.0, pip-24.0, setuptools-70.0.0, setuptools_scm-8.1.0, tomli-2.0.1, typing_extensions-4.11.0, wheel-0.43.0]==])

local root = "/hpc2n/eb/software/Python/3.12.3-GCCcore-13.3.0"

conflict("Python")

if convertToCanonical(LmodVersion()) >= convertToCanonical("8.2.8") then
    extensions("flit_core/3.9.0,packaging/24.0,pip/24.0,setuptools/70.0.0,setuptools_scm/8.1.0,tomli/2.0.1,typing_extensions/4.11.0,wheel/0.43.0")
end


-- depends_on("binutils/2.42")

-- depends_on("bzip2/1.0.8")

-- depends_on("zlib/1.3.1")

-- depends_on("libreadline/8.2")

-- depends_on("ncurses/6.5")

-- depends_on("SQLite/3.45.3")

-- depends_on("XZ/5.4.5")

-- depends_on("libffi/3.4.5")

-- depends_on("OpenSSL/3")

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("MANPATH", pathJoin(root, "share/man"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "lib/pkgconfig"))
prepend_path("XDG_DATA_DIRS", pathJoin(root, "share"))
setenv("EBROOTPYTHON", root)
setenv("EBVERSIONPYTHON", "3.12.3")
setenv("EBDEVELPYTHON", pathJoin(root, "easybuild/Compiler-GCCcore-13.3.0-Python-3.12.3-easybuild-devel"))

prepend_path("PYTHONPATH", pathJoin(root, "easybuild/python"))
-- Built with EasyBuild version 4.9.5.dev0-ra0f8b99483eda8236ddce0de31b6dca8a26a8c76
setenv("EBEXTSLISTPYTHON", "flit_core-3.9.0,wheel-0.43.0,tomli-2.0.1,packaging-24.0,typing_extensions-4.11.0,setuptools-70.0.0,setuptools_scm-8.1.0,pip-24.0")
