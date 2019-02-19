local help_message = [[
This is a module file for the container biocontainers/ecopcr:v0.5.0dfsg-1-deb_cv1, which exposes the
following programs:

 - createfontdatachunk
 - dh_pypy
 - dh_python3
 - ecoPCR
 - ecoPCRFilter
 - ecoPCRFormat
 - ecoSort
 - ecofind
 - ecogrep
 - ecoisundertaxon
 - enhancer
 - explode
 - gifmaker
 - painter
 - pdb3
 - pdb3.5
 - pilconvert
 - pildriver
 - pilfile
 - pilfont
 - pilprint
 - player
 - py3clean
 - py3compile
 - py3versions
 - pybuild
 - pygettext3
 - pygettext3.5
 - python3m
 - thresholder
 - viewer

This container was pulled from:

	https://hub.docker.com/r/biocontainers/ecopcr

If you encounter errors in ecopcr or need help running the
tools it contains, please contact the developer at

	https://hub.docker.com/r/biocontainers/ecopcr

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ecopcr")
whatis("Version: ctr-v0.5.0dfsg-1-deb_cv1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ecopcr package")
whatis("URL: https://hub.docker.com/r/biocontainers/ecopcr")

set_shell_function("createfontdatachunk",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg createfontdatachunk $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg createfontdatachunk $*')
set_shell_function("dh_pypy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg dh_pypy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg dh_pypy $*')
set_shell_function("dh_python3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg dh_python3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg dh_python3 $*')
set_shell_function("ecoPCR",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoPCR $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoPCR $*')
set_shell_function("ecoPCRFilter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoPCRFilter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoPCRFilter $*')
set_shell_function("ecoPCRFormat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoPCRFormat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoPCRFormat $*')
set_shell_function("ecoSort",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoSort $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoSort $*')
set_shell_function("ecofind",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecofind $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecofind $*')
set_shell_function("ecogrep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecogrep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecogrep $*')
set_shell_function("ecoisundertaxon",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoisundertaxon $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg ecoisundertaxon $*')
set_shell_function("enhancer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg enhancer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg enhancer $*')
set_shell_function("explode",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg explode $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg explode $*')
set_shell_function("gifmaker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg gifmaker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg gifmaker $*')
set_shell_function("painter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg painter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg painter $*')
set_shell_function("pdb3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pdb3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pdb3 $*')
set_shell_function("pdb3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pdb3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pdb3.5 $*')
set_shell_function("pilconvert",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pilconvert $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pilconvert $*')
set_shell_function("pildriver",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pildriver $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pildriver $*')
set_shell_function("pilfile",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pilfile $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pilfile $*')
set_shell_function("pilfont",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pilfont $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pilfont $*')
set_shell_function("pilprint",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pilprint $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pilprint $*')
set_shell_function("player",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg player $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg player $*')
set_shell_function("py3clean",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg py3clean $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg py3clean $*')
set_shell_function("py3compile",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg py3compile $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg py3compile $*')
set_shell_function("py3versions",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg py3versions $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg py3versions $*')
set_shell_function("pybuild",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pybuild $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pybuild $*')
set_shell_function("pygettext3",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pygettext3 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pygettext3 $*')
set_shell_function("pygettext3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pygettext3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg pygettext3.5 $*')
set_shell_function("python3m",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg python3m $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg python3m $*')
set_shell_function("thresholder",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg thresholder $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg thresholder $*')
set_shell_function("viewer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg viewer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopcr/ecopcr-v0.5.0dfsg-1-deb_cv1.simg viewer $*')
