--------------------------------------------------------------------------
-- This derived class of MainControl is how Spider reads
-- in modulefiles.  It uses optionTbl() to hold the moduleStack.
-- It looks for adding paths to MODULEPATH.  It also keeps track
-- of properties.
--
-- @classmod MC_Spider

_G._DEBUG             = false               -- Required by the new lua posix
local posix           = require("posix")

require("strict")

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
--  Copyright (C) 2008-2018 Robert McLay
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


require("utils")

local dbg              = require("Dbg"):dbg()
local concatTbl        = table.concat
local hook             = require("Hook")
local MainControl      = require("MainControl")
MC_Spider              = inheritsFrom(MainControl)
MC_Spider.my_name      = "MC_Spider"
MC_Spider.my_sType     = "load"
MC_Spider.my_tcl_mode  = "load"

local M                = MC_Spider

M.always_load          = MainControl.quiet
M.always_unload        = MainControl.quiet
M.build_unload         = MainControl.do_not_build_unload
M.color_banner         = MainControl.quiet
M.complete             = MainControl.quiet
M.conflict             = MainControl.quiet
M.depends_on           = MainControl.quiet
M.error                = MainControl.quiet
M.execute              = MainControl.execute
M.inherit              = MainControl.quiet
M.load                 = MainControl.quiet
M.load_any             = MainControl.quiet
M.load_usr             = MainControl.quiet
M.message              = MainControl.quiet
M.msg_raw              = MainControl.quiet
M.mgrload              = MainControl.quiet
M.prereq               = MainControl.quiet
M.prereq_any           = MainControl.quiet
M.purge                = MainControl.quiet
M.remove_path          = MainControl.quiet
M.report               = MainControl.warning
M.set_alias            = MainControl.quiet
M.set_shell_function   = MainControl.quiet
M.source_sh            = MainControl.quiet
M.try_load             = MainControl.quiet
M.uncomplete           = MainControl.quiet
M.unload               = MainControl.quiet
M.unload_usr           = MainControl.quiet
M.unsetenv             = MainControl.quiet
M.unset_alias          = MainControl.quiet
M.unset_shell_function = MainControl.quiet
M.usrload              = MainControl.quiet
M.warning              = MainControl.warning
M.LmodBreak            = MainControl.quiet

function argsPack(...)
   local arg = { n = select("#", ...), ...}
   return arg
end
pack     = (_VERSION == "Lua 5.1") and argsPack or table.pack

--------------------------------------------------------------------------
-- use the moduleStack to return the filename of the modulefile.
-- @param self A MainControl object.
function M.myFileName(self)
   local moduleStack = optionTbl().moduleStack
   local iStack      = #moduleStack
   return moduleStack[iStack].fn
end

--------------------------------------------------------------------------
-- Use the moduleStack to return the full name of the module.  This is
-- typically name/version.  For Spider we assume that the user name is
-- the full name.
-- @param self A MainControl object.
function M.myModuleFullName(self)
   local moduleStack = optionTbl().moduleStack
   local iStack      = #moduleStack
   return moduleStack[iStack].fullName
end

M.myModuleUsrName = M.myModuleFullName

--------------------------------------------------------------------------
-- Use the moduleStack to return the short name of the module.
-- @param self A MainControl object.
function M.myModuleName(self)
   local moduleStack = optionTbl().moduleStack
   local iStack      = #moduleStack
   return moduleStack[iStack].sn
end

--------------------------------------------------------------------------
-- Use the moduleStack to return the version of the module.  For meta
-- modules the version will be "".
-- @param self A MainControl object.
function M.myModuleVersion(self)
   local moduleStack = optionTbl().moduleStack
   local iStack      = #moduleStack
   local fullName    = moduleStack[iStack].fullName
   local sn          = moduleStack[iStack].sn
   return extractVersion(fullName, sn) or ""
end

--------------------------------------------------------------------------
-- MC_Spider:help(...): Collect the help message into moduleT
-- @param self A MainControl object.
function M.help(self,...)
   dbg.start{"MC_Spider:help(...)"}
   local moduleStack  = optionTbl().moduleStack
   local iStack       = #moduleStack
   local path         = moduleStack[iStack].path
   local moduleT      = moduleStack[iStack].moduleT
   moduleT.help       = concatTbl({...},"")
   dbg.fini()
   return true
end

function M.haveDynamicMPATH(self)
   dbg.start{"MC_Spider:haveDynamicMPATH()"}
   Spider_dynamic_mpath()
   dbg.fini("MC_Spider:haveDynamicMPATH")
end

