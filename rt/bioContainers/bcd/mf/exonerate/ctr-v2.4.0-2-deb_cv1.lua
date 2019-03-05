local help_message = [[
This is a module file for the container biocontainers/exonerate:v2.4.0-2-deb_cv1, which exposes the
following programs:

 - esd2esi
 - exonerate
 - exonerate-server
 - fasta2esd
 - fastaannotatecdna
 - fastachecksum
 - fastaclean
 - fastaclip
 - fastacomposition
 - fastadiff
 - fastaexplode
 - fastafetch
 - fastahardmask
 - fastaindex
 - fastalength
 - fastanrdb
 - fastaoverlap
 - fastareformat
 - fastaremove
 - fastarevcomp
 - fastasoftmask
 - fastasort
 - fastasplit
 - fastasubseq
 - fastatranslate
 - fastavalidcds
 - ipcress

This container was pulled from:

	https://hub.docker.com/r/biocontainers/exonerate

If you encounter errors in exonerate or need help running the
tools it contains, please contact the developer at

	http://www.ebi.ac.uk/%7Eguy/exonerate

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: exonerate")
whatis("Version: ctr-v2.4.0-2-deb_cv1")
whatis("Category: ['Pairwise sequence alignment', 'Protein threading', 'Genome alignment']")
whatis("Keywords: ['Sequence analysis', 'Sequence sites, features and motifs', 'Molecular interactions, pathways and networks']")
whatis("Description: A tool for pairwise sequence alignment. It enables alignment for DNA-DNA and DNA-protein pairs and also gapped and ungapped alignment.")
whatis("URL: https://hub.docker.com/r/biocontainers/exonerate")

set_shell_function("esd2esi",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg esd2esi $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg esd2esi $*')
set_shell_function("exonerate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg exonerate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg exonerate $*')
set_shell_function("exonerate-server",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg exonerate-server $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg exonerate-server $*')
set_shell_function("fasta2esd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fasta2esd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fasta2esd $*')
set_shell_function("fastaannotatecdna",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaannotatecdna $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaannotatecdna $*')
set_shell_function("fastachecksum",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastachecksum $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastachecksum $*')
set_shell_function("fastaclean",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaclean $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaclean $*')
set_shell_function("fastaclip",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaclip $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaclip $*')
set_shell_function("fastacomposition",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastacomposition $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastacomposition $*')
set_shell_function("fastadiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastadiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastadiff $*')
set_shell_function("fastaexplode",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaexplode $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaexplode $*')
set_shell_function("fastafetch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastafetch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastafetch $*')
set_shell_function("fastahardmask",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastahardmask $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastahardmask $*')
set_shell_function("fastaindex",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaindex $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaindex $*')
set_shell_function("fastalength",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastalength $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastalength $*')
set_shell_function("fastanrdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastanrdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastanrdb $*')
set_shell_function("fastaoverlap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaoverlap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaoverlap $*')
set_shell_function("fastareformat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastareformat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastareformat $*')
set_shell_function("fastaremove",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaremove $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastaremove $*')
set_shell_function("fastarevcomp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastarevcomp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastarevcomp $*')
set_shell_function("fastasoftmask",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastasoftmask $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastasoftmask $*')
set_shell_function("fastasort",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastasort $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastasort $*')
set_shell_function("fastasplit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastasplit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastasplit $*')
set_shell_function("fastasubseq",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastasubseq $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastasubseq $*')
set_shell_function("fastatranslate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastatranslate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastatranslate $*')
set_shell_function("fastavalidcds",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastavalidcds $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg fastavalidcds $*')
set_shell_function("ipcress",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg ipcress $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/exonerate/exonerate-v2.4.0-2-deb_cv1.simg ipcress $*')
