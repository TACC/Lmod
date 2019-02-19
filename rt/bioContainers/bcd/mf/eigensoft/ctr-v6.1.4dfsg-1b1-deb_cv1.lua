local help_message = [[
This is a module file for the container biocontainers/eigensoft:v6.1.4dfsg-1b1-deb_cv1, which exposes the
following programs:

 - baseprog
 - broadwayd
 - convertf
 - eigenstrat
 - eigenstratQTL
 - evec2pca
 - evec2pca-ped
 - gc-eigensoft
 - glxdemo
 - glxgears
 - glxheads
 - glxinfo
 - gnuplot
 - gnuplot-qt
 - gtk-builder-tool
 - gtk-launch
 - gtk-query-settings
 - libwacom-list-local-devices
 - mergeit
 - pca
 - pcaselection
 - pcatoy
 - ploteig
 - smarteigenstrat
 - smartpca
 - smartrel
 - twstats

This container was pulled from:

	https://hub.docker.com/r/biocontainers/eigensoft

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
whatis("Version: ctr-v6.1.4dfsg-1b1-deb_cv1")
whatis("Category: ['Genetic variation analysis']")
whatis("Keywords: ['Population genetics']")
whatis("Description: Combindes functionality from population genetics methods (Patterson et al. 2006) and the EIGENSTRAT correection method (Price et al. 2006). The EIGENSTRAT methods uses principal component analysis to model ancestry differences between cases and controls along continuous axes of variation. The resulting correction is specific to a candidate markers variation in frequency across ancestral populations, minimizing spurious associations while maximising power to detect true associations.")
whatis("URL: https://hub.docker.com/r/biocontainers/eigensoft")

set_shell_function("baseprog",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg baseprog $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg baseprog $*')
set_shell_function("broadwayd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg broadwayd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg broadwayd $*')
set_shell_function("convertf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg convertf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg convertf $*')
set_shell_function("eigenstrat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg eigenstrat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg eigenstrat $*')
set_shell_function("eigenstratQTL",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg eigenstratQTL $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg eigenstratQTL $*')
set_shell_function("evec2pca",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg evec2pca $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg evec2pca $*')
set_shell_function("evec2pca-ped",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg evec2pca-ped $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg evec2pca-ped $*')
set_shell_function("gc-eigensoft",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gc-eigensoft $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gc-eigensoft $*')
set_shell_function("glxdemo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg glxdemo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg glxdemo $*')
set_shell_function("glxgears",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg glxgears $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg glxgears $*')
set_shell_function("glxheads",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg glxheads $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg glxheads $*')
set_shell_function("glxinfo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg glxinfo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg glxinfo $*')
set_shell_function("gnuplot",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gnuplot $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gnuplot $*')
set_shell_function("gnuplot-qt",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gnuplot-qt $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gnuplot-qt $*')
set_shell_function("gtk-builder-tool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gtk-builder-tool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gtk-builder-tool $*')
set_shell_function("gtk-launch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gtk-launch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gtk-launch $*')
set_shell_function("gtk-query-settings",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gtk-query-settings $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg gtk-query-settings $*')
set_shell_function("libwacom-list-local-devices",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg libwacom-list-local-devices $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg libwacom-list-local-devices $*')
set_shell_function("mergeit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg mergeit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg mergeit $*')
set_shell_function("pca",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg pca $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg pca $*')
set_shell_function("pcaselection",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg pcaselection $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg pcaselection $*')
set_shell_function("pcatoy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg pcatoy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg pcatoy $*')
set_shell_function("ploteig",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg ploteig $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg ploteig $*')
set_shell_function("smarteigenstrat",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg smarteigenstrat $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg smarteigenstrat $*')
set_shell_function("smartpca",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg smartpca $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg smartpca $*')
set_shell_function("smartrel",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg smartrel $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg smartrel $*')
set_shell_function("twstats",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg twstats $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/eigensoft/eigensoft-v6.1.4dfsg-1b1-deb_cv1.simg twstats $*')
