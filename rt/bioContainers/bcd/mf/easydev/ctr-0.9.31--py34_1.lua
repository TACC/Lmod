local help_message = [[
This is a module file for the container quay.io/biocontainers/easydev:0.9.31--py34_1, which exposes the
following programs:

 - 2to3-3.4
 - browse
 - easy_install-3.4
 - easydev_buildPackage
 - ibrowse
 - idle3.4
 - multigit
 - pydoc3.4
 - python3.4
 - python3.4-config
 - python3.4m
 - python3.4m-config
 - pyvenv-3.4

This container was pulled from:

	https://quay.io/repository/biocontainers/easydev

If you encounter errors in easydev or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/easydev

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: easydev")
whatis("Version: ctr-0.9.31--py34_1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The easydev package")
whatis("URL: https://quay.io/repository/biocontainers/easydev")

set_shell_function("2to3-3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg 2to3-3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg 2to3-3.4 $*')
set_shell_function("browse",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg browse $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg browse $*')
set_shell_function("easy_install-3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg easy_install-3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg easy_install-3.4 $*')
set_shell_function("easydev_buildPackage",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg easydev_buildPackage $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg easydev_buildPackage $*')
set_shell_function("ibrowse",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg ibrowse $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg ibrowse $*')
set_shell_function("idle3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg idle3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg idle3.4 $*')
set_shell_function("multigit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg multigit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg multigit $*')
set_shell_function("pydoc3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg pydoc3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg pydoc3.4 $*')
set_shell_function("python3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg python3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg python3.4 $*')
set_shell_function("python3.4-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg python3.4-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg python3.4-config $*')
set_shell_function("python3.4m",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg python3.4m $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg python3.4m $*')
set_shell_function("python3.4m-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg python3.4m-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg python3.4m-config $*')
set_shell_function("pyvenv-3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg pyvenv-3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py34_1.simg pyvenv-3.4 $*')
