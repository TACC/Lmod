local help_message = [[
This is a module file for the container quay.io/biocontainers/easydev:0.9.31--py27_1, which exposes the
following programs:

 - browse
 - easydev_buildPackage
 - ibrowse
 - multigit

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
whatis("Version: ctr-0.9.31--py27_1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The easydev package")
whatis("URL: https://quay.io/repository/biocontainers/easydev")

set_shell_function("browse",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py27_1.simg browse $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py27_1.simg browse $*')
set_shell_function("easydev_buildPackage",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py27_1.simg easydev_buildPackage $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py27_1.simg easydev_buildPackage $*')
set_shell_function("ibrowse",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py27_1.simg ibrowse $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py27_1.simg ibrowse $*')
set_shell_function("multigit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py27_1.simg multigit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/easydev/easydev-0.9.31--py27_1.simg multigit $*')
