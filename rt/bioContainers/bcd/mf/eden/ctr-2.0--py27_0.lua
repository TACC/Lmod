local help_message = [[
This is a module file for the container quay.io/biocontainers/eden:2.0--py27_0, which exposes the
following programs:

 - RNAshapes
 - annotate.py
 - assistant
 - babel
 - bcftools
 - bmp2tiff
 - color-chrs.pl
 - createfontdatachunk.py
 - designer
 - enhancer.py
 - explode.py
 - get_objgraph.py
 - gif2tiff
 - gifmaker.py
 - intersection_matrix.py
 - intron_exon_reads.py
 - lconvert
 - linguist
 - location_predictor
 - lrelease
 - lupdate
 - moc
 - model
 - motif
 - motif_display.py
 - muscle
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
 - painter.py
 - pbt_plotting_example.py
 - peak_pie.py
 - perl5.22.0
 - pilconvert.py
 - pildriver.py
 - pilfile.py
 - pilfont.py
 - pilprint.py
 - pixeltool
 - player.py
 - plot-vcfstats
 - pybedtools
 - pylupdate4
 - pyrcc4
 - pyuic4
 - qcollectiongenerator
 - qdbus
 - qdbuscpp2xml
 - qdbusviewer
 - qdbusxml2cpp
 - qdoc3
 - qhelpconverter
 - qhelpgenerator
 - qmake
 - qmlplugindump
 - qmlviewer
 - qt3to4
 - qtconfig
 - qttracereplay
 - ras2tiff
 - rcc
 - rgb2ycbcr
 - roundtrip
 - sample
 - samtools
 - seqlogo
 - sip
 - thresholder.py
 - thumbnail
 - uic
 - unpickle.py
 - vcfutils.pl
 - venn_gchart.py
 - venn_mpl.py
 - viewer.py
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
whatis("Version: ctr-2.0--py27_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The eden package")
whatis("URL: https://quay.io/repository/biocontainers/eden")

set_shell_function("RNAshapes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg RNAshapes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg RNAshapes $*')
set_shell_function("annotate.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg annotate.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg annotate.py $*')
set_shell_function("assistant",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg assistant $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg assistant $*')
set_shell_function("babel",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg babel $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg babel $*')
set_shell_function("bcftools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg bcftools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg bcftools $*')
set_shell_function("bmp2tiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg bmp2tiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg bmp2tiff $*')
set_shell_function("color-chrs.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg color-chrs.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg color-chrs.pl $*')
set_shell_function("createfontdatachunk.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg createfontdatachunk.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg createfontdatachunk.py $*')
set_shell_function("designer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg designer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg designer $*')
set_shell_function("enhancer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg enhancer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg enhancer.py $*')
set_shell_function("explode.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg explode.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg explode.py $*')
set_shell_function("get_objgraph.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg get_objgraph.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg get_objgraph.py $*')
set_shell_function("gif2tiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg gif2tiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg gif2tiff $*')
set_shell_function("gifmaker.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg gifmaker.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg gifmaker.py $*')
set_shell_function("intersection_matrix.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg intersection_matrix.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg intersection_matrix.py $*')
set_shell_function("intron_exon_reads.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg intron_exon_reads.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg intron_exon_reads.py $*')
set_shell_function("lconvert",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg lconvert $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg lconvert $*')
set_shell_function("linguist",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg linguist $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg linguist $*')
set_shell_function("location_predictor",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg location_predictor $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg location_predictor $*')
set_shell_function("lrelease",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg lrelease $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg lrelease $*')
set_shell_function("lupdate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg lupdate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg lupdate $*')
set_shell_function("moc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg moc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg moc $*')
set_shell_function("model",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg model $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg model $*')
set_shell_function("motif",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg motif $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg motif $*')
set_shell_function("motif_display.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg motif_display.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg motif_display.py $*')
set_shell_function("muscle",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg muscle $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg muscle $*')
set_shell_function("obabel",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obabel $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obabel $*')
set_shell_function("obchiral",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obchiral $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obchiral $*')
set_shell_function("obconformer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obconformer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obconformer $*')
set_shell_function("obdistgen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obdistgen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obdistgen $*')
set_shell_function("obenergy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obenergy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obenergy $*')
set_shell_function("obfit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obfit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obfit $*')
set_shell_function("obgen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obgen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obgen $*')
set_shell_function("obgrep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obgrep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obgrep $*')
set_shell_function("obminimize",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obminimize $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obminimize $*')
set_shell_function("obprobe",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obprobe $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obprobe $*')
set_shell_function("obprop",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obprop $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obprop $*')
set_shell_function("obrms",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obrms $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obrms $*')
set_shell_function("obrotamer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obrotamer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obrotamer $*')
set_shell_function("obrotate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obrotate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obrotate $*')
set_shell_function("obspectrophore",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obspectrophore $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obspectrophore $*')
set_shell_function("obsym",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obsym $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obsym $*')
set_shell_function("obtautomer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obtautomer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obtautomer $*')
set_shell_function("obthermo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obthermo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg obthermo $*')
set_shell_function("painter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg painter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg painter.py $*')
set_shell_function("pbt_plotting_example.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pbt_plotting_example.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pbt_plotting_example.py $*')
set_shell_function("peak_pie.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg peak_pie.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg peak_pie.py $*')
set_shell_function("perl5.22.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg perl5.22.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg perl5.22.0 $*')
set_shell_function("pilconvert.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pilconvert.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pilconvert.py $*')
set_shell_function("pildriver.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pildriver.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pildriver.py $*')
set_shell_function("pilfile.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pilfile.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pilfile.py $*')
set_shell_function("pilfont.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pilfont.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pilfont.py $*')
set_shell_function("pilprint.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pilprint.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pilprint.py $*')
set_shell_function("pixeltool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pixeltool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pixeltool $*')
set_shell_function("player.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg player.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg player.py $*')
set_shell_function("plot-vcfstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg plot-vcfstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg plot-vcfstats $*')
set_shell_function("pybedtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pybedtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pybedtools $*')
set_shell_function("pylupdate4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pylupdate4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pylupdate4 $*')
set_shell_function("pyrcc4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pyrcc4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pyrcc4 $*')
set_shell_function("pyuic4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pyuic4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg pyuic4 $*')
set_shell_function("qcollectiongenerator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qcollectiongenerator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qcollectiongenerator $*')
set_shell_function("qdbus",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdbus $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdbus $*')
set_shell_function("qdbuscpp2xml",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdbuscpp2xml $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdbuscpp2xml $*')
set_shell_function("qdbusviewer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdbusviewer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdbusviewer $*')
set_shell_function("qdbusxml2cpp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdbusxml2cpp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdbusxml2cpp $*')
set_shell_function("qdoc3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdoc3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qdoc3 $*')
set_shell_function("qhelpconverter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qhelpconverter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qhelpconverter $*')
set_shell_function("qhelpgenerator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qhelpgenerator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qhelpgenerator $*')
set_shell_function("qmake",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qmake $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qmake $*')
set_shell_function("qmlplugindump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qmlplugindump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qmlplugindump $*')
set_shell_function("qmlviewer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qmlviewer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qmlviewer $*')
set_shell_function("qt3to4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qt3to4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qt3to4 $*')
set_shell_function("qtconfig",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qtconfig $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qtconfig $*')
set_shell_function("qttracereplay",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qttracereplay $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg qttracereplay $*')
set_shell_function("ras2tiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg ras2tiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg ras2tiff $*')
set_shell_function("rcc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg rcc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg rcc $*')
set_shell_function("rgb2ycbcr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg rgb2ycbcr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg rgb2ycbcr $*')
set_shell_function("roundtrip",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg roundtrip $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg roundtrip $*')
set_shell_function("sample",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg sample $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg sample $*')
set_shell_function("samtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg samtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg samtools $*')
set_shell_function("seqlogo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg seqlogo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg seqlogo $*')
set_shell_function("sip",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg sip $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg sip $*')
set_shell_function("thresholder.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg thresholder.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg thresholder.py $*')
set_shell_function("thumbnail",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg thumbnail $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg thumbnail $*')
set_shell_function("uic",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg uic $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg uic $*')
set_shell_function("unpickle.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg unpickle.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg unpickle.py $*')
set_shell_function("vcfutils.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg vcfutils.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg vcfutils.pl $*')
set_shell_function("venn_gchart.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg venn_gchart.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg venn_gchart.py $*')
set_shell_function("venn_mpl.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg venn_mpl.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg venn_mpl.py $*')
set_shell_function("viewer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg viewer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg viewer.py $*')
set_shell_function("xmlpatterns",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg xmlpatterns $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg xmlpatterns $*')
set_shell_function("xmlpatternsvalidator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg xmlpatternsvalidator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-2.0--py27_0.simg xmlpatternsvalidator $*')
