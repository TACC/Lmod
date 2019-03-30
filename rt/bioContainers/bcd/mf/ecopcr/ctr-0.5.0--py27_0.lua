local help_message = [[
This is a module file for the container quay.io/biocontainers/ecopcr:0.5.0--py27_0, which exposes the
following programs:

 - ecoPCR
 - ecoPCRFilter.py
 - ecoPCRFormat.py
 - ecoSort.py
 - ecofind
 - ecogrep

This container was pulled from:

	https://quay.io/repository/biocontainers/ecopcr

If you encounter errors in ecopcr or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/ecopcr

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ecopcr")
whatis("Version: ctr-0.5.0--py27_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ecopcr package")
whatis("URL: https://quay.io/repository/biocontainers/ecopcr")

set_shell_function("ecoPCR",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecoPCR $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecoPCR $*')
set_shell_function("ecoPCRFilter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecoPCRFilter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecoPCRFilter.py $*')
set_shell_function("ecoPCRFormat.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecoPCRFormat.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecoPCRFormat.py $*')
set_shell_function("ecoSort.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecoSort.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecoSort.py $*')
set_shell_function("ecofind",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecofind $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecofind $*')
set_shell_function("ecogrep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecogrep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_0.simg ecogrep $*')
