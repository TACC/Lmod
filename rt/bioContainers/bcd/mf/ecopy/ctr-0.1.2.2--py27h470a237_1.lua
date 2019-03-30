local help_message = [[
This is a module file for the container quay.io/biocontainers/ecopy:0.1.2.2--py27h470a237_1, which exposes the
following programs:

 - .dbus-post-link.sh
 - assistant
 - cygdb
 - cython
 - cythonize
 - dbus-launch
 - designer
 - fixqt4headers.pl
 - gst-device-monitor-1.0
 - gst-discoverer-1.0
 - gst-inspect-1.0
 - gst-launch-1.0
 - gst-play-1.0
 - gst-stats-1.0
 - gst-typefind-1.0
 - insserv
 - install_packages
 - lconvert
 - linguist
 - locale-gen
 - lrelease
 - lupdate
 - moc
 - perl5.20.2
 - pixeltool
 - pylupdate5
 - pyrcc5
 - pyuic5
 - qcollectiongenerator
 - qdbus
 - qdbuscpp2xml
 - qdbusviewer
 - qdbusxml2cpp
 - qdoc
 - qhelpconverter
 - qhelpgenerator
 - qlalr
 - qmake
 - qml
 - qmleasing
 - qmlimportscanner
 - qmllint
 - qmlmin
 - qmlplugindump
 - qmlprofiler
 - qmlscene
 - qmltestrunner
 - qtdiag
 - qtpaths
 - qtplugininfo
 - rcc
 - sip
 - syncqt.pl
 - uic
 - update-locale
 - validlocale
 - xmlpatterns
 - xmlpatternsvalidator

This container was pulled from:

	https://quay.io/repository/biocontainers/ecopy

If you encounter errors in ecopy or need help running the
tools it contains, please contact the developer at

	https://quay.io/repository/biocontainers/ecopy

For errors in the container or module file, please
submit a ticket at

	gzynda@tacc.utexas.edu
	https://portal.tacc.utexas.edu/tacc-consulting
]]
help(help_message,"\n")

whatis("Name: ecopy")
whatis("Version: ctr-0.1.2.2--py27h470a237_1")
whatis("Category: ['Bioinformatics']")
whatis("Keywords: ['Biocontainer']")
whatis("Description: The ecopy package")
whatis("URL: https://quay.io/repository/biocontainers/ecopy")

set_shell_function(".dbus-post-link.sh",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg .dbus-post-link.sh $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg .dbus-post-link.sh $*')
set_shell_function("assistant",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg assistant $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg assistant $*')
set_shell_function("cygdb",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg cygdb $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg cygdb $*')
set_shell_function("cython",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg cython $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg cython $*')
set_shell_function("cythonize",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg cythonize $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg cythonize $*')
set_shell_function("dbus-launch",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg dbus-launch $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg dbus-launch $*')
set_shell_function("designer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg designer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg designer $*')
set_shell_function("fixqt4headers.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg fixqt4headers.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg fixqt4headers.pl $*')
set_shell_function("gst-device-monitor-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-device-monitor-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-device-monitor-1.0 $*')
set_shell_function("gst-discoverer-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-discoverer-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-discoverer-1.0 $*')
set_shell_function("gst-inspect-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-inspect-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-inspect-1.0 $*')
set_shell_function("gst-launch-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-launch-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-launch-1.0 $*')
set_shell_function("gst-play-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-play-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-play-1.0 $*')
set_shell_function("gst-stats-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-stats-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-stats-1.0 $*')
set_shell_function("gst-typefind-1.0",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-typefind-1.0 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg gst-typefind-1.0 $*')
set_shell_function("insserv",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg insserv $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg insserv $*')
set_shell_function("install_packages",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg install_packages $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg install_packages $*')
set_shell_function("lconvert",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg lconvert $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg lconvert $*')
set_shell_function("linguist",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg linguist $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg linguist $*')
set_shell_function("locale-gen",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg locale-gen $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg locale-gen $*')
set_shell_function("lrelease",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg lrelease $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg lrelease $*')
set_shell_function("lupdate",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg lupdate $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg lupdate $*')
set_shell_function("moc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg moc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg moc $*')
set_shell_function("perl5.20.2",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg perl5.20.2 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg perl5.20.2 $*')
set_shell_function("pixeltool",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg pixeltool $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg pixeltool $*')
set_shell_function("pylupdate5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg pylupdate5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg pylupdate5 $*')
set_shell_function("pyrcc5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg pyrcc5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg pyrcc5 $*')
set_shell_function("pyuic5",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg pyuic5 $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg pyuic5 $*')
set_shell_function("qcollectiongenerator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qcollectiongenerator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qcollectiongenerator $*')
set_shell_function("qdbus",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdbus $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdbus $*')
set_shell_function("qdbuscpp2xml",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdbuscpp2xml $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdbuscpp2xml $*')
set_shell_function("qdbusviewer",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdbusviewer $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdbusviewer $*')
set_shell_function("qdbusxml2cpp",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdbusxml2cpp $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdbusxml2cpp $*')
set_shell_function("qdoc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdoc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qdoc $*')
set_shell_function("qhelpconverter",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qhelpconverter $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qhelpconverter $*')
set_shell_function("qhelpgenerator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qhelpgenerator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qhelpgenerator $*')
set_shell_function("qlalr",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qlalr $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qlalr $*')
set_shell_function("qmake",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmake $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmake $*')
set_shell_function("qml",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qml $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qml $*')
set_shell_function("qmleasing",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmleasing $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmleasing $*')
set_shell_function("qmlimportscanner",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlimportscanner $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlimportscanner $*')
set_shell_function("qmllint",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmllint $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmllint $*')
set_shell_function("qmlmin",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlmin $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlmin $*')
set_shell_function("qmlplugindump",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlplugindump $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlplugindump $*')
set_shell_function("qmlprofiler",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlprofiler $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlprofiler $*')
set_shell_function("qmlscene",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlscene $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmlscene $*')
set_shell_function("qmltestrunner",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmltestrunner $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qmltestrunner $*')
set_shell_function("qtdiag",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qtdiag $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qtdiag $*')
set_shell_function("qtpaths",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qtpaths $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qtpaths $*')
set_shell_function("qtplugininfo",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qtplugininfo $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg qtplugininfo $*')
set_shell_function("rcc",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg rcc $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg rcc $*')
set_shell_function("sip",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg sip $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg sip $*')
set_shell_function("syncqt.pl",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg syncqt.pl $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg syncqt.pl $*')
set_shell_function("uic",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg uic $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg uic $*')
set_shell_function("update-locale",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg update-locale $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg update-locale $*')
set_shell_function("validlocale",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg validlocale $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg validlocale $*')
set_shell_function("xmlpatterns",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg xmlpatterns $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg xmlpatterns $*')
set_shell_function("xmlpatternsvalidator",'singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg xmlpatternsvalidator $@','singularity exec ${BIOCONTAINER_DIR}/biocontainers/ecopy/ecopy-0.1.2.2--py27h470a237_1.simg xmlpatternsvalidator $*')
