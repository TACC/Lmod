local Dbg            = require("Dbg")
function ModifyPath()

   local dbg       = Dbg:dbg()
   local masterTbl = masterTbl()
   local oldTarg   = os.getenv('TARG') or ''
   local targ      = masterTbl.envVarsTbl.TARG
   local path      = os.getenv('PATH') or ''

   local w_path    = ":"   .. path    .. ":"
   local w_oldTarg = ":./" .. oldTarg .. ":"
   local w_targ    = ":./" .. targ    .. ":"

   dbg.start("ModifyPath()")

   w_oldTarg = w_oldTarg:gsub("%-","%%-")

   if (w_oldTarg == '::' or w_path:find(w_oldTarg) == nil) then
      path = w_targ .. path
      dbg.print("(1) path: ",path,"\n")
   else
      path = w_path:gsub(w_oldTarg,w_targ)
      dbg.print("(2) path:",path,"\n")
   end

   if (path:sub(1,1) == ':') then
      path = path:sub(2)
   end
   
   if (path:sub(-1,-1) == ':') then
      path = path:sub(1,-2)
   end

   masterTbl.envVarsTbl.PATH = path
   dbg.fini()
end
