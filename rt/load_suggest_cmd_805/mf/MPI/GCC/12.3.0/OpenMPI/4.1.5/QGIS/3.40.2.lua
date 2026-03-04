help([==[

Description
===========
QGIS is a user friendly Open Source Geographic Information System (GIS).


More information
================
 - Homepage: http://www.qgis.org/
]==])

whatis([==[Description: QGIS is a user friendly Open Source Geographic Information System (GIS).]==])
whatis([==[Homepage: http://www.qgis.org/]==])
whatis([==[URL: http://www.qgis.org/]==])

local root = "/hpc2n/eb/software/QGIS/3.40.2-foss-2023a"

conflict("QGIS")

-- depends_on("FlexiBLAS/3.3.1")

-- depends_on("FFTW/3.3.10")

-- depends_on("FFTW.MPI/3.3.10")

-- depends_on("ScaLAPACK/2.2.0-fb")

depends_on("Python/3.11.3")

-- depends_on("Qt5/5.15.10")

-- depends_on("Qt5Webkit/5.212.0-alpha4")

-- depends_on("PyQt5/5.15.10")

-- depends_on("PROJ/9.2.0")

-- depends_on("GEOS/3.12.0")

-- depends_on("PDAL/2.8.2")

-- depends_on("zstd/1.5.5")

-- depends_on("SQLite/3.42.0")

-- depends_on("libspatialite/5.1.0")

-- depends_on("libspatialindex/1.9.3")

-- depends_on("PyYAML/6.0")

-- depends_on("Cartopy/0.22.0")

-- depends_on("psycopg2/2.9.9")

-- depends_on("GDAL/3.7.1")

-- depends_on("Qwt/6.3.0")

-- depends_on("expat/2.5.0")

-- depends_on("QCA/2.3.9")

-- depends_on("QScintilla/2.14.1")

-- depends_on("GSL/2.7")

-- depends_on("libzip/1.10.1")

-- depends_on("QtKeychain/0.14.3")

-- depends_on("ICU/73.2")

-- depends_on("PostgreSQL/16.1")

-- depends_on("GRASS/8.4.0")

-- depends_on("protobuf-python/4.24.0")

-- depends_on("exiv2/0.28.0")

-- depends_on("draco/1.5.7")

-- depends_on("HDF5/1.14.0")

-- depends_on("netCDF/4.9.2")

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("MANPATH", pathJoin(root, "man"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("XDG_DATA_DIRS", pathJoin(root, "share"))
setenv("EBROOTQGIS", root)
setenv("EBVERSIONQGIS", "3.40.2")
setenv("EBDEVELQGIS", pathJoin(root, "easybuild", "MPI-GCC-12.3.0-OpenMPI-4.1.5-QGIS-3.40.2-easybuild-devel"))

-- Built with EasyBuild version 5.1.3.dev0-rbfe3cc340e4731805c3b3d46cb9dc6c90bd891dc
