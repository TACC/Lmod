local help_message = [[
This is a module file for the container quay.io/biocontainers/emperor:0.9.3--py27_0, which exposes the
following programs:

 - make_emperor.py
 - qcli_make_rst
 - qcli_make_script

This container was pulled from:

	https://quay.io/repository/biocontainers/emperor

If you encounter errors in emperor or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/emperor

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: emperor")
whatis("Version: ctr-0.9.3--py27_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The emperor package")
whatis("URL: https://quay.io/repository/biocontainers/emperor")

set_shell_function("make_emperor.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emperor/emperor-0.9.3--py27_0.simg make_emperor.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emperor/emperor-0.9.3--py27_0.simg make_emperor.py $*')
set_shell_function("qcli_make_rst",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emperor/emperor-0.9.3--py27_0.simg qcli_make_rst $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emperor/emperor-0.9.3--py27_0.simg qcli_make_rst $*')
set_shell_function("qcli_make_script",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/emperor/emperor-0.9.3--py27_0.simg qcli_make_script $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/emperor/emperor-0.9.3--py27_0.simg qcli_make_script $*')
