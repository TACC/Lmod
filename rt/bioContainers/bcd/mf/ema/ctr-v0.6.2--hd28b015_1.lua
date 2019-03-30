local help_message = [[
This is a module file for the container quay.io/biocontainers/ema:v0.6.2--hd28b015_1, which exposes the
following programs:

 - ema

This container was pulled from:

	https://quay.io/repository/biocontainers/ema

If you encounter errors in ema or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/ema

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ema")
whatis("Version: ctr-v0.6.2--hd28b015_1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ema package")
whatis("URL: https://quay.io/repository/biocontainers/ema")

set_shell_function("ema",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ema/ema-v0.6.2--hd28b015_1.simg ema $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ema/ema-v0.6.2--hd28b015_1.simg ema $*')
