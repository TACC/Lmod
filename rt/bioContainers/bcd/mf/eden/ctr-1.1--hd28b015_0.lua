local help_message = [[
This is a module file for the container quay.io/biocontainers/eden:1.1--hd28b015_0, which exposes the
following programs:

 - EDeN

This container was pulled from:

	https://quay.io/repository/biocontainers/eden

If you encounter errors in eden or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/eden

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: eden")
whatis("Version: ctr-1.1--hd28b015_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The eden package")
whatis("URL: https://quay.io/repository/biocontainers/eden")

set_shell_function("EDeN",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-1.1--hd28b015_0.simg EDeN $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eden/eden-1.1--hd28b015_0.simg EDeN $*')
