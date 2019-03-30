local help_message = [[
This is a module file for the container quay.io/biocontainers/emirge:0.61.1--py27h355e19c_2, which exposes the
following programs:

 - bcftools
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
 - emirge.py
 - emirge_amplicon.py
 - emirge_makedb.py
 - emirge_rename_fasta.py
 - guess-ploidy.py
 - perl5.26.2
 - plot-roh.py
 - plot-vcfstats
 - run-roh.pl
 - sample
 - samtools
 - vcfutils.pl
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
whatis("Version: ctr-0.61.1--py27h355e19c_2")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The emirge package")
whatis("URL: https://quay.io/repository/biocontainers/emirge")

set_shell_function("bcftools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bcftools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bcftools $*')
set_shell_function("bowtie",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie $*')
set_shell_function("bowtie-align-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-align-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-align-l $*')
set_shell_function("bowtie-align-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-align-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-align-s $*')
set_shell_function("bowtie-build",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-build $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-build $*')
set_shell_function("bowtie-build-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-build-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-build-l $*')
set_shell_function("bowtie-build-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-build-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-build-s $*')
set_shell_function("bowtie-inspect",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-inspect $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-inspect $*')
set_shell_function("bowtie-inspect-l",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-inspect-l $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-inspect-l $*')
set_shell_function("bowtie-inspect-s",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-inspect-s $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg bowtie-inspect-s $*')
set_shell_function("color-chrs.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg color-chrs.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg color-chrs.pl $*')
set_shell_function("emirge.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg emirge.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg emirge.py $*')
set_shell_function("emirge_amplicon.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg emirge_amplicon.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg emirge_amplicon.py $*')
set_shell_function("emirge_makedb.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg emirge_makedb.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg emirge_makedb.py $*')
set_shell_function("emirge_rename_fasta.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg emirge_rename_fasta.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg emirge_rename_fasta.py $*')
set_shell_function("guess-ploidy.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg guess-ploidy.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg guess-ploidy.py $*')
set_shell_function("perl5.26.2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg perl5.26.2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg perl5.26.2 $*')
set_shell_function("plot-roh.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg plot-roh.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg plot-roh.py $*')
set_shell_function("plot-vcfstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg plot-vcfstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg plot-vcfstats $*')
set_shell_function("run-roh.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg run-roh.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg run-roh.pl $*')
set_shell_function("sample",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg sample $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg sample $*')
set_shell_function("samtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg samtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg samtools $*')
set_shell_function("vcfutils.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg vcfutils.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg vcfutils.pl $*')
set_shell_function("vsearch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg vsearch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emirge/emirge-0.61.1--py27h355e19c_2.simg vsearch $*')
