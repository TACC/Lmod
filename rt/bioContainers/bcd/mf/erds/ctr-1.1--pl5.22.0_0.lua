local help_message = [[
This is a module file for the container quay.io/biocontainers/erds:1.1--pl5.22.0_0, which exposes the
following programs:

 - bcftools
 - erds_pipeline
 - ncurses6-config
 - perl5.22.0
 - samtools
 - vcfutils.pl

This container was pulled from:

	https://quay.io/repository/biocontainers/erds

If you encounter errors in erds or need help running the
tools it contains, please contact the developer at

	http://www.utahresearch.org/mingfuzhu/erds/

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: erds")
whatis("Version: ctr-1.1--pl5.22.0_0")
whatis("Category: ['Variant calling', 'Sequence alignment', 'Statistical calculation']")
whatis("Keywords: ['Sequence analysis', 'Genetic variation', 'Genomics']")
whatis("Description: ERDS is a free, open-source software, designed for detection of copy number variants (CNVs) on human genomes from next generation sequence data. It uses paired Hidden Markov models (PHMM) based on the expected distribution of read depth of short reads and the presence of heterozygous sites. ERDS is NOT good for whole exome data.")
whatis("URL: https://quay.io/repository/biocontainers/erds")

set_shell_function("bcftools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg bcftools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg bcftools $*')
set_shell_function("erds_pipeline",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg erds_pipeline $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg erds_pipeline $*')
set_shell_function("ncurses6-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg ncurses6-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg ncurses6-config $*')
set_shell_function("perl5.22.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg perl5.22.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg perl5.22.0 $*')
set_shell_function("samtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg samtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg samtools $*')
set_shell_function("vcfutils.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg vcfutils.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erds/erds-1.1--pl5.22.0_0.simg vcfutils.pl $*')
