local help_message = [[
This is a module file for the container quay.io/biocontainers/eqtlbma:1.3.1--r3.4.1_2, which exposes the
following programs:

 - .bioconductor-genomeinfodbdata-post-link.sh
 - .bioconductor-genomeinfodbdata-pre-unlink.sh
 - .r-base-post-link.sh
 - R
 - Rscript
 - eqtlbma_avg_bfs
 - eqtlbma_bf
 - eqtlbma_bf_parallel.bash
 - eqtlbma_hm
 - ksu
 - tutorial_eqtlbma.R
 - utils_eqtlbma.R

This container was pulled from:

	https://quay.io/repository/biocontainers/eqtlbma

If you encounter errors in eqtlbma or need help running the
tools it contains, please contact the developer at

	https://github.com/timflutre/eqtlbma/wiki

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: eqtlbma")
whatis("Version: ctr-1.3.1--r3.4.1_2")
whatis("Category: ['Gene expression QTL analysis', 'Genetic mapping']")
whatis("Keywords: ['Mapping']")
whatis("Description: eQtlBma: software to detect eQTLs by Bayesian Model Averaging. The software detects quantitative trait loci for gene expression levels ("eQTLs") jointly in multiple subgroups (e.g. multiple tissues).")
whatis("URL: https://quay.io/repository/biocontainers/eqtlbma")

set_shell_function(".bioconductor-genomeinfodbdata-post-link.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg .bioconductor-genomeinfodbdata-post-link.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg .bioconductor-genomeinfodbdata-post-link.sh $*')
set_shell_function(".bioconductor-genomeinfodbdata-pre-unlink.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg .bioconductor-genomeinfodbdata-pre-unlink.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg .bioconductor-genomeinfodbdata-pre-unlink.sh $*')
set_shell_function(".r-base-post-link.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg .r-base-post-link.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg .r-base-post-link.sh $*')
set_shell_function("R",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg R $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg R $*')
set_shell_function("Rscript",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg Rscript $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg Rscript $*')
set_shell_function("eqtlbma_avg_bfs",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg eqtlbma_avg_bfs $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg eqtlbma_avg_bfs $*')
set_shell_function("eqtlbma_bf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg eqtlbma_bf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg eqtlbma_bf $*')
set_shell_function("eqtlbma_bf_parallel.bash",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg eqtlbma_bf_parallel.bash $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg eqtlbma_bf_parallel.bash $*')
set_shell_function("eqtlbma_hm",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg eqtlbma_hm $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg eqtlbma_hm $*')
set_shell_function("ksu",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg ksu $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg ksu $*')
set_shell_function("tutorial_eqtlbma.R",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg tutorial_eqtlbma.R $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg tutorial_eqtlbma.R $*')
set_shell_function("utils_eqtlbma.R",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg utils_eqtlbma.R $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eqtlbma/eqtlbma-1.3.1--r3.4.1_2.simg utils_eqtlbma.R $*')
