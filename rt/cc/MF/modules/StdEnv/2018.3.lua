--add_property(   "lmod", "sticky")
local mroot=os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH", pathJoin(mroot,"Core"))

load("intel/2018.3")
