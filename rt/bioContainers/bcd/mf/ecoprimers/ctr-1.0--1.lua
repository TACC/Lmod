local help_message = [[
This is a module file for the container quay.io/biocontainers/ecoprimers:1.0--1, which exposes the
following programs:

 - ecoPrimers

This container was pulled from:

	https://quay.io/repository/biocontainers/ecoprimers

If you encounter errors in ecoprimers or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/ecoprimers

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ecoprimers")
whatis("Version: ctr-1.0--1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ecoprimers package")
whatis("URL: https://quay.io/repository/biocontainers/ecoprimers")

set_shell_function("ecoPrimers",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecoprimers/ecoprimers-1.0--1.simg ecoPrimers $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecoprimers/ecoprimers-1.0--1.simg ecoPrimers $*')
