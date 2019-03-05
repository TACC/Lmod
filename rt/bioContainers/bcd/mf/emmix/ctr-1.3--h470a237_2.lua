local help_message = [[
This is a module file for the container quay.io/biocontainers/emmix:1.3--h470a237_2, which exposes the
following programs:

 - EMMIX

This container was pulled from:

	https://quay.io/repository/biocontainers/emmix

If you encounter errors in emmix or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/emmix

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: emmix")
whatis("Version: ctr-1.3--h470a237_2")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The emmix package")
whatis("URL: https://quay.io/repository/biocontainers/emmix")

set_shell_function("EMMIX",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emmix/emmix-1.3--h470a237_2.simg EMMIX $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emmix/emmix-1.3--h470a237_2.simg EMMIX $*')
