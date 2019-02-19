local help_message = [[
This is a module file for the container quay.io/biocontainers/esimsa:1.0--h470a237_1, which exposes the
following programs:

 - esimsa

This container was pulled from:

	https://quay.io/repository/biocontainers/esimsa

If you encounter errors in esimsa or need help running the
tools it contains, please contact the developer at

	http://www.ms-utils.org/esimsa.html

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: esimsa")
whatis("Version: ctr-1.0--h470a237_1")
whatis("Category: ['Deisotoping']")
whatis("Keywords: ['Proteomics', 'Proteomics experiment']")
whatis("Description: Simple deconvolution of electrospray ionization peak lists.")
whatis("URL: https://quay.io/repository/biocontainers/esimsa")

set_shell_function("esimsa",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/esimsa/esimsa-1.0--h470a237_1.simg esimsa $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/esimsa/esimsa-1.0--h470a237_1.simg esimsa $*')
