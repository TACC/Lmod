local help_message = [[
This is a module file for the container quay.io/biocontainers/eagle:0.9.3.3--py36h24bf2e0_2, which exposes the
following programs:

 - eagle
 - flask
 - gif2h5
 - h52gif
 - h5c++
 - h5cc
 - h5clear
 - h5copy
 - h5debug
 - h5diff
 - h5dump
 - h5fc
 - h5format_convert
 - h5import
 - h5jam
 - h5ls
 - h5mkgrp
 - h5perf_serial
 - h5redeploy
 - h5repack
 - h5repart
 - h5stat
 - h5unjam
 - h5watch
 - vcf_filter.py
 - vcf_melt
 - vcf_sample_filter.py

This container was pulled from:

	https://quay.io/repository/biocontainers/eagle

If you encounter errors in eagle or need help running the
tools it contains, please contact the developer at

	http://bioinformatics.ua.pt/software/eagle/

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: eagle")
whatis("Version: ctr-0.9.3.3--py36h24bf2e0_2")
whatis("Category: ['Sequence feature detection', 'Sequence word comparison']")
whatis("Keywords: ['Genomics', 'Sequencing', 'Virology']")
whatis("Description: EAGLE is an alignment-free method and associated program to compute relative absent words (RAW) in genomic sequences using a reference sequence.")
whatis("URL: https://quay.io/repository/biocontainers/eagle")

set_shell_function("eagle",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg eagle $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg eagle $*')
set_shell_function("flask",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg flask $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg flask $*')
set_shell_function("gif2h5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg gif2h5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg gif2h5 $*')
set_shell_function("h52gif",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h52gif $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h52gif $*')
set_shell_function("h5c++",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5c++ $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5c++ $*')
set_shell_function("h5cc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5cc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5cc $*')
set_shell_function("h5clear",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5clear $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5clear $*')
set_shell_function("h5copy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5copy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5copy $*')
set_shell_function("h5debug",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5debug $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5debug $*')
set_shell_function("h5diff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5diff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5diff $*')
set_shell_function("h5dump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5dump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5dump $*')
set_shell_function("h5fc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5fc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5fc $*')
set_shell_function("h5format_convert",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5format_convert $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5format_convert $*')
set_shell_function("h5import",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5import $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5import $*')
set_shell_function("h5jam",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5jam $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5jam $*')
set_shell_function("h5ls",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5ls $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5ls $*')
set_shell_function("h5mkgrp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5mkgrp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5mkgrp $*')
set_shell_function("h5perf_serial",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5perf_serial $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5perf_serial $*')
set_shell_function("h5redeploy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5redeploy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5redeploy $*')
set_shell_function("h5repack",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5repack $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5repack $*')
set_shell_function("h5repart",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5repart $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5repart $*')
set_shell_function("h5stat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5stat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5stat $*')
set_shell_function("h5unjam",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5unjam $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5unjam $*')
set_shell_function("h5watch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5watch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg h5watch $*')
set_shell_function("vcf_filter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg vcf_filter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg vcf_filter.py $*')
set_shell_function("vcf_melt",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg vcf_melt $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg vcf_melt $*')
set_shell_function("vcf_sample_filter.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg vcf_sample_filter.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eagle/eagle-0.9.3.3--py36h24bf2e0_2.simg vcf_sample_filter.py $*')
