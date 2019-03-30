local help_message = [[
This is a module file for the container quay.io/biocontainers/expansionhunter:2.0.8--hf66f9d2_1, which exposes the
following programs:

 - ExpansionHunter

This container was pulled from:

	https://quay.io/repository/biocontainers/expansionhunter

If you encounter errors in expansionhunter or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/expansionhunter

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: expansionhunter")
whatis("Version: ctr-2.0.8--hf66f9d2_1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The expansionhunter package")
whatis("URL: https://quay.io/repository/biocontainers/expansionhunter")

set_shell_function("ExpansionHunter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--hf66f9d2_1.simg ExpansionHunter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--hf66f9d2_1.simg ExpansionHunter $*')
