local help_message = [[
This is a module file for the container quay.io/biocontainers/easydev:0.9.14--py35_1, which exposes the
following programs:

 - browse
 - easy_install-3.5
 - easydev_buildPackage
 - ibrowse
 - idle3.5
 - multigit
 - python3.5-config
 - python3.5m-config
 - pyvenv-3.5

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
whatis("Version: ctr-0.9.14--py35_1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The easydev package")
whatis("URL: https://quay.io/repository/biocontainers/easydev")

set_shell_function("browse",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg browse $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg browse $*')
set_shell_function("easy_install-3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg easy_install-3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg easy_install-3.5 $*')
set_shell_function("easydev_buildPackage",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg easydev_buildPackage $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg easydev_buildPackage $*')
set_shell_function("ibrowse",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg ibrowse $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg ibrowse $*')
set_shell_function("idle3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg idle3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg idle3.5 $*')
set_shell_function("multigit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg multigit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg multigit $*')
set_shell_function("python3.5-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg python3.5-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg python3.5-config $*')
set_shell_function("python3.5m-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg python3.5m-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg python3.5m-config $*')
set_shell_function("pyvenv-3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg pyvenv-3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.14--py35_1.simg pyvenv-3.5 $*')
