local help_message = [[
This is a module file for the container quay.io/biocontainers/evidencemodeler:1.1.1--0, which exposes the
following programs:

 - evidence_modeler.pl
 - perl5.26.2

This container was pulled from:

	https://quay.io/repository/biocontainers/evidencemodeler

If you encounter errors in evidencemodeler or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/evidencemodeler

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: evidencemodeler")
whatis("Version: ctr-1.1.1--0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The evidencemodeler package")
whatis("URL: https://quay.io/repository/biocontainers/evidencemodeler")

set_shell_function("evidence_modeler.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/evidencemodeler/evidencemodeler-1.1.1--0.simg evidence_modeler.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/evidencemodeler/evidencemodeler-1.1.1--0.simg evidence_modeler.pl $*')
set_shell_function("perl5.26.2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/evidencemodeler/evidencemodeler-1.1.1--0.simg perl5.26.2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/evidencemodeler/evidencemodeler-1.1.1--0.simg perl5.26.2 $*')
