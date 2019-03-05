local help_message = [[
This is a module file for the container quay.io/biocontainers/epic2:0.0.15--py36h4e20536_0, which exposes the
following programs:

 - bcftools
 - color-chrs.pl
 - cygdb
 - cython
 - cythonize
 - epic2
 - guess-ploidy.py
 - natsort
 - ncurses6-config
 - plot-roh.py
 - plot-vcfstats
 - run-roh.pl
 - samtools
 - vcfutils.pl

This container was pulled from:

	https://quay.io/repository/biocontainers/epic2

If you encounter errors in epic2 or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/epic2

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: epic2")
whatis("Version: ctr-0.0.15--py36h4e20536_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The epic2 package")
whatis("URL: https://quay.io/repository/biocontainers/epic2")

set_shell_function("bcftools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg bcftools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg bcftools $*')
set_shell_function("color-chrs.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg color-chrs.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg color-chrs.pl $*')
set_shell_function("cygdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg cygdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg cygdb $*')
set_shell_function("cython",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg cython $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg cython $*')
set_shell_function("cythonize",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg cythonize $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg cythonize $*')
set_shell_function("epic2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg epic2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg epic2 $*')
set_shell_function("guess-ploidy.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg guess-ploidy.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg guess-ploidy.py $*')
set_shell_function("natsort",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg natsort $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg natsort $*')
set_shell_function("ncurses6-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg ncurses6-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg ncurses6-config $*')
set_shell_function("plot-roh.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg plot-roh.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg plot-roh.py $*')
set_shell_function("plot-vcfstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg plot-vcfstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg plot-vcfstats $*')
set_shell_function("run-roh.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg run-roh.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg run-roh.pl $*')
set_shell_function("samtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg samtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg samtools $*')
set_shell_function("vcfutils.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg vcfutils.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic2/epic2-0.0.15--py36h4e20536_0.simg vcfutils.pl $*')
