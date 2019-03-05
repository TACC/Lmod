local help_message = [[
This is a module file for the container quay.io/biocontainers/elprep:3.04--1, which exposes the
following programs:

 - elprep
 - elprep-sfm-gnupar.py
 - elprep-sfm.py
 - elprep.py
 - elprep_entrypoint.py
 - elprep_im.py
 - elprep_io_wrapper.py
 - elprep_sfm.py
 - elprep_sfm_gnupar.py

This container was pulled from:

	https://quay.io/repository/biocontainers/elprep

If you encounter errors in elprep or need help running the
tools it contains, please contact the developer at

	https://github.com/ExaScience/elprep

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: elprep")
whatis("Version: ctr-3.04--1")
whatis("Category: ['Variant calling']")
whatis("Keywords: ['Sequencing', 'Genetic variation', 'Sequence analysis']")
whatis("Description: Is a high-performance tool for preparing .sam/.bam/.cram files for variant calling in sequencing pipelines.It can be used as a drop-in replacement for SAMtools/Picard, and was extensively tested with different pipelines for variant analysis with GATK.")
whatis("URL: https://quay.io/repository/biocontainers/elprep")

set_shell_function("elprep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep $*')
set_shell_function("elprep-sfm-gnupar.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep-sfm-gnupar.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep-sfm-gnupar.py $*')
set_shell_function("elprep-sfm.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep-sfm.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep-sfm.py $*')
set_shell_function("elprep.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep.py $*')
set_shell_function("elprep_entrypoint.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_entrypoint.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_entrypoint.py $*')
set_shell_function("elprep_im.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_im.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_im.py $*')
set_shell_function("elprep_io_wrapper.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_io_wrapper.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_io_wrapper.py $*')
set_shell_function("elprep_sfm.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_sfm.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_sfm.py $*')
set_shell_function("elprep_sfm_gnupar.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_sfm_gnupar.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/elprep/elprep-3.04--1.simg elprep_sfm_gnupar.py $*')