--------------------------------------------------------------------------
-- MC_Spider:extensions(...): Copy the list of provides to moduleT
-- @param self A MainControl object.
function M.extensions(self,...)
   dbg.start{"MC_Spider:extensions(...)"}
   local moduleStack  = optionTbl().moduleStack
   local iStack       = #moduleStack
   local path         = moduleStack[iStack].path
   local moduleT      = moduleStack[iStack].moduleT

   local argA = pack(...)
   local a = {}
   for i = 1, argA.n do
      local b = argA[i]
      for name in b:split(" *, *") do
         a[#a+1] = name
      end
   end
   moduleT.provides   = a
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- MC_Spider:whatis(): Collect the whatis messages into moduleT
-- @param self A MainControl object.
-- @param s whatis string.
function M.whatis(self,s)
   dbg.start{"MC_Spider:whatis(...)"}
   local moduleStack = optionTbl().moduleStack
   local iStack      = #moduleStack
   local path        = moduleStack[iStack].path
   local moduleT     = moduleStack[iStack].moduleT

   local _,_, key, value = s:find('^%s*([^: ]+)%s*:%s*(.*)')
   local k  = KeyT[key]
   if (k) then
      moduleT[key] = value
   end
   if (moduleT.whatis == nil) then
      moduleT.whatis ={}
   end
   moduleT.whatis[#moduleT.whatis+1] = s
   dbg.fini()
   return true
end

s_patLib = false
s_patDir = false
--------------------------------------------------------------------------
-- Track "LMOD_.*_LIB" and LMOD_.*_DIR environment variables or whatever
-- the site is called (See SitePackage.lua and StandardPackage.lua.)
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.setenv(self, name, value)
   dbg.start{"MC_Spider:setenv(name, value)"}

   save_set_env(name, value)

   if (not s_patLib) then
      local a  = {}
      a[#a+1]  = "^"
      a[#a+1]  = hook.apply("SiteName")
      a[#a+1]  = "_.*_LIB"
      s_patLib = concatTbl(a,"")
      a        = {}
      a[#a+1]  = "^"
      a[#a+1]  = hook.apply("SiteName")
      a[#a+1]  = "_.*_DIR"
      s_patDir = concatTbl(a,"")

      local t = {patDir = s_patDir, patLib = s_patLib}
      hook.apply("packagebasename", t)
      s_patDir = t.patDir
      s_patLib = t.patLib

      dbg.print{"Using s_patDir: ", s_patDir, " s_patLib: ", s_patLib, "\n"}
   end

   if (name:find(s_patLib)) then
      processLPATH(value)
   end
   if (name:find(s_patDir)) then
      processDIR(value)
   end
   dbg.fini("MC_Spider:setenv")
   return true
end

------------------------------------------------------------
-- Having pushenv just set the value in the environment works
-- as long as no site mixes pushenv and popenv in the same
-- modulefile.  Fix this when the time comes.

function M.pushenv(self, name, value)
   dbg.start{"MC_Spider:pushenv(name, value)"}
   save_set_env(name, value)
   dbg.fini()
   return true
end   

--------------------------------------------------------------------------
-- Pass-thru to Spider_append_path().
-- @param self A MainControl object.
-- @param t input table.
function M.prepend_path(self,t)
   dbg.start{"MC_Spider:prepend_path(t)"}
   Spider_append_path("prepend",t)
   dbg.fini()
   return true

end

--------------------------------------------------------------------------
-- Pass-thru to Spider_append_path().
-- @param self A MainControl object.
-- @param t input table.
function M.append_path(self,t)
   dbg.start{"MC_Spider:append_path(t)"}
   Spider_append_path("append",t)
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- Return True when in spider mode.
-- @param self A MainControl object.
function M.is_spider(self)
   dbg.start{"MC_Spider:is_spider()"}
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- Copy the family to moduleT
-- @param self A MainControl object.
-- @param value the family value

function M.family(self, value)
   dbg.start{"MC_Spider:family(\"value=\"",value,"\")"}
   local moduleStack   = optionTbl().moduleStack
   local iStack        = #moduleStack
   local path          = moduleStack[iStack].path
   local moduleT       = moduleStack[iStack].moduleT
   moduleT.family      = value
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- Copy the property to moduleT
-- @param self A MainControl object.
-- @param name the property name.
-- @param value the value.
function M.add_property(self, name, value)
   dbg.start{"MC_Spider:add_property(name=\"",name,"\", value=\"",value,"\")"}
   local moduleStack   = optionTbl().moduleStack
   local iStack        = #moduleStack
   local path          = moduleStack[iStack].path
   local moduleT       = moduleStack[iStack].moduleT
   local t             = moduleT.propT or {}
   t[name]             = t[name] or {}
   t[name][value]      = 1
   moduleT.propT = t
   dbg.fini()
   return true
end

--------------------------------------------------------------------------
-- MC_Spider:remove_property: Remove the property to moduleT
-- @param self A MainControl object.
-- @param name the of the property.
-- @param value the value.
function M.remove_property(self, name, value)
   dbg.start{"MC_Spider:remove_property(name=\"",name,"\", value=\"",value,"\")"}
   local moduleStack   = optionTbl().moduleStack
   local iStack        = #moduleStack
   local path          = moduleStack[iStack].path
   local moduleT       = moduleStack[iStack].moduleT
   local t             = moduleT.propT or {}
   t[name]             = t[name] or {}
   t[name][value]      = nil
   moduleT.propT = t
   dbg.fini()
   return true
end

return M
