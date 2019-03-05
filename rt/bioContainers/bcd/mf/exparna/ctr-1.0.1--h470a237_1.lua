local help_message = [[
This is a module file for the container quay.io/biocontainers/exparna:1.0.1--h470a237_1, which exposes the
following programs:

 - AnalyseDists
 - AnalyseSeqs
 - ExpaRNA
 - Kinfold
 - RNA2Dfold
 - RNALalifold
 - RNALfold
 - RNAPKplex
 - RNAaliduplex
 - RNAalifold
 - RNAcofold
 - RNAdistance
 - RNAduplex
 - RNAeval
 - RNAfold
 - RNAforester
 - RNAheat
 - RNAinverse
 - RNAlocmin
 - RNApaln
 - RNAparconv
 - RNApdist
 - RNAplex
 - RNAplfold
 - RNAplot
 - RNApvmin
 - RNAsnoop
 - RNAsubopt
 - RNAup
 - b2ct
 - ct2db
 - kinwalker
 - popt

This container was pulled from:

	https://quay.io/repository/biocontainers/exparna

If you encounter errors in exparna or need help running the
tools it contains, please contact the developer at

	http://www.bioinf.uni-freiburg.de/Software/#ExpaRNA-download

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: exparna")
whatis("Version: ctr-1.0.1--h470a237_1")
whatis("Category: ['Structure-based sequence alignment']")
whatis("Keywords: ['Sequence analysis']")
whatis("Description: Structure motif based alignment generation.")
whatis("URL: https://quay.io/repository/biocontainers/exparna")

set_shell_function("AnalyseDists",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg AnalyseDists $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg AnalyseDists $*')
set_shell_function("AnalyseSeqs",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg AnalyseSeqs $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg AnalyseSeqs $*')
set_shell_function("ExpaRNA",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg ExpaRNA $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg ExpaRNA $*')
set_shell_function("Kinfold",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg Kinfold $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg Kinfold $*')
set_shell_function("RNA2Dfold",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNA2Dfold $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNA2Dfold $*')
set_shell_function("RNALalifold",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNALalifold $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNALalifold $*')
set_shell_function("RNALfold",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNALfold $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNALfold $*')
set_shell_function("RNAPKplex",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAPKplex $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAPKplex $*')
set_shell_function("RNAaliduplex",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAaliduplex $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAaliduplex $*')
set_shell_function("RNAalifold",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAalifold $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAalifold $*')
set_shell_function("RNAcofold",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAcofold $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAcofold $*')
set_shell_function("RNAdistance",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAdistance $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAdistance $*')
set_shell_function("RNAduplex",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAduplex $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAduplex $*')
set_shell_function("RNAeval",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAeval $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAeval $*')
set_shell_function("RNAfold",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAfold $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAfold $*')
set_shell_function("RNAforester",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAforester $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAforester $*')
set_shell_function("RNAheat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAheat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAheat $*')
set_shell_function("RNAinverse",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAinverse $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAinverse $*')
set_shell_function("RNAlocmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAlocmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAlocmin $*')
set_shell_function("RNApaln",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNApaln $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNApaln $*')
set_shell_function("RNAparconv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAparconv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAparconv $*')
set_shell_function("RNApdist",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNApdist $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNApdist $*')
set_shell_function("RNAplex",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAplex $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAplex $*')
set_shell_function("RNAplfold",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAplfold $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAplfold $*')
set_shell_function("RNAplot",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAplot $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAplot $*')
set_shell_function("RNApvmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNApvmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNApvmin $*')
set_shell_function("RNAsnoop",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAsnoop $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAsnoop $*')
set_shell_function("RNAsubopt",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAsubopt $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAsubopt $*')
set_shell_function("RNAup",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAup $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg RNAup $*')
set_shell_function("b2ct",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg b2ct $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg b2ct $*')
set_shell_function("ct2db",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg ct2db $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg ct2db $*')
set_shell_function("kinwalker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg kinwalker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg kinwalker $*')
set_shell_function("popt",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg popt $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exparna/exparna-1.0.1--h470a237_1.simg popt $*')
