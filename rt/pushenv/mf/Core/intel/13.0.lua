local pkgName      = "intel"
local version      = barefilename(myFileName():gsub(".lua",""))
local pkgNameVer   = pathJoin(pkgName,version)
local mdir         = pathJoin("Compiler/intel",version)

pushenv("CC","icc")
prepend_path('MODULEPATH',     pathJoin(os.getenv("MODULEPATH_ROOT"),mdir))
