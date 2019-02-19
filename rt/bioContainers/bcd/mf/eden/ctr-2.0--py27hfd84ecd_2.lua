local help_message = [[
This is a module file for the container quay.io/biocontainers/eden:2.0--py27hfd84ecd_2, which exposes the
following programs:

 - .dbus-post-link.sh
 - RNAshapes
 - acyclic
 - annotate.py
 - annotateBed
 - assistant
 - babel
 - bamToBed
 - bamToFastq
 - bcftools
 - bcomps
 - bed12ToBed6
 - bedToBam
 - bedToIgv
 - bedpeToBam
 - bedtools
 - ccomps
 - circo
 - closestBed
 - cluster
 - clusterBed
 - color-chrs.pl
 - complementBed
 - coverageBed
 - dbus-launch
 - designer
 - dijkstra
 - dot
 - dot2gxl
 - dot_builtins
 - dvipdf
 - edgepaint
 - eps2eps
 - expandCols
 - fastaFromBed
 - fc-conflist
 - fdp
 - fixqt4headers.pl
 - flankBed
 - font2c
 - gc
 - genomeCoverageBed
 - getOverlap
 - get_objgraph
 - gml2gv
 - graphml2gv
 - groupBy
 - gs
 - gsbj
 - gsdj
 - gsdj500
 - gslj
 - gslp
 - gsnd
 - gst-device-monitor-1.0
 - gst-discoverer-1.0
 - gst-inspect-1.0
 - gst-launch-1.0
 - gst-play-1.0
 - gst-stats-1.0
 - gst-typefind-1.0
 - guess-ploidy.py
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
 - hb-subset
 - intersectBed
 - intersection_matrix.py
 - intron_exon_reads.py
 - lconvert
 - libtool
 - libtoolize
 - linguist
 - linksBed
 - location_predictor
 - lprsetup.sh
 - lrelease
 - lupdate
 - mapBed
 - maskFastaFromBed
 - mergeBed
 - mm2gv
 - moc
 - model
 - motif
 - motif_display.py
 - multiBamCov
 - multiIntersectBed
 - muscle
 - ncurses6-config
 - neato
 - nop
 - nucBed
 - obabel
 - obchiral
 - obconformer
 - obdistgen
 - obenergy
 - obfit
 - obgen
 - obgrep
 - obminimize
 - obprobe
 - obprop
 - obrms
 - obrotamer
 - obrotate
 - obspectrophore
 - obsym
 - obtautomer
 - obthermo
 - osage
 - pairToBed
 - pairToPair
 - patchwork
 - pbt_plotting_example.py
 - pdf2dsc
 - pdf2ps
 - peak_pie.py
 - pf2afm
 - pfbtopfa
 - pixeltool
 - plot-roh.py
 - plot-vcfstats
 - pphs
 - printafm
 - prune
 - ps2ascii
 - ps2epsi
 - ps2pdf
 - ps2pdf12
 - ps2pdf13
 - ps2pdf14
 - ps2pdfwr
 - ps2ps
 - ps2ps2
 - pybedtools
 - pylupdate5
 - pyrcc5
 - pyuic5
 - qcollectiongenerator
 - qdbus
 - qdbuscpp2xml
 - qdbusviewer
 - qdbusxml2cpp
 - qdoc
 - qhelpconverter
 - qhelpgenerator
 - qlalr
 - qmake
 - qml
 - qmleasing
 - qmlimportscanner
 - qmllint
 - qmlmin
 - qmlplugindump
 - qmlprofiler
 - qmlscene
 - qmltestrunner
 - qtdiag
 - qtpaths
 - qtplugininfo
 - randomBed
 - rcc
 - roundtrip
 - run-roh.pl
 - sample
 - samtools
 - sccmap
 - sfdp
 - shiftBed
 - shuffleBed
 - sip
 - slopBed
 - sortBed
 - subtractBed
 - syncqt.pl
 - tagBam
 - transformseq
 - tred
 - twopi
 - uic
 - undill
 - unflatten
 - unionBedGraphs
 - unix-lpr.sh
 - vcfutils.pl
 - venn_gchart.py
 - venn_mpl.py
 - weblogo
 - wftopfa
 - windowBed
 - windowMaker
 - xmlpatterns
 - xmlpatternsvalidator

This container was pulled from:

	https://quay.io/repository/biocontainers/eden

If you encounter errors in eden or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/eden

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: eden")
whatis("Version: ctr-2.0--py27hfd84ecd_2")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The eden package")
whatis("URL: https://quay.io/repository/biocontainers/eden")

set_shell_function(".dbus-post-link.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg .dbus-post-link.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg .dbus-post-link.sh $*')
set_shell_function("RNAshapes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg RNAshapes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg RNAshapes $*')
set_shell_function("acyclic",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg acyclic $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg acyclic $*')
set_shell_function("annotate.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg annotate.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg annotate.py $*')
set_shell_function("annotateBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg annotateBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg annotateBed $*')
set_shell_function("assistant",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg assistant $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg assistant $*')
set_shell_function("babel",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg babel $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg babel $*')
set_shell_function("bamToBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bamToBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bamToBed $*')
set_shell_function("bamToFastq",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bamToFastq $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bamToFastq $*')
set_shell_function("bcftools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bcftools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bcftools $*')
set_shell_function("bcomps",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bcomps $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bcomps $*')
set_shell_function("bed12ToBed6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bed12ToBed6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bed12ToBed6 $*')
set_shell_function("bedToBam",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bedToBam $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bedToBam $*')
set_shell_function("bedToIgv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bedToIgv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bedToIgv $*')
set_shell_function("bedpeToBam",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bedpeToBam $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bedpeToBam $*')
set_shell_function("bedtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bedtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg bedtools $*')
set_shell_function("ccomps",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ccomps $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ccomps $*')
set_shell_function("circo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg circo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg circo $*')
set_shell_function("closestBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg closestBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg closestBed $*')
set_shell_function("cluster",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg cluster $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg cluster $*')
set_shell_function("clusterBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg clusterBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg clusterBed $*')
set_shell_function("color-chrs.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg color-chrs.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg color-chrs.pl $*')
set_shell_function("complementBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg complementBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg complementBed $*')
set_shell_function("coverageBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg coverageBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg coverageBed $*')
set_shell_function("dbus-launch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dbus-launch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dbus-launch $*')
set_shell_function("designer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg designer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg designer $*')
set_shell_function("dijkstra",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dijkstra $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dijkstra $*')
set_shell_function("dot",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dot $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dot $*')
set_shell_function("dot2gxl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dot2gxl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dot2gxl $*')
set_shell_function("dot_builtins",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dot_builtins $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dot_builtins $*')
set_shell_function("dvipdf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dvipdf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg dvipdf $*')
set_shell_function("edgepaint",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg edgepaint $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg edgepaint $*')
set_shell_function("eps2eps",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg eps2eps $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg eps2eps $*')
set_shell_function("expandCols",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg expandCols $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg expandCols $*')
set_shell_function("fastaFromBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg fastaFromBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg fastaFromBed $*')
set_shell_function("fc-conflist",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg fc-conflist $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg fc-conflist $*')
set_shell_function("fdp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg fdp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg fdp $*')
set_shell_function("fixqt4headers.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg fixqt4headers.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg fixqt4headers.pl $*')
set_shell_function("flankBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg flankBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg flankBed $*')
set_shell_function("font2c",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg font2c $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg font2c $*')
set_shell_function("gc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gc $*')
set_shell_function("genomeCoverageBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg genomeCoverageBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg genomeCoverageBed $*')
set_shell_function("getOverlap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg getOverlap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg getOverlap $*')
set_shell_function("get_objgraph",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg get_objgraph $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg get_objgraph $*')
set_shell_function("gml2gv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gml2gv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gml2gv $*')
set_shell_function("graphml2gv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg graphml2gv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg graphml2gv $*')
set_shell_function("groupBy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg groupBy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg groupBy $*')
set_shell_function("gs",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gs $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gs $*')
set_shell_function("gsbj",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gsbj $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gsbj $*')
set_shell_function("gsdj",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gsdj $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gsdj $*')
set_shell_function("gsdj500",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gsdj500 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gsdj500 $*')
set_shell_function("gslj",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gslj $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gslj $*')
set_shell_function("gslp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gslp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gslp $*')
set_shell_function("gsnd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gsnd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gsnd $*')
set_shell_function("gst-device-monitor-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-device-monitor-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-device-monitor-1.0 $*')
set_shell_function("gst-discoverer-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-discoverer-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-discoverer-1.0 $*')
set_shell_function("gst-inspect-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-inspect-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-inspect-1.0 $*')
set_shell_function("gst-launch-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-launch-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-launch-1.0 $*')
set_shell_function("gst-play-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-play-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-play-1.0 $*')
set_shell_function("gst-stats-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-stats-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-stats-1.0 $*')
set_shell_function("gst-typefind-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-typefind-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gst-typefind-1.0 $*')
set_shell_function("guess-ploidy.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg guess-ploidy.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg guess-ploidy.py $*')
set_shell_function("gv2gml",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gv2gml $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gv2gml $*')
set_shell_function("gv2gxl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gv2gxl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gv2gxl $*')
set_shell_function("gvcolor",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvcolor $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvcolor $*')
set_shell_function("gvgen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvgen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvgen $*')
set_shell_function("gvmap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvmap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvmap $*')
set_shell_function("gvmap.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvmap.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvmap.sh $*')
set_shell_function("gvpack",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvpack $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvpack $*')
set_shell_function("gvpr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvpr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gvpr $*')
set_shell_function("gxl2dot",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gxl2dot $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gxl2dot $*')
set_shell_function("gxl2gv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gxl2gv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg gxl2gv $*')
set_shell_function("hb-subset",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg hb-subset $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg hb-subset $*')
set_shell_function("intersectBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg intersectBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg intersectBed $*')
set_shell_function("intersection_matrix.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg intersection_matrix.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg intersection_matrix.py $*')
set_shell_function("intron_exon_reads.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg intron_exon_reads.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg intron_exon_reads.py $*')
set_shell_function("lconvert",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg lconvert $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg lconvert $*')
set_shell_function("libtool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg libtool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg libtool $*')
set_shell_function("libtoolize",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg libtoolize $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg libtoolize $*')
set_shell_function("linguist",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg linguist $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg linguist $*')
set_shell_function("linksBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg linksBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg linksBed $*')
set_shell_function("location_predictor",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg location_predictor $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg location_predictor $*')
set_shell_function("lprsetup.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg lprsetup.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg lprsetup.sh $*')
set_shell_function("lrelease",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg lrelease $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg lrelease $*')
set_shell_function("lupdate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg lupdate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg lupdate $*')
set_shell_function("mapBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg mapBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg mapBed $*')
set_shell_function("maskFastaFromBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg maskFastaFromBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg maskFastaFromBed $*')
set_shell_function("mergeBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg mergeBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg mergeBed $*')
set_shell_function("mm2gv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg mm2gv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg mm2gv $*')
set_shell_function("moc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg moc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg moc $*')
set_shell_function("model",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg model $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg model $*')
set_shell_function("motif",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg motif $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg motif $*')
set_shell_function("motif_display.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg motif_display.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg motif_display.py $*')
set_shell_function("multiBamCov",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg multiBamCov $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg multiBamCov $*')
set_shell_function("multiIntersectBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg multiIntersectBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg multiIntersectBed $*')
set_shell_function("muscle",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg muscle $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg muscle $*')
set_shell_function("ncurses6-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ncurses6-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ncurses6-config $*')
set_shell_function("neato",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg neato $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg neato $*')
set_shell_function("nop",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg nop $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg nop $*')
set_shell_function("nucBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg nucBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg nucBed $*')
set_shell_function("obabel",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obabel $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obabel $*')
set_shell_function("obchiral",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obchiral $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obchiral $*')
set_shell_function("obconformer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obconformer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obconformer $*')
set_shell_function("obdistgen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obdistgen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obdistgen $*')
set_shell_function("obenergy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obenergy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obenergy $*')
set_shell_function("obfit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obfit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obfit $*')
set_shell_function("obgen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obgen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obgen $*')
set_shell_function("obgrep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obgrep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obgrep $*')
set_shell_function("obminimize",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obminimize $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obminimize $*')
set_shell_function("obprobe",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obprobe $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obprobe $*')
set_shell_function("obprop",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obprop $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obprop $*')
set_shell_function("obrms",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obrms $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obrms $*')
set_shell_function("obrotamer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obrotamer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obrotamer $*')
set_shell_function("obrotate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obrotate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obrotate $*')
set_shell_function("obspectrophore",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obspectrophore $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obspectrophore $*')
set_shell_function("obsym",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obsym $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obsym $*')
set_shell_function("obtautomer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obtautomer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obtautomer $*')
set_shell_function("obthermo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obthermo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg obthermo $*')
set_shell_function("osage",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg osage $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg osage $*')
set_shell_function("pairToBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pairToBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pairToBed $*')
set_shell_function("pairToPair",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pairToPair $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pairToPair $*')
set_shell_function("patchwork",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg patchwork $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg patchwork $*')
set_shell_function("pbt_plotting_example.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pbt_plotting_example.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pbt_plotting_example.py $*')
set_shell_function("pdf2dsc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pdf2dsc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pdf2dsc $*')
set_shell_function("pdf2ps",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pdf2ps $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pdf2ps $*')
set_shell_function("peak_pie.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg peak_pie.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg peak_pie.py $*')
set_shell_function("pf2afm",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pf2afm $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pf2afm $*')
set_shell_function("pfbtopfa",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pfbtopfa $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pfbtopfa $*')
set_shell_function("pixeltool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pixeltool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pixeltool $*')
set_shell_function("plot-roh.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg plot-roh.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg plot-roh.py $*')
set_shell_function("plot-vcfstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg plot-vcfstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg plot-vcfstats $*')
set_shell_function("pphs",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pphs $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pphs $*')
set_shell_function("printafm",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg printafm $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg printafm $*')
set_shell_function("prune",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg prune $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg prune $*')
set_shell_function("ps2ascii",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2ascii $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2ascii $*')
set_shell_function("ps2epsi",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2epsi $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2epsi $*')
set_shell_function("ps2pdf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdf $*')
set_shell_function("ps2pdf12",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdf12 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdf12 $*')
set_shell_function("ps2pdf13",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdf13 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdf13 $*')
set_shell_function("ps2pdf14",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdf14 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdf14 $*')
set_shell_function("ps2pdfwr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdfwr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2pdfwr $*')
set_shell_function("ps2ps",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2ps $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2ps $*')
set_shell_function("ps2ps2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2ps2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg ps2ps2 $*')
set_shell_function("pybedtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pybedtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pybedtools $*')
set_shell_function("pylupdate5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pylupdate5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pylupdate5 $*')
set_shell_function("pyrcc5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pyrcc5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pyrcc5 $*')
set_shell_function("pyuic5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pyuic5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg pyuic5 $*')
set_shell_function("qcollectiongenerator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qcollectiongenerator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qcollectiongenerator $*')
set_shell_function("qdbus",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdbus $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdbus $*')
set_shell_function("qdbuscpp2xml",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdbuscpp2xml $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdbuscpp2xml $*')
set_shell_function("qdbusviewer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdbusviewer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdbusviewer $*')
set_shell_function("qdbusxml2cpp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdbusxml2cpp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdbusxml2cpp $*')
set_shell_function("qdoc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdoc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qdoc $*')
set_shell_function("qhelpconverter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qhelpconverter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qhelpconverter $*')
set_shell_function("qhelpgenerator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qhelpgenerator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qhelpgenerator $*')
set_shell_function("qlalr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qlalr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qlalr $*')
set_shell_function("qmake",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmake $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmake $*')
set_shell_function("qml",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qml $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qml $*')
set_shell_function("qmleasing",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmleasing $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmleasing $*')
set_shell_function("qmlimportscanner",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlimportscanner $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlimportscanner $*')
set_shell_function("qmllint",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmllint $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmllint $*')
set_shell_function("qmlmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlmin $*')
set_shell_function("qmlplugindump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlplugindump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlplugindump $*')
set_shell_function("qmlprofiler",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlprofiler $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlprofiler $*')
set_shell_function("qmlscene",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlscene $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmlscene $*')
set_shell_function("qmltestrunner",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmltestrunner $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qmltestrunner $*')
set_shell_function("qtdiag",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qtdiag $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qtdiag $*')
set_shell_function("qtpaths",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qtpaths $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qtpaths $*')
set_shell_function("qtplugininfo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qtplugininfo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg qtplugininfo $*')
set_shell_function("randomBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg randomBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg randomBed $*')
set_shell_function("rcc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg rcc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg rcc $*')
set_shell_function("roundtrip",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg roundtrip $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg roundtrip $*')
set_shell_function("run-roh.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg run-roh.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg run-roh.pl $*')
set_shell_function("sample",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sample $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sample $*')
set_shell_function("samtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg samtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg samtools $*')
set_shell_function("sccmap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sccmap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sccmap $*')
set_shell_function("sfdp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sfdp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sfdp $*')
set_shell_function("shiftBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg shiftBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg shiftBed $*')
set_shell_function("shuffleBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg shuffleBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg shuffleBed $*')
set_shell_function("sip",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sip $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sip $*')
set_shell_function("slopBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg slopBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg slopBed $*')
set_shell_function("sortBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sortBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg sortBed $*')
set_shell_function("subtractBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg subtractBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg subtractBed $*')
set_shell_function("syncqt.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg syncqt.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg syncqt.pl $*')
set_shell_function("tagBam",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg tagBam $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg tagBam $*')
set_shell_function("transformseq",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg transformseq $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg transformseq $*')
set_shell_function("tred",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg tred $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg tred $*')
set_shell_function("twopi",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg twopi $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg twopi $*')
set_shell_function("uic",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg uic $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg uic $*')
set_shell_function("undill",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg undill $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg undill $*')
set_shell_function("unflatten",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg unflatten $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg unflatten $*')
set_shell_function("unionBedGraphs",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg unionBedGraphs $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg unionBedGraphs $*')
set_shell_function("unix-lpr.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg unix-lpr.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg unix-lpr.sh $*')
set_shell_function("vcfutils.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg vcfutils.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg vcfutils.pl $*')
set_shell_function("venn_gchart.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg venn_gchart.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg venn_gchart.py $*')
set_shell_function("venn_mpl.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg venn_mpl.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg venn_mpl.py $*')
set_shell_function("weblogo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg weblogo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg weblogo $*')
set_shell_function("wftopfa",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg wftopfa $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg wftopfa $*')
set_shell_function("windowBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg windowBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg windowBed $*')
set_shell_function("windowMaker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg windowMaker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg windowMaker $*')
set_shell_function("xmlpatterns",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg xmlpatterns $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg xmlpatterns $*')
set_shell_function("xmlpatternsvalidator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg xmlpatternsvalidator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27hfd84ecd_2.simg xmlpatternsvalidator $*')
