

-- local functions to deal with family(), MODULEPATH and (for MPI) prereqs

local MName = require("MName")
local dbg   = require("Dbg"):dbg()

function prereq_version(pr_name)
   dbg.start{"prereq_version(",pr_name,")"}
   if (not isloaded(pr_name)) then
      dbg.print{"isloaded(",pr_name,") is false\n"}
      dbg.fini("prereq_version")
      return nil
   end
   local mname = MName:new("mt", pr_name)
   local v     = mname:version()
   dbg.print{"Version: ",v,"\n"}
   dbg.fini("prereq_version")
   return v
end

function load_cc()
   local my_family="Compiler"
   family(my_family)
   local mroot = os.getenv("MODULEPATH_ROOT")
   local mdir = pathJoin(mroot,my_family,myModuleName(),myModuleVersion())
   prepend_path("MODULEPATH", mdir)
end

function load_mpi(prereq_name, prereq_minver)
   dbg.start{"load_mpi(",prereq_name,", ", prereq_minver,")"}
   local my_family="MPI"
   family(my_family)
   prereq(atleast(prereq_name, prereq_minver))
   local mroot = os.getenv("MODULEPATH_ROOT")
   local mdir = pathJoin(mroot,my_family,prereq_name,prereq_version(prereq_name),myModuleName(),myModuleVersion())
   dbg.print{"mdir: ",mdir, "\n"}
   prepend_path("MODULEPATH", mdir)
   dbg.fini("load_mpi")
end

sandbox_registration{ prereq_version = prereq_version, load_cc = load_cc, load_mpi = load_mpi}
