local help_message = [[
This is a module file for the container quay.io/biocontainers/estmapper:2008--py34pl5.22.0_0, which exposes the
following programs:

 - 2to3-3.4
 - ESTmapper.pl
 - cleanPolishes
 - comparePolishes
 - configureESTmapper.pl
 - convertPolishes
 - convertToAtac
 - convertToExtent
 - depthOfPolishes
 - detectChimera
 - easy_install-3.4
 - existDB
 - filterEST
 - filterESTsimple
 - filterMRNA
 - filterNULL
 - filterPolishes
 - filtertest
 - fixPolishesIID
 - headPolishes
 - hitConverter
 - idle3.4
 - kmer-mask
 - leaff
 - mapMers
 - mapMers-depth
 - mappedCoverage
 - mergeCounts
 - mergePolishes
 - meryl
 - mt19937ar-test
 - parseSNP
 - perl5.22.0
 - pickBestPair
 - pickBestPolish
 - pickUniquePolish
 - plotCoverageVsIdentity
 - positionDB
 - pydoc3.4
 - python3.4
 - python3.4-config
 - python3.4m
 - python3.4m-config
 - pyvenv-3.4
 - realignPolishes
 - removeDuplicate
 - removeRedundant
 - reportAlignmentDifferences
 - runConcurrently.pl
 - seagen
 - sim4db
 - simple
 - sortHits
 - sortPolishes
 - summarizePolishes
 - terminate
 - test-merStream
 - test-seqCache
 - test-seqStream
 - uniqPolishes
 - vennPolishes

This container was pulled from:

	https://quay.io/repository/biocontainers/estmapper

If you encounter errors in estmapper or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/estmapper

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: estmapper")
whatis("Version: ctr-2008--py34pl5.22.0_0")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The estmapper package")
whatis("URL: https://quay.io/repository/biocontainers/estmapper")

set_shell_function("2to3-3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg 2to3-3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg 2to3-3.4 $*')
set_shell_function("ESTmapper.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg ESTmapper.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg ESTmapper.pl $*')
set_shell_function("cleanPolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg cleanPolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg cleanPolishes $*')
set_shell_function("comparePolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg comparePolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg comparePolishes $*')
set_shell_function("configureESTmapper.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg configureESTmapper.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg configureESTmapper.pl $*')
set_shell_function("convertPolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg convertPolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg convertPolishes $*')
set_shell_function("convertToAtac",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg convertToAtac $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg convertToAtac $*')
set_shell_function("convertToExtent",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg convertToExtent $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg convertToExtent $*')
set_shell_function("depthOfPolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg depthOfPolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg depthOfPolishes $*')
set_shell_function("detectChimera",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg detectChimera $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg detectChimera $*')
set_shell_function("easy_install-3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg easy_install-3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg easy_install-3.4 $*')
set_shell_function("existDB",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg existDB $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg existDB $*')
set_shell_function("filterEST",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterEST $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterEST $*')
set_shell_function("filterESTsimple",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterESTsimple $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterESTsimple $*')
set_shell_function("filterMRNA",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterMRNA $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterMRNA $*')
set_shell_function("filterNULL",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterNULL $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterNULL $*')
set_shell_function("filterPolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterPolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filterPolishes $*')
set_shell_function("filtertest",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filtertest $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg filtertest $*')
set_shell_function("fixPolishesIID",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg fixPolishesIID $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg fixPolishesIID $*')
set_shell_function("headPolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg headPolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg headPolishes $*')
set_shell_function("hitConverter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg hitConverter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg hitConverter $*')
set_shell_function("idle3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg idle3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg idle3.4 $*')
set_shell_function("kmer-mask",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg kmer-mask $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg kmer-mask $*')
set_shell_function("leaff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg leaff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg leaff $*')
set_shell_function("mapMers",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mapMers $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mapMers $*')
set_shell_function("mapMers-depth",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mapMers-depth $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mapMers-depth $*')
set_shell_function("mappedCoverage",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mappedCoverage $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mappedCoverage $*')
set_shell_function("mergeCounts",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mergeCounts $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mergeCounts $*')
set_shell_function("mergePolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mergePolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mergePolishes $*')
set_shell_function("meryl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg meryl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg meryl $*')
set_shell_function("mt19937ar-test",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mt19937ar-test $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg mt19937ar-test $*')
set_shell_function("parseSNP",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg parseSNP $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg parseSNP $*')
set_shell_function("perl5.22.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg perl5.22.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg perl5.22.0 $*')
set_shell_function("pickBestPair",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pickBestPair $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pickBestPair $*')
set_shell_function("pickBestPolish",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pickBestPolish $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pickBestPolish $*')
set_shell_function("pickUniquePolish",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pickUniquePolish $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pickUniquePolish $*')
set_shell_function("plotCoverageVsIdentity",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg plotCoverageVsIdentity $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg plotCoverageVsIdentity $*')
set_shell_function("positionDB",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg positionDB $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg positionDB $*')
set_shell_function("pydoc3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pydoc3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pydoc3.4 $*')
set_shell_function("python3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg python3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg python3.4 $*')
set_shell_function("python3.4-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg python3.4-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg python3.4-config $*')
set_shell_function("python3.4m",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg python3.4m $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg python3.4m $*')
set_shell_function("python3.4m-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg python3.4m-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg python3.4m-config $*')
set_shell_function("pyvenv-3.4",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pyvenv-3.4 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg pyvenv-3.4 $*')
set_shell_function("realignPolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg realignPolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg realignPolishes $*')
set_shell_function("removeDuplicate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg removeDuplicate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg removeDuplicate $*')
set_shell_function("removeRedundant",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg removeRedundant $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg removeRedundant $*')
set_shell_function("reportAlignmentDifferences",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg reportAlignmentDifferences $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg reportAlignmentDifferences $*')
set_shell_function("runConcurrently.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg runConcurrently.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg runConcurrently.pl $*')
set_shell_function("seagen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg seagen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg seagen $*')
set_shell_function("sim4db",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg sim4db $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg sim4db $*')
set_shell_function("simple",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg simple $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg simple $*')
set_shell_function("sortHits",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg sortHits $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg sortHits $*')
set_shell_function("sortPolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg sortPolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg sortPolishes $*')
set_shell_function("summarizePolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg summarizePolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg summarizePolishes $*')
set_shell_function("terminate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg terminate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg terminate $*')
set_shell_function("test-merStream",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg test-merStream $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg test-merStream $*')
set_shell_function("test-seqCache",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg test-seqCache $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg test-seqCache $*')
set_shell_function("test-seqStream",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg test-seqStream $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg test-seqStream $*')
set_shell_function("uniqPolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg uniqPolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg uniqPolishes $*')
set_shell_function("vennPolishes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg vennPolishes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/estmapper/estmapper-2008--py34pl5.22.0_0.simg vennPolishes $*')
