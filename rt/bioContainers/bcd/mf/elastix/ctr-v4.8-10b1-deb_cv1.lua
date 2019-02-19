local help_message = [[
This is a module file for the container biocontainers/elastix:v4.8-10b1-deb_cv1, which exposes the
following programs:

 - elastix
 - transformix

This container was pulled from:

	https://hub.docker.com/r/biocontainers/elastix

If you encounter errors in elastix or need help running the
tools it contains, please contact the developer at

	https://hub.docker.com/r/biocontainers/elastix

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: elastix")
whatis("Version: ctr-v4.8-10b1-deb_cv1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The elastix package")
whatis("URL: https://hub.docker.com/r/biocontainers/elastix")

set_shell_function("elastix",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elastix/elastix-v4.8-10b1-deb_cv1.simg elastix $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elastix/elastix-v4.8-10b1-deb_cv1.simg elastix $*')
set_shell_function("transformix",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elastix/elastix-v4.8-10b1-deb_cv1.simg transformix $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elastix/elastix-v4.8-10b1-deb_cv1.simg transformix $*')
