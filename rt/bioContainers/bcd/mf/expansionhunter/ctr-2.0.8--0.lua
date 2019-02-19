local help_message = [[
This is a module file for the container quay.io/biocontainers/expansionhunter:2.0.8--0, which exposes the
following programs:

 - ExpansionHunter
 - easy_install-3.6
 - genccode
 - gencmn
 - gennorm2
 - gensprep
 - icupkg
 - uconv

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
whatis("Version: ctr-2.0.8--0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The expansionhunter package")
whatis("URL: https://quay.io/repository/biocontainers/expansionhunter")

set_shell_function("ExpansionHunter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg ExpansionHunter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg ExpansionHunter $*')
set_shell_function("easy_install-3.6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg easy_install-3.6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg easy_install-3.6 $*')
set_shell_function("genccode",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg genccode $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg genccode $*')
set_shell_function("gencmn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg gencmn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg gencmn $*')
set_shell_function("gennorm2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg gennorm2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg gennorm2 $*')
set_shell_function("gensprep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg gensprep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg gensprep $*')
set_shell_function("icupkg",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg icupkg $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg icupkg $*')
set_shell_function("uconv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg uconv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/expansionhunter/expansionhunter-2.0.8--0.simg uconv $*')
