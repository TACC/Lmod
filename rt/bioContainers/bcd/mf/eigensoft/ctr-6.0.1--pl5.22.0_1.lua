local help_message = [[
This is a module file for the container quay.io/biocontainers/eigensoft:6.0.1--pl5.22.0_1, which exposes the
following programs:

 - baseprog
 - convertf
 - eigenstrat
 - eigenstratQTL
 - evec2pca-ped.perl
 - evec2pca.perl
 - fixgreen
 - gc.perl
 - mergeit
 - oldsmartpca
 - pca
 - pcatoy
 - perl5.22.0
 - ploteig
 - smarteigenstrat
 - smarteigenstrat.perl
 - smartpca
 - smartpca.perl
 - smartrel
 - twstats

This container was pulled from:

	https://quay.io/repository/biocontainers/eigensoft

If you encounter errors in eigensoft or need help running the
tools it contains, please contact the developer at

	https://www.hsph.harvard.edu/alkes-price/software/

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: eigensoft")
whatis("Version: ctr-6.0.1--pl5.22.0_1")
whatis("Category: ['Genetic variation analysis']")
whatis("Keywords: ['Population genetics']")
whatis("Description: Combindes functionality from population genetics methods (Patterson et al. 2006) and the EIGENSTRAT correection method (Price et al. 2006). The EIGENSTRAT methods uses principal component analysis to model ancestry differences between cases and controls along continuous axes of variation. The resulting correction is specific to a candidate markers variation in frequency across ancestral populations, minimizing spurious associations while maximising power to detect true associations.")
whatis("URL: https://quay.io/repository/biocontainers/eigensoft")

set_shell_function("baseprog",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg baseprog $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg baseprog $*')
set_shell_function("convertf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg convertf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg convertf $*')
set_shell_function("eigenstrat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg eigenstrat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg eigenstrat $*')
set_shell_function("eigenstratQTL",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg eigenstratQTL $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg eigenstratQTL $*')
set_shell_function("evec2pca-ped.perl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg evec2pca-ped.perl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg evec2pca-ped.perl $*')
set_shell_function("evec2pca.perl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg evec2pca.perl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg evec2pca.perl $*')
set_shell_function("fixgreen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg fixgreen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg fixgreen $*')
set_shell_function("gc.perl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg gc.perl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg gc.perl $*')
set_shell_function("mergeit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg mergeit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg mergeit $*')
set_shell_function("oldsmartpca",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg oldsmartpca $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg oldsmartpca $*')
set_shell_function("pca",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg pca $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg pca $*')
set_shell_function("pcatoy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg pcatoy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg pcatoy $*')
set_shell_function("perl5.22.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg perl5.22.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg perl5.22.0 $*')
set_shell_function("ploteig",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg ploteig $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg ploteig $*')
set_shell_function("smarteigenstrat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smarteigenstrat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smarteigenstrat $*')
set_shell_function("smarteigenstrat.perl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smarteigenstrat.perl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smarteigenstrat.perl $*')
set_shell_function("smartpca",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smartpca $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smartpca $*')
set_shell_function("smartpca.perl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smartpca.perl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smartpca.perl $*')
set_shell_function("smartrel",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smartrel $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg smartrel $*')
set_shell_function("twstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg twstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-6.0.1--pl5.22.0_1.simg twstats $*')
