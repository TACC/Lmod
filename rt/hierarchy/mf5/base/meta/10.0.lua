local MODULEPATH_ROOT = myFileName():match('(.*)/base/meta/.*')
prepend_path("MODULEPATH",pathJoin(MODULEPATH_ROOT,"Core"))



