local help_message = [[
This is a module file for the container quay.io/biocontainers/ebisearch:0.0.3--py27_0, which exposes the
following programs:

 - ebi_metagenomics
 - ebisearch
 - flake8
 - pycodestyle
 - pyflakes

This container was pulled from:

	https://quay.io/repository/biocontainers/ebisearch

If you encounter errors in ebisearch or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/ebisearch

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ebisearch")
whatis("Version: ctr-0.0.3--py27_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ebisearch package")
whatis("URL: https://quay.io/repository/biocontainers/ebisearch")

set_shell_function("ebi_metagenomics",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg ebi_metagenomics $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg ebi_metagenomics $*')
set_shell_function("ebisearch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg ebisearch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg ebisearch $*')
set_shell_function("flake8",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg flake8 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg flake8 $*')
set_shell_function("pycodestyle",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg pycodestyle $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg pycodestyle $*')
set_shell_function("pyflakes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg pyflakes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ebisearch/ebisearch-0.0.3--py27_0.simg pyflakes $*')
