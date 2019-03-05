local help_message = [[
This is a module file for the container quay.io/biocontainers/extract_genome_region:0.0.3--py36_0, which exposes the
following programs:

 - easy_install-3.6
 - extract_genome_region
 - faidx
 - insserv
 - perl5.20.2
 - udevd

This container was pulled from:

	https://quay.io/repository/biocontainers/extract_genome_region

If you encounter errors in extract_genome_region or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/extract_genome_region

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: extract_genome_region")
whatis("Version: ctr-0.0.3--py36_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The extract_genome_region package")
whatis("URL: https://quay.io/repository/biocontainers/extract_genome_region")

set_shell_function("easy_install-3.6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg easy_install-3.6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg easy_install-3.6 $*')
set_shell_function("extract_genome_region",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg extract_genome_region $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg extract_genome_region $*')
set_shell_function("faidx",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg faidx $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg faidx $*')
set_shell_function("insserv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg insserv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg insserv $*')
set_shell_function("perl5.20.2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg perl5.20.2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg perl5.20.2 $*')
set_shell_function("udevd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg udevd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/extract_genome_region/extract_genome_region-0.0.3--py36_0.simg udevd $*')
