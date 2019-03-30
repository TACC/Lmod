local help_message = [[
This is a module file for the container quay.io/biocontainers/estscan:3.0--1, which exposes the
following programs:

 - estscan

This container was pulled from:

	https://quay.io/repository/biocontainers/estscan

If you encounter errors in estscan or need help running the
tools it contains, please contact the developer at

	http://myhits.isb-sib.ch/cgi-bin/estscan

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: estscan")
whatis("Version: ctr-3.0--1")
whatis("Category: ['Annotation']")
whatis("Keywords: ['Genomics', 'Transcriptomics']")
whatis("Description: ESTScan can detect coding regions (CDS) in DNA sequences, even if they are of low quality.  It  also detects/corrects sequencing errors that lead to frameshifts.  ESTScan is not a gene prediction program , nor is it an open reading frame detector.  In fact, its strength lies in the fact that it does not require an open reading frame to detect a coding region.  The program may miss a few translated amino acids at termini, but detects coding regions with high selectivity and sensitivity.")
whatis("URL: https://quay.io/repository/biocontainers/estscan")

set_shell_function("estscan",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--1.simg estscan $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estscan/estscan-3.0--1.simg estscan $*')
