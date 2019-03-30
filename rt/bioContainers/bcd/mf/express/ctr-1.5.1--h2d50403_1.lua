local help_message = [[
This is a module file for the container quay.io/biocontainers/express:1.5.1--h2d50403_1, which exposes the
following programs:

 - express

This container was pulled from:

	https://quay.io/repository/biocontainers/express

If you encounter errors in express or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/express

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: express")
whatis("Version: ctr-1.5.1--h2d50403_1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The express package")
whatis("URL: https://quay.io/repository/biocontainers/express")

set_shell_function("express",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/express/express-1.5.1--h2d50403_1.simg express $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/express/express-1.5.1--h2d50403_1.simg express $*')
