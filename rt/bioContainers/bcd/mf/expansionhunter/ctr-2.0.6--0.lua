local help_message = [[
This is a module file for the container quay.io/biocontainers/expansionhunter:2.0.6--0, which exposes the
following programs:

 - ExpansionHunter
 - easy_install-3.5
 - idle3.5
 - python3.5-config
 - python3.5m-config
 - pyvenv-3.5

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
whatis("Version: ctr-2.0.6--0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The expansionhunter package")
whatis("URL: https://quay.io/repository/biocontainers/expansionhunter")

set_shell_function("ExpansionHunter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg ExpansionHunter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg ExpansionHunter $*')
set_shell_function("easy_install-3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg easy_install-3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg easy_install-3.5 $*')
set_shell_function("idle3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg idle3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg idle3.5 $*')
set_shell_function("python3.5-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg python3.5-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg python3.5-config $*')
set_shell_function("python3.5m-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg python3.5m-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg python3.5m-config $*')
set_shell_function("pyvenv-3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg pyvenv-3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.6--0.simg pyvenv-3.5 $*')
