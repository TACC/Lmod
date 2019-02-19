local help_message = [[
This is a module file for the container quay.io/biocontainers/enasearch:0.1.1--py27_1, which exposes the
following programs:

 - enasearch
 - flake8
 - pycodestyle
 - pyflakes
 - sample

This container was pulled from:

	https://quay.io/repository/biocontainers/enasearch

If you encounter errors in enasearch or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/enasearch

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: enasearch")
whatis("Version: ctr-0.1.1--py27_1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The enasearch package")
whatis("URL: https://quay.io/repository/biocontainers/enasearch")

set_shell_function("enasearch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg enasearch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg enasearch $*')
set_shell_function("flake8",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg flake8 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg flake8 $*')
set_shell_function("pycodestyle",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg pycodestyle $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg pycodestyle $*')
set_shell_function("pyflakes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg pyflakes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg pyflakes $*')
set_shell_function("sample",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg sample $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enasearch/enasearch-0.1.1--py27_1.simg sample $*')
