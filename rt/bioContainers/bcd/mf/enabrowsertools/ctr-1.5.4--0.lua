local help_message = [[
This is a module file for the container quay.io/biocontainers/enabrowsertools:1.5.4--0, which exposes the
following programs:

 - 2to3-3.7
 - assemblyGet.py
 - enaDataGet
 - enaDataGet.py
 - enaGroupGet
 - enaGroupGet.py
 - idle3.7
 - ncurses6-config
 - pydoc3.7
 - python3.7
 - python3.7-config
 - python3.7m
 - python3.7m-config
 - pyvenv-3.7
 - readGet.py
 - sequenceGet.py
 - utils.py
 - utils_py2.py

This container was pulled from:

	https://quay.io/repository/biocontainers/enabrowsertools

If you encounter errors in enabrowsertools or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/enabrowsertools

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: enabrowsertools")
whatis("Version: ctr-1.5.4--0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The enabrowsertools package")
whatis("URL: https://quay.io/repository/biocontainers/enabrowsertools")

set_shell_function("2to3-3.7",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg 2to3-3.7 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg 2to3-3.7 $*')
set_shell_function("assemblyGet.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg assemblyGet.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg assemblyGet.py $*')
set_shell_function("enaDataGet",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg enaDataGet $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg enaDataGet $*')
set_shell_function("enaDataGet.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg enaDataGet.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg enaDataGet.py $*')
set_shell_function("enaGroupGet",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg enaGroupGet $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg enaGroupGet $*')
set_shell_function("enaGroupGet.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg enaGroupGet.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg enaGroupGet.py $*')
set_shell_function("idle3.7",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg idle3.7 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg idle3.7 $*')
set_shell_function("ncurses6-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg ncurses6-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg ncurses6-config $*')
set_shell_function("pydoc3.7",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg pydoc3.7 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg pydoc3.7 $*')
set_shell_function("python3.7",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg python3.7 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg python3.7 $*')
set_shell_function("python3.7-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg python3.7-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg python3.7-config $*')
set_shell_function("python3.7m",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg python3.7m $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg python3.7m $*')
set_shell_function("python3.7m-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg python3.7m-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg python3.7m-config $*')
set_shell_function("pyvenv-3.7",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg pyvenv-3.7 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg pyvenv-3.7 $*')
set_shell_function("readGet.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg readGet.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg readGet.py $*')
set_shell_function("sequenceGet.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg sequenceGet.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg sequenceGet.py $*')
set_shell_function("utils.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg utils.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg utils.py $*')
set_shell_function("utils_py2.py",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg utils_py2.py $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/enabrowsertools/enabrowsertools-1.5.4--0.simg utils_py2.py $*')
