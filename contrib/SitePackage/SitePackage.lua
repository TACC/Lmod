-- -*- lua -*-
-- vim:ft=lua:et:ts=4

sitePkgRoot = os.getenv("LMOD_PKG_ROOT") or "/global/apps"

function checkRestrictedGroup(pkg, group) 
   if (mode() ~= "load") then return true end
   if (group == nil)     then return true end
   local err_message = "Only users in group \'" .. group .. 
        "\' can access module \'" .. pkg.id .. "\'"
   local found = false
   local grps = capture("groups")

   for g in grps:split("[ \n]") do
      if (g == group) then
         return true
      end
   end
   LmodError(err_message,"\n")
   return false
end

function logUsage(pkg)
   if (mode() ~= "load") then return true end
   local user = os.getenv("USER")
   local jobid = os.getenv("PBS_JOBID")
   local msg = ""
   if jobid == nil then 
      msg = string.format("user=%s,app=%s", user, pkg.id)
   else
      msg = string.format("user=%s,app=%s,job=%s", 
                          user, pkg.id, jobid)
   end
   local cmd = "logger -t lmod -p local0.info " .. msg
   os.execute(cmd)
end

function prependModulePath(subdir)
   local mroot = os.getenv("MODULEPATH_ROOT")
   local mdir  = pathJoin(mroot, subdir)
   prepend_path("MODULEPATH", mdir)
end

function appendModulePath(subdir)
   local mroot = os.getenv("MODULEPATH_ROOT")
   local mdir  = pathJoin(mroot, subdir)
   append_path("MODULEPATH", mdir)
end

