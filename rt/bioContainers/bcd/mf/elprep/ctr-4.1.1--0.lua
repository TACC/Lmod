local help_message = [[
This is a module file for the container quay.io/biocontainers/elprep:4.1.1--0, which exposes the
following programs:

 - elprep

This container was pulled from:

	https://quay.io/repository/biocontainers/elprep

If you encounter errors in elprep or need help running the
tools it contains, please contact the developer at

	https://github.com/ExaScience/elprep

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: elprep")
whatis("Version: ctr-4.1.1--0")
whatis("Category: ['Variant calling']")
whatis("Keywords: ['Sequencing', 'Genetic variation', 'Sequence analysis']")
whatis("Description: Is a high-performance tool for preparing .sam/.bam/.cram files for variant calling in sequencing pipelines.It can be used as a drop-in replacement for SAMtools/Picard, and was extensively tested with different pipelines for variant analysis with GATK.")
whatis("URL: https://quay.io/repository/biocontainers/elprep")

set_shell_function("elprep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-4.1.1--0.simg elprep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-4.1.1--0.simg elprep $*')
