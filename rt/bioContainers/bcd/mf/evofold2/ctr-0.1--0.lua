local help_message = [[
This is a module file for the container quay.io/biocontainers/evofold2:0.1--0, which exposes the
following programs:

 - EvoFoldV2
 - EvoFoldV2.sh
 - dfgEval
 - dfgTrain
 - grammarTrain
 - multinomial

This container was pulled from:

	https://quay.io/repository/biocontainers/evofold2

If you encounter errors in evofold2 or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/evofold2

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: evofold2")
whatis("Version: ctr-0.1--0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The evofold2 package")
whatis("URL: https://quay.io/repository/biocontainers/evofold2")

set_shell_function("EvoFoldV2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg EvoFoldV2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg EvoFoldV2 $*')
set_shell_function("EvoFoldV2.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg EvoFoldV2.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg EvoFoldV2.sh $*')
set_shell_function("dfgEval",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg dfgEval $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg dfgEval $*')
set_shell_function("dfgTrain",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg dfgTrain $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg dfgTrain $*')
set_shell_function("grammarTrain",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg grammarTrain $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg grammarTrain $*')
set_shell_function("multinomial",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg multinomial $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/evofold2/evofold2-0.1--0.simg multinomial $*')
