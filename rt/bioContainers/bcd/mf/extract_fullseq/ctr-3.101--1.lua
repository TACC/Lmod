local help_message = [[
This is a module file for the container quay.io/biocontainers/extract_fullseq:3.101--1, which exposes the
following programs:

 - extract_fullseq

This container was pulled from:

	https://quay.io/repository/biocontainers/extract_fullseq

If you encounter errors in extract_fullseq or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/extract_fullseq

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: extract_fullseq")
whatis("Version: ctr-3.101--1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The extract_fullseq package")
whatis("URL: https://quay.io/repository/biocontainers/extract_fullseq")

set_shell_function("extract_fullseq",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_fullseq/extract_fullseq-3.101--1.simg extract_fullseq $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_fullseq/extract_fullseq-3.101--1.simg extract_fullseq $*')
