local MODULEPATH_ROOT = myFileName():match('(.*)/special/oneapi/.*')
prepend_path("MODULEPATH",pathJoin(MODULEPATH_ROOT,"special/oneapi22"))

