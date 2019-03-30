local help_message = [[
This is a module file for the container quay.io/biocontainers/ecopcr:0.5.0--py27_1, which exposes the
following programs:

 - createfontdatachunk.py
 - ecoPCR
 - ecoPCRFilter.py
 - ecoPCRFormat.py
 - ecoSort.py
 - ecofind
 - ecogrep
 - enhancer.py
 - explode.py
 - gifmaker.py
 - painter.py
 - pilconvert.py
 - pildriver.py
 - pilfile.py
 - pilfont.py
 - pilprint.py
 - player.py
 - thresholder.py
 - viewer.py

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
whatis("Version: ctr-0.5.0--py27_1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ecopcr package")
whatis("URL: https://quay.io/repository/biocontainers/ecopcr")

set_shell_function("createfontdatachunk.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg createfontdatachunk.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg createfontdatachunk.py $*')
set_shell_function("ecoPCR",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecoPCR $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecoPCR $*')
set_shell_function("ecoPCRFilter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecoPCRFilter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecoPCRFilter.py $*')
set_shell_function("ecoPCRFormat.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecoPCRFormat.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecoPCRFormat.py $*')
set_shell_function("ecoSort.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecoSort.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecoSort.py $*')
set_shell_function("ecofind",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecofind $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecofind $*')
set_shell_function("ecogrep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecogrep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg ecogrep $*')
set_shell_function("enhancer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg enhancer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg enhancer.py $*')
set_shell_function("explode.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg explode.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg explode.py $*')
set_shell_function("gifmaker.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg gifmaker.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg gifmaker.py $*')
set_shell_function("painter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg painter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg painter.py $*')
set_shell_function("pilconvert.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pilconvert.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pilconvert.py $*')
set_shell_function("pildriver.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pildriver.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pildriver.py $*')
set_shell_function("pilfile.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pilfile.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pilfile.py $*')
set_shell_function("pilfont.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pilfont.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pilfont.py $*')
set_shell_function("pilprint.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pilprint.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg pilprint.py $*')
set_shell_function("player.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg player.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg player.py $*')
set_shell_function("thresholder.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg thresholder.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg thresholder.py $*')
set_shell_function("viewer.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg viewer.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-0.5.0--py27_1.simg viewer.py $*')
