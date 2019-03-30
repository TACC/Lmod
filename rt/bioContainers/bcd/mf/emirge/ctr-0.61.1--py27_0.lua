local help_message = [[
This is a module file for the container quay.io/biocontainers/emirge:0.61.1--py27_0, which exposes the
following programs:

 - aclocal.bak
 - automake.bak
 - bcftools
 - bmp2tiff
 - bowtie
 - bowtie-align-l
 - bowtie-align-s
 - bowtie-build
 - bowtie-build-l
 - bowtie-build-s
 - bowtie-inspect
 - bowtie-inspect-l
 - bowtie-inspect-s
 - color-chrs.pl
 - createfontdatachunk.py
 - emirge.py
 - emirge_amplicon.py
 - emirge_makedb.py
 - emirge_rename_fasta.py
 - enhancer.py
 - explode.py
 - gif2tiff
 - gifmaker.py
 - painter.py
 - pilconvert.py
 - pildriver.py
 - pilfile.py
 - pilfont.py
 - pilprint.py
 - player.py
 - plot-vcfstats
 - ras2tiff
 - rgb2ycbcr
 - sample
 - samtools
 - thresholder.py
 - thumbnail
 - vcfutils.pl
 - viewer.py
 - vsearch

This container was pulled from:

	https://quay.io/repository/biocontainers/emirge

If you encounter errors in emirge or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/emirge

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: emirge")
whatis("Version: ctr-0.61.1--py27_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The emirge package")
whatis("URL: https://quay.io/repository/biocontainers/emirge")

set_shell_function("aclocal.bak",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg aclocal.bak $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg aclocal.bak $*')
set_shell_function("automake.bak",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg automake.bak $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg automake.bak $*')
set_shell_function("bcftools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bcftools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bcftools $*')
set_shell_function("bmp2tiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bmp2tiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bmp2tiff $*')
set_shell_function("bowtie",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie $*')
set_shell_function("bowtie-align-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-align-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-align-l $*')
set_shell_function("bowtie-align-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-align-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-align-s $*')
set_shell_function("bowtie-build",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-build $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-build $*')
set_shell_function("bowtie-build-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-build-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-build-l $*')
set_shell_function("bowtie-build-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-build-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-build-s $*')
set_shell_function("bowtie-inspect",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-inspect $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-inspect $*')
set_shell_function("bowtie-inspect-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-inspect-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-inspect-l $*')
set_shell_function("bowtie-inspect-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-inspect-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg bowtie-inspect-s $*')
set_shell_function("color-chrs.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg color-chrs.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg color-chrs.pl $*')
set_shell_function("createfontdatachunk.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg createfontdatachunk.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg createfontdatachunk.py $*')
set_shell_function("emirge.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg emirge.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg emirge.py $*')
set_shell_function("emirge_amplicon.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg emirge_amplicon.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg emirge_amplicon.py $*')
set_shell_function("emirge_makedb.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg emirge_makedb.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg emirge_makedb.py $*')
set_shell_function("emirge_rename_fasta.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg emirge_rename_fasta.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg emirge_rename_fasta.py $*')
set_shell_function("enhancer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg enhancer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg enhancer.py $*')
set_shell_function("explode.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg explode.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg explode.py $*')
set_shell_function("gif2tiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg gif2tiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg gif2tiff $*')
set_shell_function("gifmaker.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg gifmaker.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg gifmaker.py $*')
set_shell_function("painter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg painter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg painter.py $*')
set_shell_function("pilconvert.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pilconvert.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pilconvert.py $*')
set_shell_function("pildriver.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pildriver.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pildriver.py $*')
set_shell_function("pilfile.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pilfile.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pilfile.py $*')
set_shell_function("pilfont.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pilfont.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pilfont.py $*')
set_shell_function("pilprint.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pilprint.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg pilprint.py $*')
set_shell_function("player.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg player.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg player.py $*')
set_shell_function("plot-vcfstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg plot-vcfstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg plot-vcfstats $*')
set_shell_function("ras2tiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg ras2tiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg ras2tiff $*')
set_shell_function("rgb2ycbcr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg rgb2ycbcr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg rgb2ycbcr $*')
set_shell_function("sample",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg sample $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg sample $*')
set_shell_function("samtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg samtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg samtools $*')
set_shell_function("thresholder.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg thresholder.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg thresholder.py $*')
set_shell_function("thumbnail",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg thumbnail $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg thumbnail $*')
set_shell_function("vcfutils.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg vcfutils.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg vcfutils.pl $*')
set_shell_function("viewer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg viewer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg viewer.py $*')
set_shell_function("vsearch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg vsearch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27_0.simg vsearch $*')
