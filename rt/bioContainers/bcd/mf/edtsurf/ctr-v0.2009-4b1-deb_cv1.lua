local help_message = [[
This is a module file for the container biocontainers/edtsurf:v0.2009-4b1-deb_cv1, which exposes the
following programs:

 - EDTSurf

This container was pulled from:

	https://hub.docker.com/r/biocontainers/edtsurf

If you encounter errors in edtsurf or need help running the
tools it contains, please contact the developer at

	https://hub.docker.com/r/biocontainers/edtsurf

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: edtsurf")
whatis("Version: ctr-v0.2009-4b1-deb_cv1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The edtsurf package")
whatis("URL: https://hub.docker.com/r/biocontainers/edtsurf")

set_shell_function("EDTSurf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/edtsurf/edtsurf-v0.2009-4b1-deb_cv1.simg EDTSurf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/edtsurf/edtsurf-v0.2009-4b1-deb_cv1.simg EDTSurf $*')
