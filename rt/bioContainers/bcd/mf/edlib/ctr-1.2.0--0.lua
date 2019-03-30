local help_message = [[
This is a module file for the container quay.io/biocontainers/edlib:1.2.0--0, which exposes the
following programs:

 - edlib-aligner

This container was pulled from:

	https://quay.io/repository/biocontainers/edlib

If you encounter errors in edlib or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/edlib

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: edlib")
whatis("Version: ctr-1.2.0--0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The edlib package")
whatis("URL: https://quay.io/repository/biocontainers/edlib")

set_shell_function("edlib-aligner",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/edlib/edlib-1.2.0--0.simg edlib-aligner $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/edlib/edlib-1.2.0--0.simg edlib-aligner $*')
