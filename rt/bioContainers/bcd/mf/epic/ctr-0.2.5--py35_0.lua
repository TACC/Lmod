local help_message = [[
This is a module file for the container quay.io/biocontainers/epic:0.2.5--py35_0, which exposes the
following programs:

 - annotateBed
 - bamToBed
 - bamToFastq
 - bed12ToBed6
 - bedToBam
 - bedToIgv
 - bedpeToBam
 - bedtools
 - closestBed
 - clusterBed
 - complementBed
 - coverageBed
 - easy_install-3.5
 - epic
 - epic-blacklist
 - epic-cluster
 - epic-count
 - epic-effective
 - epic-merge
 - epic-overlaps
 - expandCols
 - faidx
 - fastaFromBed
 - flankBed
 - genomeCoverageBed
 - getOverlap
 - groupBy
 - idle3.5
 - intersectBed
 - ksu
 - linksBed
 - mapBed
 - maskFastaFromBed
 - mergeBed
 - multiBamCov
 - multiIntersectBed
 - natsort
 - nucBed
 - pairToBed
 - pairToPair
 - python3.5-config
 - python3.5m-config
 - pyvenv-3.5
 - randomBed
 - shiftBed
 - shuffleBed
 - slopBed
 - sortBed
 - subtractBed
 - tagBam
 - unionBedGraphs
 - windowBed
 - windowMaker

This container was pulled from:

	https://quay.io/repository/biocontainers/epic

If you encounter errors in epic or need help running the
tools it contains, please contact the developer at

	http://e-p-i-c.sourceforge.net/

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: epic")
whatis("Version: ctr-0.2.5--py35_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: EPIC is an open source Perl IDE based on the Eclipse platform.
Features supported are syntax highlighting, on-the-fly syntax check, content assist, perldoc support, source formatter, templating support and a Perl debugger.
A regular expression plugin and support for the eSpell spellchecker are also available.")
whatis("URL: https://quay.io/repository/biocontainers/epic")

set_shell_function("annotateBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg annotateBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg annotateBed $*')
set_shell_function("bamToBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bamToBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bamToBed $*')
set_shell_function("bamToFastq",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bamToFastq $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bamToFastq $*')
set_shell_function("bed12ToBed6",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bed12ToBed6 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bed12ToBed6 $*')
set_shell_function("bedToBam",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bedToBam $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bedToBam $*')
set_shell_function("bedToIgv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bedToIgv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bedToIgv $*')
set_shell_function("bedpeToBam",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bedpeToBam $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bedpeToBam $*')
set_shell_function("bedtools",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bedtools $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg bedtools $*')
set_shell_function("closestBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg closestBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg closestBed $*')
set_shell_function("clusterBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg clusterBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg clusterBed $*')
set_shell_function("complementBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg complementBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg complementBed $*')
set_shell_function("coverageBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg coverageBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg coverageBed $*')
set_shell_function("easy_install-3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg easy_install-3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg easy_install-3.5 $*')
set_shell_function("epic",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic $*')
set_shell_function("epic-blacklist",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-blacklist $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-blacklist $*')
set_shell_function("epic-cluster",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-cluster $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-cluster $*')
set_shell_function("epic-count",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-count $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-count $*')
set_shell_function("epic-effective",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-effective $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-effective $*')
set_shell_function("epic-merge",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-merge $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-merge $*')
set_shell_function("epic-overlaps",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-overlaps $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg epic-overlaps $*')
set_shell_function("expandCols",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg expandCols $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg expandCols $*')
set_shell_function("faidx",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg faidx $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg faidx $*')
set_shell_function("fastaFromBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg fastaFromBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg fastaFromBed $*')
set_shell_function("flankBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg flankBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg flankBed $*')
set_shell_function("genomeCoverageBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg genomeCoverageBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg genomeCoverageBed $*')
set_shell_function("getOverlap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg getOverlap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg getOverlap $*')
set_shell_function("groupBy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg groupBy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg groupBy $*')
set_shell_function("idle3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg idle3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg idle3.5 $*')
set_shell_function("intersectBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg intersectBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg intersectBed $*')
set_shell_function("ksu",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg ksu $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg ksu $*')
set_shell_function("linksBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg linksBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg linksBed $*')
set_shell_function("mapBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg mapBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg mapBed $*')
set_shell_function("maskFastaFromBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg maskFastaFromBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg maskFastaFromBed $*')
set_shell_function("mergeBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg mergeBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg mergeBed $*')
set_shell_function("multiBamCov",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg multiBamCov $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg multiBamCov $*')
set_shell_function("multiIntersectBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg multiIntersectBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg multiIntersectBed $*')
set_shell_function("natsort",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg natsort $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg natsort $*')
set_shell_function("nucBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg nucBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg nucBed $*')
set_shell_function("pairToBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg pairToBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg pairToBed $*')
set_shell_function("pairToPair",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg pairToPair $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg pairToPair $*')
set_shell_function("python3.5-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg python3.5-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg python3.5-config $*')
set_shell_function("python3.5m-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg python3.5m-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg python3.5m-config $*')
set_shell_function("pyvenv-3.5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg pyvenv-3.5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg pyvenv-3.5 $*')
set_shell_function("randomBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg randomBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg randomBed $*')
set_shell_function("shiftBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg shiftBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg shiftBed $*')
set_shell_function("shuffleBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg shuffleBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg shuffleBed $*')
set_shell_function("slopBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg slopBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg slopBed $*')
set_shell_function("sortBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg sortBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg sortBed $*')
set_shell_function("subtractBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg subtractBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg subtractBed $*')
set_shell_function("tagBam",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg tagBam $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg tagBam $*')
set_shell_function("unionBedGraphs",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg unionBedGraphs $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg unionBedGraphs $*')
set_shell_function("windowBed",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg windowBed $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg windowBed $*')
set_shell_function("windowMaker",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg windowMaker $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/epic/epic-0.2.5--py35_0.simg windowMaker $*')
