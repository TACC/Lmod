-- -*- lua -*-

local base = "/home/easybuild"
local build = "/tmp/easybuild"
local system = "minerva"
local version = "2.1"
local eb_inst_path = "/csc"
--local module_classes = {"compiler","debugger","lib","mpi","numlib","toolchain","data","ide","vis","perf","tools","devel","lang","phys","chem","geo","math","cae","bio","system","base"}
--local module_hierarchy = {"Core","Compiler","MPI"}
--local module_classes = {"all"}
--local module_hierarchy = {"Core"}
local eb_version = "1.14.0"
local eb_conf_ver = eb_version.. ".0"
local empty = nil
family("easybuild")

whatis("Description: Environment for building for HPCC ")
setenv('EASYBUILD_SUFFIX_MODULES_PATH', "" )
setenv('EASYBUILD_PREFIX', pathJoin(base, system, version))
setenv('EASYBUILD_INSTALLPATH', pathJoin(eb_inst_path, system, version))
setenv('EASYBUILD_BUILDPATH', build)
setenv('EASYBUILD_SOURCEPATH',pathJoin(base,"/sources"))
setenv('EASYBUILD_MODULES_TOOL',"Lmod")
setenv('EASYBUILD_MODULE_NAMING_SCHEME', "HierarchicalMNS")
setenv('EASYBUILD_REPOSITORY',"FileRepository")
setenv('EASYBUILD_REPOSITORYPATH',pathJoin(base,"/eb_repo.d/installedCache", system, version))
setenv('EASYBUILD_RECURSIVE_MODULE_UNLOAD', "True")
setenv('EASYBUILD_ALLOW_MODULES_TOOL_MISMATCH', "True")
setenv('LMOD_IGNORE_CACHE', "1")
setenv('LMOD_TERM_WIDTH', "100")
prepend_path('PATH', "~/bin")
prepend_path('PYTHONPATH',pathJoin(base,"/eb_repo.d","easyconfigs", eb_conf_ver))
prepend_path('PYTHONPATH',pathJoin(base,"/eb_repo.d","easyblocks", eb_version))
prepend_path('PYTHONPATH',pathJoin(base,"/eb_repo.d", "custom"))
local mroot = os.getenv("MODULEPATH_ROOT")

prepend_path('MODULEPATH', pathJoin(mroot,system,"all", "Core"))

--for key,value in pairs(module_classes) do
-- for keyh,valueh in pairs(module_hierarchy) do
--  prepend_path('MODULEPATH',pathJoin(eb_inst_path, "/", system, version, "modules", value, valueh))
-- end
--end

