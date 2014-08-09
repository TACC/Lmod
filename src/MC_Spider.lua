--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2014 Robert McLay
--
--  Permission is hereby granted, free of charge, to any person obtaining
--  a copy of this software and associated documentation files (the
--  "Software"), to deal in the Software without restriction, including
--  without limitation the rights to use, copy, modify, merge, publish,
--  distribute, sublicense, and/or sell copies of the Software, and to
--  permit persons to whom the Software is furnished to do so, subject
--  to the following conditions:
--
--  The above copyright notice and this permission notice shall be
--  included in all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- MC_Spider: This derived class of MasterControl is how Spider reads
--            in modulefiles.  It uses masterTbl() to hold the moduleStack.
--            It looks for adding paths to MODULEPATH.  It also keeps track
--            of properties.


require("strict")
require("utils")

local dbg              = require("Dbg"):dbg()
local concatTbl        = table.concat
local hook             = require("Hook")
MC_Spider              = inheritsFrom(MasterControl)
MC_Spider.my_name      = "MC_Spider"
MC_Spider.my_sType     = "load"
MC_Spider.my_tcl_mode  = "load"

local M                = MC_Spider

M.always_load          = MasterControl.quiet
M.always_unload        = MasterControl.quiet
M.conflict             = MasterControl.quiet
M.error                = MasterControl.quiet
M.execute              = MasterControl.execute
M.family               = MasterControl.quiet
M.inherit              = MasterControl.quiet
M.load                 = MasterControl.quiet
M.load_usr             = MasterControl.quiet
M.message              = MasterControl.quiet
M.prereq               = MasterControl.quiet
M.prereq_any           = MasterControl.quiet
M.pushenv              = MasterControl.quiet
M.remove_path          = MasterControl.quiet
M.report               = MasterControl.warning
M.set_alias            = MasterControl.quiet
M.set_shell_function   = MasterControl.quiet
M.try_load             = MasterControl.quiet
M.unload               = MasterControl.quiet
M.unload_usr           = MasterControl.quiet
M.unsetenv             = MasterControl.quiet
M.unset_alias          = MasterControl.quiet
M.unset_shell_function = MasterControl.quiet
M.usrload              = MasterControl.quiet
M.warning              = MasterControl.warning


--------------------------------------------------------------------------
-- MC_Spider:myFileName(): use the moduleStack to return the filename
--                         of the modulefile.

function M.myFileName(self)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   return moduleStack[iStack].fn
end

--------------------------------------------------------------------------
-- MC_Spider:myModuleFullName(): use the moduleStack to return the full
--                               name of the module.  This is typically
--                               name/version.  For Spider we assume that
--                               the user name is the full name.

function M.myModuleFullName(self)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   return moduleStack[iStack].full
end

M.myModuleUsrName = M.myModuleFullName

--------------------------------------------------------------------------
-- MC_Spider:myModuleName(): use the moduleStack to return the short
--                           name of the module.

function M.myModuleName(self)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   return moduleStack[iStack].sn
end

--------------------------------------------------------------------------
-- MC_Spider:myModuleName(): use the moduleStack to return the version
--                           of the module.  For meta modules the version
--                           will be ""

function M.myModuleVersion(self)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   local full        = moduleStack[iStack].full
   local sn          = moduleStack[iStack].sn
   return extractVersion(full, sn) or ""
end

--------------------------------------------------------------------------
-- MC_Spider:help(): Collect the help message into moduleT

function M.help(self,...)
   dbg.start{"MC_Spider:help(...)"}
   local masterTbl    = masterTbl()
   local moduleStack  = masterTbl.moduleStack
   local iStack       = #moduleStack
   local path         = moduleStack[iStack].path
   local moduleT      = moduleStack[iStack].moduleT
   moduleT[path].help = concatTbl({...},"")
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- MC_Spider:whatis(): Collect the whatis messages into moduleT

function M.whatis(self,s)
   dbg.start{"MC_Spider:whatis(...)"}
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   local path        = moduleStack[iStack].path
   local moduleT     = moduleStack[iStack].moduleT

   local i,j, key, value = s:find('^%s*([^: ]+)%s*:%s*(.*)')
   local k  = KeyT[key]
   if (k) then
      moduleT[path][key] = value
   end
   if (moduleT[path].whatis == nil) then
      moduleT[path].whatis ={}
   end
   moduleT[path].whatis[#moduleT[path].whatis+1] = s
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- MC_Spider:setenv(): Track "TACC_.*_LIB" environment variables or
--                     whatever the site is called.

s_pat = false
function M.setenv(self, name, value)
   dbg.start{"MC_Spider:setenv(name, value)"}

   if (not s_pat) then
      local a = {}
      a[#a+1] = "^"
      a[#a+1] = hook.apply("SiteName")
      a[#a+1] = "_.*_LIB"
      s_pat   = concatTbl(a,"")
   end

   if (name:find(s_pat)) then
      processLPATH(value)
   end
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- MC_Spider:prepend_path(): Pass-thru to Spider_append_path().

function M.prepend_path(self,t)
   dbg.start{"MC_Spider:prepend_path(t)"}
   Spider_append_path("prepend",t)
   dbg.fini()
   return true

end

--------------------------------------------------------------------------
-- MC_Spider:append_path(): Pass-thru to Spider_append_path().

function M.append_path(self,t)
   dbg.start{"MC_Spider:append_path(t)"}
   Spider_append_path("append",t)
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- MC_Spider:is_spider: always return true.

function M.is_spider(self)
   dbg.start{"MC_Spider:is_spider()"}
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- MC_Spider:add_property: Copy the property to moduleT

function M.add_property(self, name, value)
   dbg.start{"MC_Spider:add_property(name=\"",name,"\", value=\"",value,"\")"}
   local masterTbl     = masterTbl()
   local moduleStack   = masterTbl.moduleStack
   local iStack        = #moduleStack
   local path          = moduleStack[iStack].path
   local moduleT       = moduleStack[iStack].moduleT
   local t             = moduleT[path].propT or {}
   t[name]             = t[name] or {}
   t[name][value]      = 1
   moduleT[path].propT = t
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- MC_Spider:remove_property: Remove the property to moduleT

function M.remove_property(self,name, value)
   dbg.start{"MC_Spider:remove_property(name=\"",name,"\", value=\"",value,"\")"}
   local masterTbl     = masterTbl()
   local moduleStack   = masterTbl.moduleStack
   local iStack        = #moduleStack
   local path          = moduleStack[iStack].path
   local moduleT       = moduleStack[iStack].moduleT
   local t             = moduleT[path].propT or {}
   t[name]             = t[name] or {}
   t[name][value]      = nil
   moduleT[path].propT = t
   dbg.fini()
   return true
end

return M
