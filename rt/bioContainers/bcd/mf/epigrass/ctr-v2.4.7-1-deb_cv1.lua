local help_message = [[
This is a module file for the container biocontainers/epigrass:v2.4.7-1-deb_cv1, which exposes the
following programs:

 - acyclic
 - assistant
 - bcomps
 - ccomps
 - chardet
 - circo
 - cluster
 - cpp-6
 - createfontdatachunk.py
 - cs2cs
 - delaunay
 - designer
 - dh_numpy
 - dh_pypy
 - dh_python3
 - diffimg
 - dijkstra
 - dot
 - dot2gxl
 - dot_builtins
 - dotty
 - edgepaint
 - enhancer.py
 - epgeditor
 - epigrass
 - epirunner
 - epsg_tr.py
 - esri2wkt.py
 - explode.py
 - f2py2.7
 - fdp
 - g++-6
 - gc
 - gcc-6
 - gcc-ar-6
 - gcc-nm-6
 - gcc-ranlib-6
 - gcov-6
 - gcov-dump
 - gcov-dump-6
 - gcov-tool-6
 - gcps2vec.py
 - gcps2wld.py
 - gdal2tiles.py
 - gdal2xyz.py
 - gdal_auth.py
 - gdal_calc.py
 - gdal_edit.py
 - gdal_fillnodata.py
 - gdal_merge.py
 - gdal_pansharpen.py
 - gdal_polygonize.py
 - gdal_proximity.py
 - gdal_retile.py
 - gdal_sieve.py
 - gdalchksum.py
 - gdalcompare.py
 - gdalident.py
 - gdalimport.py
 - gdalmove.py
 - geod
 - gifmaker.py
 - gml2gv
 - graphml2gv
 - gts-config
 - gts2dxf
 - gts2oogl
 - gts2stl
 - gts2xyz
 - gtscheck
 - gtscompare
 - gtstemplate
 - gv2gml
 - gv2gxl
 - gvcolor
 - gvgen
 - gvmap
 - gvmap.sh
 - gvpack
 - gvpr
 - gxl2dot
 - gxl2gv
 - invgeod
 - invproj
 - lconvert
 - lefty
 - libgvc6-config-update
 - linguist
 - lneato
 - lrelease
 - lupdate
 - mingle
 - mkgraticule.py
 - mm2gv
 - moc
 - nad2bin
 - neato
 - neteditor
 - nop
 - odbcinst
 - osage
 - painter.py
 - patchwork
 - pct2rgb.py
 - pdb3
 - pdb3.5
 - pilconvert.py
 - pildriver.py
 - pilfile.py
 - pilfont.py
 - pilprint.py
 - pixeltool
 - player.py
 - proj
 - prune
 - py3clean
 - py3compile
 - py3versions
 - pybuild
 - pygettext3
 - pygettext3.5
 - python3m
 - qcollectiongenerator
 - qdbus
 - qdbuscpp2xml
 - qdbusviewer
 - qdbusxml2cpp
 - qdoc
 - qdoc3
 - qhelpconverter
 - qhelpgenerator
 - qlalr
 - qmake
 - qml
 - qml1plugindump
 - qmlbundle
 - qmleasing
 - qmlimportscanner
 - qmllint
 - qmlmin
 - qmlplugindump
 - qmlprofiler
 - qmlscene
 - qmltestrunner
 - qmlviewer
 - qtchooser
 - qtconfig
 - qtdiag
 - qtpaths
 - qtplugininfo
 - rcc
 - redis-benchmark
 - redis-check-aof
 - redis-check-rdb
 - redis-cli
 - redis-server
 - rgb2pct.py
 - sccmap
 - sfdp
 - sqlobject-admin
 - sqlobject-convertOldURI
 - stl2gts
 - thresholder.py
 - transform
 - tred
 - twopi
 - uic
 - uic3
 - unflatten
 - viewer.py
 - vimdot
 - x86_64-linux-gnu-cpp-6
 - x86_64-linux-gnu-g++-6
 - x86_64-linux-gnu-gcc-6
 - x86_64-linux-gnu-gcc-ar-6
 - x86_64-linux-gnu-gcc-nm-6
 - x86_64-linux-gnu-gcc-ranlib-6
 - x86_64-linux-gnu-gcov-6
 - x86_64-linux-gnu-gcov-dump
 - x86_64-linux-gnu-gcov-dump-6
 - x86_64-linux-gnu-gcov-tool-6
 - xmlpatterns
 - xmlpatternsvalidator

This container was pulled from:

	https://hub.docker.com/r/biocontainers/epigrass

If you encounter errors in epigrass or need help running the
tools it contains, please contact the developer at

	http://epigrass.sourceforge.net/

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: epigrass")
whatis("Version: ctr-v2.4.7-1-deb_cv1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The geographical networks over which epidemiological processes take place can be very straightforwardly represented in a object-oriented framework. In such a framework, the nodes and edges of the geographical networks are objects with their own attributes and methods.

Once the archetypal node and edge objects are defined with appropriate attributes and methods, then a code representation of the real system can be constructed, where cities (or other geographical localities) and transportation routes are instances of the node and edge objects, respectively. The whole network is also an object with a whole collection of attributes and methods.

This framework leads to a compact and hierarchical computational model consisting of a network object containing a variable number of node and edge objects. This framework also do not pose limitations to encapsulation, potentially allowing for networks within networks if desirable (not yet implemented).

For the end user this framework is transparent since it mimics the natural structure of the real system. Even after the model is converted into a code object, all of its component objects remain accessible internally, facilitating the exchange of information between all levels of the model. 

The latest development code for the 2.x branch of Epigrass is now being hosted in Mercurial at the following website:
http://hg.metamodellers.com/epigrassqt4/
")
whatis("URL: https://hub.docker.com/r/biocontainers/epigrass")

set_shell_function("acyclic",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg acyclic $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg acyclic $*')
set_shell_function("assistant",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg assistant $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg assistant $*')
set_shell_function("bcomps",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg bcomps $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg bcomps $*')
set_shell_function("ccomps",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg ccomps $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg ccomps $*')
set_shell_function("chardet",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg chardet $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg chardet $*')
set_shell_function("circo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg circo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg circo $*')
set_shell_function("cluster",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg cluster $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg cluster $*')
set_shell_function("cpp-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg cpp-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg cpp-6 $*')
set_shell_function("createfontdatachunk.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg createfontdatachunk.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg createfontdatachunk.py $*')
set_shell_function("cs2cs",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg cs2cs $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg cs2cs $*')
set_shell_function("delaunay",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg delaunay $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg delaunay $*')
set_shell_function("designer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg designer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg designer $*')
set_shell_function("dh_numpy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dh_numpy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dh_numpy $*')
set_shell_function("dh_pypy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dh_pypy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dh_pypy $*')
set_shell_function("dh_python3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dh_python3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dh_python3 $*')
set_shell_function("diffimg",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg diffimg $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg diffimg $*')
set_shell_function("dijkstra",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dijkstra $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dijkstra $*')
set_shell_function("dot",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dot $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dot $*')
set_shell_function("dot2gxl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dot2gxl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dot2gxl $*')
set_shell_function("dot_builtins",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dot_builtins $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dot_builtins $*')
set_shell_function("dotty",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dotty $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg dotty $*')
set_shell_function("edgepaint",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg edgepaint $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg edgepaint $*')
set_shell_function("enhancer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg enhancer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg enhancer.py $*')
set_shell_function("epgeditor",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg epgeditor $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg epgeditor $*')
set_shell_function("epigrass",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg epigrass $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg epigrass $*')
set_shell_function("epirunner",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg epirunner $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg epirunner $*')
set_shell_function("epsg_tr.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg epsg_tr.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg epsg_tr.py $*')
set_shell_function("esri2wkt.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg esri2wkt.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg esri2wkt.py $*')
set_shell_function("explode.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg explode.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg explode.py $*')
set_shell_function("f2py2.7",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg f2py2.7 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg f2py2.7 $*')
set_shell_function("fdp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg fdp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg fdp $*')
set_shell_function("g++-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg g++-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg g++-6 $*')
set_shell_function("gc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gc $*')
set_shell_function("gcc-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcc-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcc-6 $*')
set_shell_function("gcc-ar-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcc-ar-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcc-ar-6 $*')
set_shell_function("gcc-nm-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcc-nm-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcc-nm-6 $*')
set_shell_function("gcc-ranlib-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcc-ranlib-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcc-ranlib-6 $*')
set_shell_function("gcov-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcov-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcov-6 $*')
set_shell_function("gcov-dump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcov-dump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcov-dump $*')
set_shell_function("gcov-dump-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcov-dump-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcov-dump-6 $*')
set_shell_function("gcov-tool-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcov-tool-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcov-tool-6 $*')
set_shell_function("gcps2vec.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcps2vec.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcps2vec.py $*')
set_shell_function("gcps2wld.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcps2wld.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gcps2wld.py $*')
set_shell_function("gdal2tiles.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal2tiles.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal2tiles.py $*')
set_shell_function("gdal2xyz.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal2xyz.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal2xyz.py $*')
set_shell_function("gdal_auth.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_auth.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_auth.py $*')
set_shell_function("gdal_calc.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_calc.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_calc.py $*')
set_shell_function("gdal_edit.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_edit.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_edit.py $*')
set_shell_function("gdal_fillnodata.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_fillnodata.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_fillnodata.py $*')
set_shell_function("gdal_merge.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_merge.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_merge.py $*')
set_shell_function("gdal_pansharpen.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_pansharpen.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_pansharpen.py $*')
set_shell_function("gdal_polygonize.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_polygonize.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_polygonize.py $*')
set_shell_function("gdal_proximity.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_proximity.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_proximity.py $*')
set_shell_function("gdal_retile.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_retile.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_retile.py $*')
set_shell_function("gdal_sieve.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_sieve.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdal_sieve.py $*')
set_shell_function("gdalchksum.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalchksum.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalchksum.py $*')
set_shell_function("gdalcompare.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalcompare.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalcompare.py $*')
set_shell_function("gdalident.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalident.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalident.py $*')
set_shell_function("gdalimport.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalimport.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalimport.py $*')
set_shell_function("gdalmove.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalmove.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gdalmove.py $*')
set_shell_function("geod",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg geod $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg geod $*')
set_shell_function("gifmaker.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gifmaker.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gifmaker.py $*')
set_shell_function("gml2gv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gml2gv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gml2gv $*')
set_shell_function("graphml2gv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg graphml2gv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg graphml2gv $*')
set_shell_function("gts-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts-config $*')
set_shell_function("gts2dxf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts2dxf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts2dxf $*')
set_shell_function("gts2oogl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts2oogl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts2oogl $*')
set_shell_function("gts2stl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts2stl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts2stl $*')
set_shell_function("gts2xyz",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts2xyz $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gts2xyz $*')
set_shell_function("gtscheck",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gtscheck $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gtscheck $*')
set_shell_function("gtscompare",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gtscompare $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gtscompare $*')
set_shell_function("gtstemplate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gtstemplate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gtstemplate $*')
set_shell_function("gv2gml",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gv2gml $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gv2gml $*')
set_shell_function("gv2gxl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gv2gxl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gv2gxl $*')
set_shell_function("gvcolor",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvcolor $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvcolor $*')
set_shell_function("gvgen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvgen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvgen $*')
set_shell_function("gvmap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvmap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvmap $*')
set_shell_function("gvmap.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvmap.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvmap.sh $*')
set_shell_function("gvpack",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvpack $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvpack $*')
set_shell_function("gvpr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvpr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gvpr $*')
set_shell_function("gxl2dot",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gxl2dot $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gxl2dot $*')
set_shell_function("gxl2gv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gxl2gv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg gxl2gv $*')
set_shell_function("invgeod",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg invgeod $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg invgeod $*')
set_shell_function("invproj",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg invproj $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg invproj $*')
set_shell_function("lconvert",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lconvert $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lconvert $*')
set_shell_function("lefty",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lefty $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lefty $*')
set_shell_function("libgvc6-config-update",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg libgvc6-config-update $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg libgvc6-config-update $*')
set_shell_function("linguist",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg linguist $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg linguist $*')
set_shell_function("lneato",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lneato $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lneato $*')
set_shell_function("lrelease",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lrelease $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lrelease $*')
set_shell_function("lupdate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lupdate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg lupdate $*')
set_shell_function("mingle",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg mingle $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg mingle $*')
set_shell_function("mkgraticule.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg mkgraticule.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg mkgraticule.py $*')
set_shell_function("mm2gv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg mm2gv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg mm2gv $*')
set_shell_function("moc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg moc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg moc $*')
set_shell_function("nad2bin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg nad2bin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg nad2bin $*')
set_shell_function("neato",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg neato $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg neato $*')
set_shell_function("neteditor",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg neteditor $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg neteditor $*')
set_shell_function("nop",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg nop $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg nop $*')
set_shell_function("odbcinst",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg odbcinst $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg odbcinst $*')
set_shell_function("osage",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg osage $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg osage $*')
set_shell_function("painter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg painter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg painter.py $*')
set_shell_function("patchwork",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg patchwork $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg patchwork $*')
set_shell_function("pct2rgb.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pct2rgb.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pct2rgb.py $*')
set_shell_function("pdb3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pdb3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pdb3 $*')
set_shell_function("pdb3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pdb3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pdb3.5 $*')
set_shell_function("pilconvert.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pilconvert.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pilconvert.py $*')
set_shell_function("pildriver.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pildriver.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pildriver.py $*')
set_shell_function("pilfile.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pilfile.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pilfile.py $*')
set_shell_function("pilfont.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pilfont.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pilfont.py $*')
set_shell_function("pilprint.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pilprint.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pilprint.py $*')
set_shell_function("pixeltool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pixeltool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pixeltool $*')
set_shell_function("player.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg player.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg player.py $*')
set_shell_function("proj",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg proj $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg proj $*')
set_shell_function("prune",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg prune $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg prune $*')
set_shell_function("py3clean",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg py3clean $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg py3clean $*')
set_shell_function("py3compile",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg py3compile $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg py3compile $*')
set_shell_function("py3versions",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg py3versions $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg py3versions $*')
set_shell_function("pybuild",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pybuild $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pybuild $*')
set_shell_function("pygettext3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pygettext3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pygettext3 $*')
set_shell_function("pygettext3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pygettext3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg pygettext3.5 $*')
set_shell_function("python3m",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg python3m $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg python3m $*')
set_shell_function("qcollectiongenerator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qcollectiongenerator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qcollectiongenerator $*')
set_shell_function("qdbus",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdbus $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdbus $*')
set_shell_function("qdbuscpp2xml",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdbuscpp2xml $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdbuscpp2xml $*')
set_shell_function("qdbusviewer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdbusviewer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdbusviewer $*')
set_shell_function("qdbusxml2cpp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdbusxml2cpp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdbusxml2cpp $*')
set_shell_function("qdoc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdoc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdoc $*')
set_shell_function("qdoc3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdoc3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qdoc3 $*')
set_shell_function("qhelpconverter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qhelpconverter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qhelpconverter $*')
set_shell_function("qhelpgenerator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qhelpgenerator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qhelpgenerator $*')
set_shell_function("qlalr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qlalr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qlalr $*')
set_shell_function("qmake",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmake $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmake $*')
set_shell_function("qml",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qml $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qml $*')
set_shell_function("qml1plugindump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qml1plugindump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qml1plugindump $*')
set_shell_function("qmlbundle",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlbundle $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlbundle $*')
set_shell_function("qmleasing",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmleasing $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmleasing $*')
set_shell_function("qmlimportscanner",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlimportscanner $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlimportscanner $*')
set_shell_function("qmllint",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmllint $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmllint $*')
set_shell_function("qmlmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlmin $*')
set_shell_function("qmlplugindump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlplugindump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlplugindump $*')
set_shell_function("qmlprofiler",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlprofiler $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlprofiler $*')
set_shell_function("qmlscene",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlscene $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlscene $*')
set_shell_function("qmltestrunner",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmltestrunner $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmltestrunner $*')
set_shell_function("qmlviewer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlviewer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qmlviewer $*')
set_shell_function("qtchooser",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtchooser $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtchooser $*')
set_shell_function("qtconfig",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtconfig $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtconfig $*')
set_shell_function("qtdiag",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtdiag $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtdiag $*')
set_shell_function("qtpaths",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtpaths $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtpaths $*')
set_shell_function("qtplugininfo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtplugininfo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg qtplugininfo $*')
set_shell_function("rcc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg rcc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg rcc $*')
set_shell_function("redis-benchmark",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-benchmark $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-benchmark $*')
set_shell_function("redis-check-aof",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-check-aof $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-check-aof $*')
set_shell_function("redis-check-rdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-check-rdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-check-rdb $*')
set_shell_function("redis-cli",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-cli $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-cli $*')
set_shell_function("redis-server",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-server $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg redis-server $*')
set_shell_function("rgb2pct.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg rgb2pct.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg rgb2pct.py $*')
set_shell_function("sccmap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg sccmap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg sccmap $*')
set_shell_function("sfdp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg sfdp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg sfdp $*')
set_shell_function("sqlobject-admin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg sqlobject-admin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg sqlobject-admin $*')
set_shell_function("sqlobject-convertOldURI",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg sqlobject-convertOldURI $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg sqlobject-convertOldURI $*')
set_shell_function("stl2gts",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg stl2gts $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg stl2gts $*')
set_shell_function("thresholder.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg thresholder.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg thresholder.py $*')
set_shell_function("transform",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg transform $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg transform $*')
set_shell_function("tred",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg tred $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg tred $*')
set_shell_function("twopi",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg twopi $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg twopi $*')
set_shell_function("uic",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg uic $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg uic $*')
set_shell_function("uic3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg uic3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg uic3 $*')
set_shell_function("unflatten",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg unflatten $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg unflatten $*')
set_shell_function("viewer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg viewer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg viewer.py $*')
set_shell_function("vimdot",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg vimdot $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg vimdot $*')
set_shell_function("x86_64-linux-gnu-cpp-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-cpp-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-cpp-6 $*')
set_shell_function("x86_64-linux-gnu-g++-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-g++-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-g++-6 $*')
set_shell_function("x86_64-linux-gnu-gcc-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcc-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcc-6 $*')
set_shell_function("x86_64-linux-gnu-gcc-ar-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcc-ar-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcc-ar-6 $*')
set_shell_function("x86_64-linux-gnu-gcc-nm-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcc-nm-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcc-nm-6 $*')
set_shell_function("x86_64-linux-gnu-gcc-ranlib-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcc-ranlib-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcc-ranlib-6 $*')
set_shell_function("x86_64-linux-gnu-gcov-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcov-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcov-6 $*')
set_shell_function("x86_64-linux-gnu-gcov-dump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcov-dump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcov-dump $*')
set_shell_function("x86_64-linux-gnu-gcov-dump-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcov-dump-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcov-dump-6 $*')
set_shell_function("x86_64-linux-gnu-gcov-tool-6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcov-tool-6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg x86_64-linux-gnu-gcov-tool-6 $*')
set_shell_function("xmlpatterns",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg xmlpatterns $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg xmlpatterns $*')
set_shell_function("xmlpatternsvalidator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg xmlpatternsvalidator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epigrass/epigrass-v2.4.7-1-deb_cv1.simg xmlpatternsvalidator $*')
