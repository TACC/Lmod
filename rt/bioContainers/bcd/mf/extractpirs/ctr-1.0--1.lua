local help_message = [[
This is a module file for the container quay.io/biocontainers/extractpirs:1.0--1, which exposes the
following programs:

 - extractPIRs

This container was pulled from:

	https://quay.io/repository/biocontainers/extractpirs

If you encounter errors in extractpirs or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/extractpirs

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: extractpirs")
whatis("Version: ctr-1.0--1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The extractpirs package")
whatis("URL: https://quay.io/repository/biocontainers/extractpirs")

set_shell_function("extractPIRs",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/extractpirs/extractpirs-1.0--1.simg extractPIRs $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/extractpirs/extractpirs-1.0--1.simg extractPIRs $*')
