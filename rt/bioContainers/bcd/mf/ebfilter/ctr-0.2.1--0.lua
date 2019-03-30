local help_message = [[
This is a module file for the container quay.io/biocontainers/ebfilter:0.2.1--0, which exposes the
following programs:

 - EBFilter
 - bcftools
 - color-chrs.pl
 - guess-ploidy.py
 - ksu
 - plot-roh.py
 - plot-vcfstats
 - run-roh.pl
 - samtools
 - vcf_filter.py
 - vcf_melt
 - vcf_sample_filter.py
 - vcfutils.pl

This container was pulled from:

	https://quay.io/repository/biocontainers/ebfilter

If you encounter errors in ebfilter or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/ebfilter

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ebfilter")
whatis("Version: ctr-0.2.1--0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ebfilter package")
whatis("URL: https://quay.io/repository/biocontainers/ebfilter")

set_shell_function("EBFilter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg EBFilter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg EBFilter $*')
set_shell_function("bcftools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg bcftools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg bcftools $*')
set_shell_function("color-chrs.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg color-chrs.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg color-chrs.pl $*')
set_shell_function("guess-ploidy.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg guess-ploidy.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg guess-ploidy.py $*')
set_shell_function("ksu",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg ksu $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg ksu $*')
set_shell_function("plot-roh.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg plot-roh.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg plot-roh.py $*')
set_shell_function("plot-vcfstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg plot-vcfstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg plot-vcfstats $*')
set_shell_function("run-roh.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg run-roh.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg run-roh.pl $*')
set_shell_function("samtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg samtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg samtools $*')
set_shell_function("vcf_filter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg vcf_filter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg vcf_filter.py $*')
set_shell_function("vcf_melt",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg vcf_melt $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg vcf_melt $*')
set_shell_function("vcf_sample_filter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg vcf_sample_filter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg vcf_sample_filter.py $*')
set_shell_function("vcfutils.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg vcfutils.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebfilter/ebfilter-0.2.1--0.simg vcfutils.pl $*')
