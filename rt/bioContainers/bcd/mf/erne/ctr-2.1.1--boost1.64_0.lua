local help_message = [[
This is a module file for the container quay.io/biocontainers/erne:2.1.1--boost1.64_0, which exposes the
following programs:

 - easy_install-3.6
 - erne-bs5
 - erne-create
 - erne-filter
 - erne-map
 - erne-meth

This container was pulled from:

	https://quay.io/repository/biocontainers/erne

If you encounter errors in erne or need help running the
tools it contains, please contact the developer at

	http://erne.sourceforge.net

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: erne")
whatis("Version: ctr-2.1.1--boost1.64_0")
whatis("Category: ['Read mapping', 'Bisulfite mapping']")
whatis("Keywords: ['Genomics', 'Sequencing', 'Epigenetics']")
whatis("Description: Extended Randomized Numerical alignEr for accurate alignment of NGS reads. It can map bisulfite-treated reads.")
whatis("URL: https://quay.io/repository/biocontainers/erne")

set_shell_function("easy_install-3.6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg easy_install-3.6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg easy_install-3.6 $*')
set_shell_function("erne-bs5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-bs5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-bs5 $*')
set_shell_function("erne-create",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-create $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-create $*')
set_shell_function("erne-filter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-filter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-filter $*')
set_shell_function("erne-map",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-map $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-map $*')
set_shell_function("erne-meth",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-meth $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/erne/erne-2.1.1--boost1.64_0.simg erne-meth $*')
