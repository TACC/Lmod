local help_message = [[
This is a module file for the container biocontainers/ecomet:phenomenal-v1.1_cv0.3.39, which exposes the
following programs:

 - R
 - Rscript
 - X
 - Xorg
 - accessdb
 - appres
 - apropos
 - atobm
 - bdftopcf
 - bdftruncate
 - bitmap
 - blankfilter.r
 - bmtoa
 - browse
 - bsd-from
 - bsd-write
 - calendar
 - cameraToFeatureXML.r
 - catman
 - consensusXMLToXcms.r
 - cvt
 - dh_xsf_substvars
 - dilutionfilter.r
 - editres
 - eqn
 - f77
 - f95
 - featureXMLToCAMERA.r
 - featureXMLToXcms.r
 - filenameextractor.r
 - fillPeaks.r
 - findAdducts.r
 - findIsotopes.r
 - findPeaks.r
 - fonttosfnt
 - from
 - genccode
 - gencmn
 - gennorm2
 - gensprep
 - geqn
 - gfortran
 - gfortran-5
 - gpic
 - groff
 - grog
 - grops
 - grotty
 - group.r
 - groupCorr.r
 - groupFWHM.r
 - gtbl
 - gtf
 - h5c++
 - h5cc
 - h5fc
 - hd
 - iceauth
 - ico
 - icupkg
 - isdv4-serial-debugger
 - isdv4-serial-inputattach
 - koi8rxterm
 - lexgrog
 - libpng12-config
 - listres
 - lorder
 - luit
 - lxterm
 - man
 - mandb
 - manpath
 - mkfontdir
 - mkfontscale
 - mtbls520_01_mtbls_download.sh
 - mtbls520_02_extract.sh
 - mtbls520_03_qc_perform.r
 - mtbls520_03_qc_preparations.sh
 - mtbls520_04_preparations.r
 - mtbls520_04_preparations.sh
 - mtbls520_05a_import_maf.r
 - mtbls520_05b_peak_picking.r
 - mtbls520_06_import_traits.r
 - mtbls520_07_species_diversity.r
 - mtbls520_08a_species_shannon.r
 - mtbls520_08b_species_unique.r
 - mtbls520_08c_species_variability.r
 - mtbls520_08d_species_concentration.r
 - mtbls520_08e_species_features.r
 - mtbls520_09_species_venn.r
 - mtbls520_10_species_varpart.r
 - mtbls520_11_species_nmds.r
 - mtbls520_12_species_marchantia.r
 - mtbls520_14_ecology_varpart.r
 - mtbls520_15_ecology_pca.r
 - mtbls520_16_ecology_rda.r
 - mtbls520_17_ecology_splsda.r
 - mtbls520_18_phylogeny.r
 - mtbls520_19a_seasons_shannon.r
 - mtbls520_19b_seasons_unique.r
 - mtbls520_19c_seasons_variability.r
 - mtbls520_19d_seasons_concentration.r
 - mtbls520_19e_seasons_features.r
 - mtbls520_22_seasons_pca.r
 - mtbls520_23_seasons_rda.r
 - mtbls520_24_seasons_nmds.r
 - nc-config
 - ncal
 - neqn
 - nroff
 - oclock
 - paperconf
 - paperconfig
 - pic
 - preconv
 - prepareOutput.r
 - printerbanner
 - rendercheck
 - retCor.r
 - rstart
 - rstartd
 - runTest1.R
 - runTest1.sh
 - save_chromatogram.r
 - sessreg
 - setphenotype.r
 - setxkbmap
 - show_chromatogram.r
 - showrgb
 - smproxy
 - soelim
 - startx
 - synclient
 - syndaemon
 - tbl
 - test_output.r
 - transset
 - troff
 - uconv
 - ucs2any
 - update-fonts-alias
 - update-fonts-dir
 - update-fonts-scale
 - uxterm
 - viewres
 - vmmouse_detect
 - whatis
 - x-terminal-emulator
 - x11perf
 - x11perfcomp
 - x86_64-linux-gnu-gfortran
 - x86_64-linux-gnu-gfortran-5
 - xbiff
 - xcalc
 - xclipboard
 - xclock
 - xcmsCollect.r
 - xcmsdb
 - xcmssplitter.r
 - xconsole
 - xcursorgen
 - xcutsel
 - xdg-desktop-icon
 - xdg-desktop-menu
 - xdg-email
 - xdg-icon-resource
 - xdg-mime
 - xdg-open
 - xdg-screensaver
 - xdg-settings
 - xditview
 - xdpyinfo
 - xdriinfo
 - xedit
 - xev
 - xeyes
 - xfd
 - xfontsel
 - xgamma
 - xgc
 - xhost
 - xinit
 - xinput
 - xkbbell
 - xkbcomp
 - xkbevd
 - xkbprint
 - xkbvleds
 - xkbwatch
 - xkeystone
 - xkill
 - xload
 - xlogo
 - xlsatoms
 - xlsclients
 - xlsfonts
 - xmag
 - xman
 - xmessage
 - xmodmap
 - xmore
 - xprop
 - xrandr
 - xrdb
 - xrefresh
 - xsAnnotate.r
 - xset
 - xsetmode
 - xsetpointer
 - xsetroot
 - xsetwacom
 - xsm
 - xstdcmap
 - xterm
 - xvidtune
 - xvinfo
 - xwd
 - xwininfo
 - xwud

This container was pulled from:

	https://hub.docker.com/r/biocontainers/ecomet

If you encounter errors in ecomet or need help running the
tools it contains, please contact the developer at

	https://hub.docker.com/r/biocontainers/ecomet

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ecomet")
whatis("Version: ctr-phenomenal-v1.1_cv0.3.39")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ecomet package")
whatis("URL: https://hub.docker.com/r/biocontainers/ecomet")

set_shell_function("R",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg R $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg R $*')
set_shell_function("Rscript",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg Rscript $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg Rscript $*')
set_shell_function("X",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg X $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg X $*')
set_shell_function("Xorg",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg Xorg $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg Xorg $*')
set_shell_function("accessdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg accessdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg accessdb $*')
set_shell_function("appres",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg appres $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg appres $*')
set_shell_function("apropos",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg apropos $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg apropos $*')
set_shell_function("atobm",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg atobm $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg atobm $*')
set_shell_function("bdftopcf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bdftopcf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bdftopcf $*')
set_shell_function("bdftruncate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bdftruncate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bdftruncate $*')
set_shell_function("bitmap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bitmap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bitmap $*')
set_shell_function("blankfilter.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg blankfilter.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg blankfilter.r $*')
set_shell_function("bmtoa",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bmtoa $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bmtoa $*')
set_shell_function("browse",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg browse $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg browse $*')
set_shell_function("bsd-from",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bsd-from $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bsd-from $*')
set_shell_function("bsd-write",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bsd-write $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg bsd-write $*')
set_shell_function("calendar",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg calendar $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg calendar $*')
set_shell_function("cameraToFeatureXML.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg cameraToFeatureXML.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg cameraToFeatureXML.r $*')
set_shell_function("catman",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg catman $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg catman $*')
set_shell_function("consensusXMLToXcms.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg consensusXMLToXcms.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg consensusXMLToXcms.r $*')
set_shell_function("cvt",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg cvt $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg cvt $*')
set_shell_function("dh_xsf_substvars",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg dh_xsf_substvars $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg dh_xsf_substvars $*')
set_shell_function("dilutionfilter.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg dilutionfilter.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg dilutionfilter.r $*')
set_shell_function("editres",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg editres $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg editres $*')
set_shell_function("eqn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg eqn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg eqn $*')
set_shell_function("f77",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg f77 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg f77 $*')
set_shell_function("f95",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg f95 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg f95 $*')
set_shell_function("featureXMLToCAMERA.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg featureXMLToCAMERA.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg featureXMLToCAMERA.r $*')
set_shell_function("featureXMLToXcms.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg featureXMLToXcms.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg featureXMLToXcms.r $*')
set_shell_function("filenameextractor.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg filenameextractor.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg filenameextractor.r $*')
set_shell_function("fillPeaks.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg fillPeaks.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg fillPeaks.r $*')
set_shell_function("findAdducts.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg findAdducts.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg findAdducts.r $*')
set_shell_function("findIsotopes.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg findIsotopes.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg findIsotopes.r $*')
set_shell_function("findPeaks.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg findPeaks.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg findPeaks.r $*')
set_shell_function("fonttosfnt",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg fonttosfnt $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg fonttosfnt $*')
set_shell_function("from",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg from $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg from $*')
set_shell_function("genccode",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg genccode $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg genccode $*')
set_shell_function("gencmn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gencmn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gencmn $*')
set_shell_function("gennorm2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gennorm2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gennorm2 $*')
set_shell_function("gensprep",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gensprep $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gensprep $*')
set_shell_function("geqn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg geqn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg geqn $*')
set_shell_function("gfortran",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gfortran $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gfortran $*')
set_shell_function("gfortran-5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gfortran-5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gfortran-5 $*')
set_shell_function("gpic",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gpic $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gpic $*')
set_shell_function("groff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg groff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg groff $*')
set_shell_function("grog",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg grog $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg grog $*')
set_shell_function("grops",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg grops $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg grops $*')
set_shell_function("grotty",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg grotty $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg grotty $*')
set_shell_function("group.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg group.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg group.r $*')
set_shell_function("groupCorr.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg groupCorr.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg groupCorr.r $*')
set_shell_function("groupFWHM.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg groupFWHM.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg groupFWHM.r $*')
set_shell_function("gtbl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gtbl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gtbl $*')
set_shell_function("gtf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gtf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg gtf $*')
set_shell_function("h5c++",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg h5c++ $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg h5c++ $*')
set_shell_function("h5cc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg h5cc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg h5cc $*')
set_shell_function("h5fc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg h5fc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg h5fc $*')
set_shell_function("hd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg hd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg hd $*')
set_shell_function("iceauth",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg iceauth $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg iceauth $*')
set_shell_function("ico",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg ico $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg ico $*')
set_shell_function("icupkg",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg icupkg $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg icupkg $*')
set_shell_function("isdv4-serial-debugger",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg isdv4-serial-debugger $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg isdv4-serial-debugger $*')
set_shell_function("isdv4-serial-inputattach",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg isdv4-serial-inputattach $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg isdv4-serial-inputattach $*')
set_shell_function("koi8rxterm",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg koi8rxterm $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg koi8rxterm $*')
set_shell_function("lexgrog",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg lexgrog $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg lexgrog $*')
set_shell_function("libpng12-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg libpng12-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg libpng12-config $*')
set_shell_function("listres",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg listres $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg listres $*')
set_shell_function("lorder",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg lorder $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg lorder $*')
set_shell_function("luit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg luit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg luit $*')
set_shell_function("lxterm",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg lxterm $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg lxterm $*')
set_shell_function("man",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg man $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg man $*')
set_shell_function("mandb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mandb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mandb $*')
set_shell_function("manpath",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg manpath $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg manpath $*')
set_shell_function("mkfontdir",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mkfontdir $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mkfontdir $*')
set_shell_function("mkfontscale",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mkfontscale $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mkfontscale $*')
set_shell_function("mtbls520_01_mtbls_download.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_01_mtbls_download.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_01_mtbls_download.sh $*')
set_shell_function("mtbls520_02_extract.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_02_extract.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_02_extract.sh $*')
set_shell_function("mtbls520_03_qc_perform.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_03_qc_perform.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_03_qc_perform.r $*')
set_shell_function("mtbls520_03_qc_preparations.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_03_qc_preparations.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_03_qc_preparations.sh $*')
set_shell_function("mtbls520_04_preparations.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_04_preparations.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_04_preparations.r $*')
set_shell_function("mtbls520_04_preparations.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_04_preparations.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_04_preparations.sh $*')
set_shell_function("mtbls520_05a_import_maf.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_05a_import_maf.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_05a_import_maf.r $*')
set_shell_function("mtbls520_05b_peak_picking.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_05b_peak_picking.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_05b_peak_picking.r $*')
set_shell_function("mtbls520_06_import_traits.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_06_import_traits.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_06_import_traits.r $*')
set_shell_function("mtbls520_07_species_diversity.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_07_species_diversity.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_07_species_diversity.r $*')
set_shell_function("mtbls520_08a_species_shannon.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08a_species_shannon.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08a_species_shannon.r $*')
set_shell_function("mtbls520_08b_species_unique.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08b_species_unique.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08b_species_unique.r $*')
set_shell_function("mtbls520_08c_species_variability.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08c_species_variability.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08c_species_variability.r $*')
set_shell_function("mtbls520_08d_species_concentration.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08d_species_concentration.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08d_species_concentration.r $*')
set_shell_function("mtbls520_08e_species_features.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08e_species_features.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_08e_species_features.r $*')
set_shell_function("mtbls520_09_species_venn.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_09_species_venn.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_09_species_venn.r $*')
set_shell_function("mtbls520_10_species_varpart.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_10_species_varpart.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_10_species_varpart.r $*')
set_shell_function("mtbls520_11_species_nmds.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_11_species_nmds.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_11_species_nmds.r $*')
set_shell_function("mtbls520_12_species_marchantia.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_12_species_marchantia.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_12_species_marchantia.r $*')
set_shell_function("mtbls520_14_ecology_varpart.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_14_ecology_varpart.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_14_ecology_varpart.r $*')
set_shell_function("mtbls520_15_ecology_pca.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_15_ecology_pca.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_15_ecology_pca.r $*')
set_shell_function("mtbls520_16_ecology_rda.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_16_ecology_rda.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_16_ecology_rda.r $*')
set_shell_function("mtbls520_17_ecology_splsda.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_17_ecology_splsda.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_17_ecology_splsda.r $*')
set_shell_function("mtbls520_18_phylogeny.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_18_phylogeny.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_18_phylogeny.r $*')
set_shell_function("mtbls520_19a_seasons_shannon.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19a_seasons_shannon.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19a_seasons_shannon.r $*')
set_shell_function("mtbls520_19b_seasons_unique.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19b_seasons_unique.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19b_seasons_unique.r $*')
set_shell_function("mtbls520_19c_seasons_variability.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19c_seasons_variability.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19c_seasons_variability.r $*')
set_shell_function("mtbls520_19d_seasons_concentration.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19d_seasons_concentration.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19d_seasons_concentration.r $*')
set_shell_function("mtbls520_19e_seasons_features.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19e_seasons_features.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_19e_seasons_features.r $*')
set_shell_function("mtbls520_22_seasons_pca.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_22_seasons_pca.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_22_seasons_pca.r $*')
set_shell_function("mtbls520_23_seasons_rda.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_23_seasons_rda.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_23_seasons_rda.r $*')
set_shell_function("mtbls520_24_seasons_nmds.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_24_seasons_nmds.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg mtbls520_24_seasons_nmds.r $*')
set_shell_function("nc-config",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg nc-config $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg nc-config $*')
set_shell_function("ncal",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg ncal $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg ncal $*')
set_shell_function("neqn",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg neqn $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg neqn $*')
set_shell_function("nroff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg nroff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg nroff $*')
set_shell_function("oclock",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg oclock $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg oclock $*')
set_shell_function("paperconf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg paperconf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg paperconf $*')
set_shell_function("paperconfig",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg paperconfig $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg paperconfig $*')
set_shell_function("pic",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg pic $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg pic $*')
set_shell_function("preconv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg preconv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg preconv $*')
set_shell_function("prepareOutput.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg prepareOutput.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg prepareOutput.r $*')
set_shell_function("printerbanner",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg printerbanner $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg printerbanner $*')
set_shell_function("rendercheck",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg rendercheck $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg rendercheck $*')
set_shell_function("retCor.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg retCor.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg retCor.r $*')
set_shell_function("rstart",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg rstart $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg rstart $*')
set_shell_function("rstartd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg rstartd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg rstartd $*')
set_shell_function("runTest1.R",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg runTest1.R $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg runTest1.R $*')
set_shell_function("runTest1.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg runTest1.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg runTest1.sh $*')
set_shell_function("save_chromatogram.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg save_chromatogram.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg save_chromatogram.r $*')
set_shell_function("sessreg",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg sessreg $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg sessreg $*')
set_shell_function("setphenotype.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg setphenotype.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg setphenotype.r $*')
set_shell_function("setxkbmap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg setxkbmap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg setxkbmap $*')
set_shell_function("show_chromatogram.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg show_chromatogram.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg show_chromatogram.r $*')
set_shell_function("showrgb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg showrgb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg showrgb $*')
set_shell_function("smproxy",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg smproxy $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg smproxy $*')
set_shell_function("soelim",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg soelim $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg soelim $*')
set_shell_function("startx",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg startx $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg startx $*')
set_shell_function("synclient",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg synclient $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg synclient $*')
set_shell_function("syndaemon",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg syndaemon $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg syndaemon $*')
set_shell_function("tbl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg tbl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg tbl $*')
set_shell_function("test_output.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg test_output.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg test_output.r $*')
set_shell_function("transset",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg transset $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg transset $*')
set_shell_function("troff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg troff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg troff $*')
set_shell_function("uconv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg uconv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg uconv $*')
set_shell_function("ucs2any",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg ucs2any $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg ucs2any $*')
set_shell_function("update-fonts-alias",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg update-fonts-alias $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg update-fonts-alias $*')
set_shell_function("update-fonts-dir",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg update-fonts-dir $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg update-fonts-dir $*')
set_shell_function("update-fonts-scale",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg update-fonts-scale $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg update-fonts-scale $*')
set_shell_function("uxterm",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg uxterm $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg uxterm $*')
set_shell_function("viewres",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg viewres $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg viewres $*')
set_shell_function("vmmouse_detect",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg vmmouse_detect $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg vmmouse_detect $*')
set_shell_function("whatis",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg whatis $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg whatis $*')
set_shell_function("x-terminal-emulator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x-terminal-emulator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x-terminal-emulator $*')
set_shell_function("x11perf",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x11perf $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x11perf $*')
set_shell_function("x11perfcomp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x11perfcomp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x11perfcomp $*')
set_shell_function("x86_64-linux-gnu-gfortran",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x86_64-linux-gnu-gfortran $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x86_64-linux-gnu-gfortran $*')
set_shell_function("x86_64-linux-gnu-gfortran-5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x86_64-linux-gnu-gfortran-5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg x86_64-linux-gnu-gfortran-5 $*')
set_shell_function("xbiff",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xbiff $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xbiff $*')
set_shell_function("xcalc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcalc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcalc $*')
set_shell_function("xclipboard",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xclipboard $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xclipboard $*')
set_shell_function("xclock",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xclock $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xclock $*')
set_shell_function("xcmsCollect.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcmsCollect.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcmsCollect.r $*')
set_shell_function("xcmsdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcmsdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcmsdb $*')
set_shell_function("xcmssplitter.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcmssplitter.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcmssplitter.r $*')
set_shell_function("xconsole",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xconsole $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xconsole $*')
set_shell_function("xcursorgen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcursorgen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcursorgen $*')
set_shell_function("xcutsel",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcutsel $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xcutsel $*')
set_shell_function("xdg-desktop-icon",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-desktop-icon $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-desktop-icon $*')
set_shell_function("xdg-desktop-menu",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-desktop-menu $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-desktop-menu $*')
set_shell_function("xdg-email",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-email $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-email $*')
set_shell_function("xdg-icon-resource",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-icon-resource $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-icon-resource $*')
set_shell_function("xdg-mime",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-mime $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-mime $*')
set_shell_function("xdg-open",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-open $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-open $*')
set_shell_function("xdg-screensaver",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-screensaver $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-screensaver $*')
set_shell_function("xdg-settings",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-settings $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdg-settings $*')
set_shell_function("xditview",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xditview $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xditview $*')
set_shell_function("xdpyinfo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdpyinfo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdpyinfo $*')
set_shell_function("xdriinfo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdriinfo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xdriinfo $*')
set_shell_function("xedit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xedit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xedit $*')
set_shell_function("xev",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xev $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xev $*')
set_shell_function("xeyes",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xeyes $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xeyes $*')
set_shell_function("xfd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xfd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xfd $*')
set_shell_function("xfontsel",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xfontsel $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xfontsel $*')
set_shell_function("xgamma",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xgamma $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xgamma $*')
set_shell_function("xgc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xgc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xgc $*')
set_shell_function("xhost",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xhost $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xhost $*')
set_shell_function("xinit",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xinit $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xinit $*')
set_shell_function("xinput",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xinput $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xinput $*')
set_shell_function("xkbbell",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbbell $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbbell $*')
set_shell_function("xkbcomp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbcomp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbcomp $*')
set_shell_function("xkbevd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbevd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbevd $*')
set_shell_function("xkbprint",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbprint $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbprint $*')
set_shell_function("xkbvleds",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbvleds $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbvleds $*')
set_shell_function("xkbwatch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbwatch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkbwatch $*')
set_shell_function("xkeystone",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkeystone $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkeystone $*')
set_shell_function("xkill",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkill $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xkill $*')
set_shell_function("xload",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xload $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xload $*')
set_shell_function("xlogo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xlogo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xlogo $*')
set_shell_function("xlsatoms",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xlsatoms $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xlsatoms $*')
set_shell_function("xlsclients",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xlsclients $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xlsclients $*')
set_shell_function("xlsfonts",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xlsfonts $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xlsfonts $*')
set_shell_function("xmag",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xmag $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xmag $*')
set_shell_function("xman",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xman $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xman $*')
set_shell_function("xmessage",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xmessage $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xmessage $*')
set_shell_function("xmodmap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xmodmap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xmodmap $*')
set_shell_function("xmore",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xmore $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xmore $*')
set_shell_function("xprop",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xprop $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xprop $*')
set_shell_function("xrandr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xrandr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xrandr $*')
set_shell_function("xrdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xrdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xrdb $*')
set_shell_function("xrefresh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xrefresh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xrefresh $*')
set_shell_function("xsAnnotate.r",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsAnnotate.r $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsAnnotate.r $*')
set_shell_function("xset",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xset $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xset $*')
set_shell_function("xsetmode",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsetmode $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsetmode $*')
set_shell_function("xsetpointer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsetpointer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsetpointer $*')
set_shell_function("xsetroot",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsetroot $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsetroot $*')
set_shell_function("xsetwacom",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsetwacom $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsetwacom $*')
set_shell_function("xsm",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsm $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xsm $*')
set_shell_function("xstdcmap",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xstdcmap $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xstdcmap $*')
set_shell_function("xterm",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xterm $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xterm $*')
set_shell_function("xvidtune",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xvidtune $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xvidtune $*')
set_shell_function("xvinfo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xvinfo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xvinfo $*')
set_shell_function("xwd",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xwd $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xwd $*')
set_shell_function("xwininfo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xwininfo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xwininfo $*')
set_shell_function("xwud",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xwud $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecomet/ecomet-phenomenal-v1.1_cv0.3.39.simg xwud $*')
