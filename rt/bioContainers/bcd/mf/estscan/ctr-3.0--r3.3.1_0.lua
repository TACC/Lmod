local help_message = [[
This is a module file for the container quay.io/biocontainers/estscan:3.0--r3.3.1_0, which exposes the
following programs:

 - ESTScan
 - ESTScan1
 - R
 - Rscript
 - annotate
 - bdftogd
 - bl2seq
 - blastall
 - blastclust
 - blastpgp
 - bmp2tiff
 - copymat
 - estscan
 - fastacmd
 - fetch
 - formatdb
 - formatrpsdb
 - gd2copypal
 - gd2togif
 - gd2topng
 - gdcmpgif
 - gdlib-config
 - gdparttopng
 - gdtopng
 - genccode
 - gencmn
 - gennorm2
 - gensprep
 - gif2tiff
 - giftogd2
 - gnuplot
 - icupkg
 - impala
 - indexer
 - makemat
 - megablast
 - netfetch
 - perl5.22.0
 - pngtogd
 - pngtogd2
 - ras2tiff
 - rgb2ycbcr
 - rpsblast
 - seedtop
 - thumbnail
 - uconv
 - webpng

This container was pulled from:

	https://quay.io/repository/biocontainers/estscan

If you encounter errors in estscan or need help running the
tools it contains, please contact the developer at

	http://myhits.isb-sib.ch/cgi-bin/estscan

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: estscan")
whatis("Version: ctr-3.0--r3.3.1_0")
whatis("Category: ['Annotation']")
whatis("Keywords: ['Genomics', 'Transcriptomics']")
whatis("Description: ESTScan can detect coding regions (CDS) in DNA sequences, even if they are of low quality.  It  also detects/corrects sequencing errors that lead to frameshifts.  ESTScan is not a gene prediction program , nor is it an open reading frame detector.  In fact, its strength lies in the fact that it does not require an open reading frame to detect a coding region.  The program may miss a few translated amino acids at termini, but detects coding regions with high selectivity and sensitivity.")
whatis("URL: https://quay.io/repository/biocontainers/estscan")

set_shell_function("ESTScan",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg ESTScan $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg ESTScan $*')
set_shell_function("ESTScan1",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg ESTScan1 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg ESTScan1 $*')
set_shell_function("R",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg R $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg R $*')
set_shell_function("Rscript",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg Rscript $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg Rscript $*')
set_shell_function("annotate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg annotate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg annotate $*')
set_shell_function("bdftogd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg bdftogd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg bdftogd $*')
set_shell_function("bl2seq",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg bl2seq $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg bl2seq $*')
set_shell_function("blastall",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg blastall $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg blastall $*')
set_shell_function("blastclust",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg blastclust $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg blastclust $*')
set_shell_function("blastpgp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg blastpgp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg blastpgp $*')
set_shell_function("bmp2tiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg bmp2tiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg bmp2tiff $*')
set_shell_function("copymat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg copymat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg copymat $*')
set_shell_function("estscan",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg estscan $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg estscan $*')
set_shell_function("fastacmd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg fastacmd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg fastacmd $*')
set_shell_function("fetch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg fetch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg fetch $*')
set_shell_function("formatdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg formatdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg formatdb $*')
set_shell_function("formatrpsdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg formatrpsdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg formatrpsdb $*')
set_shell_function("gd2copypal",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gd2copypal $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gd2copypal $*')
set_shell_function("gd2togif",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gd2togif $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gd2togif $*')
set_shell_function("gd2topng",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gd2topng $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gd2topng $*')
set_shell_function("gdcmpgif",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gdcmpgif $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gdcmpgif $*')
set_shell_function("gdlib-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gdlib-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gdlib-config $*')
set_shell_function("gdparttopng",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gdparttopng $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gdparttopng $*')
set_shell_function("gdtopng",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gdtopng $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gdtopng $*')
set_shell_function("genccode",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg genccode $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg genccode $*')
set_shell_function("gencmn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gencmn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gencmn $*')
set_shell_function("gennorm2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gennorm2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gennorm2 $*')
set_shell_function("gensprep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gensprep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gensprep $*')
set_shell_function("gif2tiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gif2tiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gif2tiff $*')
set_shell_function("giftogd2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg giftogd2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg giftogd2 $*')
set_shell_function("gnuplot",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gnuplot $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg gnuplot $*')
set_shell_function("icupkg",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg icupkg $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg icupkg $*')
set_shell_function("impala",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg impala $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg impala $*')
set_shell_function("indexer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg indexer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg indexer $*')
set_shell_function("makemat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg makemat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg makemat $*')
set_shell_function("megablast",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg megablast $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg megablast $*')
set_shell_function("netfetch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg netfetch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg netfetch $*')
set_shell_function("perl5.22.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg perl5.22.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg perl5.22.0 $*')
set_shell_function("pngtogd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg pngtogd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg pngtogd $*')
set_shell_function("pngtogd2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg pngtogd2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg pngtogd2 $*')
set_shell_function("ras2tiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg ras2tiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg ras2tiff $*')
set_shell_function("rgb2ycbcr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg rgb2ycbcr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg rgb2ycbcr $*')
set_shell_function("rpsblast",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg rpsblast $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg rpsblast $*')
set_shell_function("seedtop",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg seedtop $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg seedtop $*')
set_shell_function("thumbnail",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg thumbnail $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg thumbnail $*')
set_shell_function("uconv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg uconv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg uconv $*')
set_shell_function("webpng",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg webpng $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--r3.3.1_0.simg webpng $*')
