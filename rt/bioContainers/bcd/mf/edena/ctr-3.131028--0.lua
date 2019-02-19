local help_message = [[
This is a module file for the container quay.io/biocontainers/edena:3.131028--0, which exposes the
following programs:

 - edena

This container was pulled from:

	https://quay.io/repository/biocontainers/edena

If you encounter errors in edena or need help running the
tools it contains, please contact the developer at

	http://www.genomic.ch/edena

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: edena")
whatis("Version: ctr-3.131028--0")
whatis("Category: ['De-novo assembly', 'Data handling']")
whatis("Keywords: ['Genomics', 'Microbiology', 'Sequence assembly']")
whatis("Description: A program for assembling de novo bacterial genomes from short reads produced by Illumina sequencing platform.")
whatis("URL: https://quay.io/repository/biocontainers/edena")

set_shell_function("edena",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/edena/edena-3.131028--0.simg edena $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/edena/edena-3.131028--0.simg edena $*')
