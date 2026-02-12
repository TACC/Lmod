--------------------------------------------------------------------------
-- This derived class of MainControl just prints ever module
-- command.
--
-- @classmod MC_Show

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
--  Copyright (C) 2008-2025 Robert McLay
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
local pack            = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat
local MainControl     = require("MainControl")
local MarkdownDetector  = require("MarkdownDetector")
local MarkdownProcessor = require("MarkdownProcessor")
local setenv_posix  = posix.setenv
MC_Show             = inheritsFrom(MainControl)
MC_Show.my_name     = "MC_Show"
MC_Show.my_sType    = "load"
MC_Show.my_tcl_mode = "display"
MC_Show.report      = MainControl.warning

local A             = ShowResultsA
local M             = MC_Show
local dbg           = require("Dbg"):dbg()
local concatTbl     = table.concat
M.accessMode        = MainControl.quiet
M.myFileName        = MainControl.myFileName
M.myModuleFullName  = MainControl.myModuleFullName
M.myModuleName      = MainControl.myModuleName
M.myModuleVersion   = MainControl.myModuleVersion
M.myModuleUsrName   = MainControl.myModuleUsrName
M.build_unload      = MainControl.do_not_build_unload
M.color_banner      = MainControl.color_banner

local function l_ShowCmd(name, first_elem, ...)
   local argT
   if (type(first_elem) == "table") then
      if (next(first_elem) ~= nil ) then
         argT      = first_elem
         argT.kind = argT.kind or "Table"
         argT.n    = #argT
      else
         argT      = {n = 0, kind = "Array"}
      end
   else
      argT = pack(first_elem, ...)
   end

   if (argT.kind == "Table") then
      A[#A+1] = ShowCmdTbl(name, argT)
   else
     dbg.printT("l_ShowCmd: argT",argT)
     A[#A+1] = ShowCmdStr(name, argT)
   end
end

local function l_Show_help(...)
   local argA = pack(...)
   for i = 1, argA.n do
      local content = argA[i]
      -- For show mode, display original content with markdown detection info
      local isMarkdown = MarkdownDetector.isMarkdown(content)
      if isMarkdown then
         A[#A+1] = "-- This help content will be processed as markdown in terminal display\n"
      end
   end
   A[#A+1] = ShowHelpStr(...)
end

--------------------------------------------------------------------------
-- Print help command.
-- @param self A MainControl object
function M.help(self, ...)
   l_Show_help(...)
end

--------------------------------------------------------------------------
-- Print extensions command.
-- @param self A MainControl object
function M.extensions(self, ...)
   l_ShowCmd("extensions",...)
end

--------------------------------------------------------------------------
-- Print whatis command.
-- @param self A MainControl object
-- @param value the whatis string.
function M.whatis(self, value)
   -- For show mode, display original content with markdown detection info
   local isMarkdown = MarkdownDetector.isMarkdown(value)
   if isMarkdown then
      A[#A+1] = "-- This whatis content will be processed as markdown in terminal display\n"
   end
   l_ShowCmd("whatis", value)
end

--------------------------------------------------------------------------
-- Print export_shell_function command.
-- @param self A MainControl object
-- @param value the whatis string.
function M.export_shell_function(self, value)
   l_ShowCmd("export_shell_function", value)
end

--------------------------------------------------------------------------
-- Print exit command.
-- @param self A MainControl object
-- @param value the whatis string.
function show_exit(value)
   l_ShowCmd("os.exit", value)
end

--------------------------------------------------------------------------
-- Print execute command.
-- @param self A MainControl object.
-- @param t Input table describing shell command.
function M.execute(self, t)
   local a = {}
   a[#a+1] = "execute{cmd=\""
   a[#a+1] = t.cmd
   a[#a+1] = "\", modeA={\""
   a[#a+1] = concatTbl(t.modeA, "\", \"")
   a[#a+1] = "\"}}\n"
   A[#A+1] = concatTbl(a,"")
end

--------------------------------------------------------------------------
-- Print prepend_path command.
-- @param self A MainControl object
-- @param t input table
function M.prepend_path(self, t)
   l_ShowCmd("prepend_path", t)
end

--------------------------------------------------------------------------
-- Print add_property command.
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.add_property(self, name,value)
   l_ShowCmd("add_property", name, value)
end

--------------------------------------------------------------------------
-- Print set_alias command.
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.remove_property(self, name,value)
   l_ShowCmd("remove_property", name, value)
end

--------------------------------------------------------------------------
-- Print message command.
-- @param self A MainControl object.
function M.message(self, ...)
   l_ShowCmd("LmodMessage", ...)
end

--------------------------------------------------------------------------
-- Print message raw command.
-- @param self A MainControl object.
function M.msg_raw(self, ...)
   l_ShowCmd("LmodMsgRaw", ...)
end

--------------------------------------------------------------------------
-- Print set_alias command.
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.set_alias(self, name,value)
   l_ShowCmd("set_alias", name, value)
end

--------------------------------------------------------------------------
-- Print pushenv command.
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.pushenv(self, argT)
   local name  = argT[1]
   local value = argT[2]
   if (value == false) then
      value = nil
   end
   setenv_posix(name, value, true)
   l_ShowCmd("pushenv", argT)
end

--------------------------------------------------------------------------
-- Print unset_alias command.
-- @param self A MainControl object
-- @param name the environment variable name.
function M.unset_alias(self, name)
   l_ShowCmd("unset_alias",name)
end

--------------------------------------------------------------------------
-- Print append_path command.
-- @param self A MainControl object
-- @param t input table
function M.append_path(self, argT)
   l_ShowCmd("append_path", argT)
end

--------------------------------------------------------------------------
-- Print setenv command.
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.setenv(self, argT)
   local name  = argT[1]
   local value = argT[2]
   if (value == false) then
      value = nil
   end
   setenv_posix(name, value, true)
   l_ShowCmd("setenv", argT)
end

--------------------------------------------------------------------------
-- Print unsetenv command.
-- @param self A MainControl object.
-- @param name the environment variable name.
-- @param value the environment variable value.
function M.unsetenv(self, argT)
   local name  = argT[1]
   setenv_posix(name, nil, true)
   l_ShowCmd("unsetenv", argT)
end

--------------------------------------------------------------------------
-- Print remove_path command.
-- @param self A MainControl object
-- @param t input table
function M.remove_path(self, argT)
   l_ShowCmd("remove_path", argT)
end

--------------------------------------------------------------------------
-- Print load command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.load(self, mA)
   A[#A+1] = ShowCmdA("load",mA)
end

--------------------------------------------------------------------------
-- Print load_any command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.load_any(self, mA)
   A[#A+1] = ShowCmdA("load_any",mA)
end

--------------------------------------------------------------------------
-- Print mgrload command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.mgrload(self, required, active)
   A[#A+1] = l_ShowCmd("mgrload",required, active)
end

--------------------------------------------------------------------------
-- Print depends_on command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.depends_on(self, mA)
   A[#A+1] = ShowCmdA("depends_on",mA)
end

--------------------------------------------------------------------------
-- Print depends_on_any command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.depends_on_any(self, mA)
   A[#A+1] = ShowCmdA("depends_on_any",mA)
end

--------------------------------------------------------------------------

M.load_usr = M.load

--------------------------------------------------------------------------
-- Print try_load command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.try_load(self, mA)
   A[#A+1] = ShowCmdA("try_load",mA)
end

M.try_add = M.try_load

--------------------------------------------------------------------------
-- Adds indent and prints contents of inherited module
-- @param self A MainControl object
function M.inherit(self, ...)
   dbg.start{"MC_Show:inherit()"}
   l_ShowCmd("inherit",...)
   local hub = Hub:singleton()
   s_indent(1)
   hub.inheritModule()
   s_indent(-1)
   dbg.fini("MC_Show:inherit()")
end

--------------------------------------------------------------------------
-- Print family command.
-- @param self A MainControl object
function M.family(self, ...)
   l_ShowCmd("family",...)
end

--------------------------------------------------------------------------
-- Print unload command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.unload(self, mA)
   A[#A+1] = ShowCmdA("unload",mA)
end

--------------------------------------------------------------------------
-- Print alway_load command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.always_load(self, mA)
   A[#A+1] = ShowCmdA("always_load",mA)
end

--------------------------------------------------------------------------
-- Print always_unload command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.always_unload(self, mA)
   A[#A+1] = ShowCmdA("always_unload",mA)
end

--------------------------------------------------------------------------
-- Print prereq command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.prereq(self, mA)
   A[#A+1] = ShowCmdA("prereq",mA)
end

--------------------------------------------------------------------------
-- Print prereq_any command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.prereq_any(self, mA)
   A[#A+1] = ShowCmdA("prereq_any",mA)
end

--------------------------------------------------------------------------
-- Print conflict command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.conflict(self, mA)
   A[#A+1] = ShowCmdA("conflict",mA)
end

--------------------------------------------------------------------------
-- Print conflict command.
-- @param self A MainControl object
-- @param mA An array of module names (MName objects)
function M.haveDynamicMPATH(self, mA)
   A[#A+1] = ShowCmdA("haveDynamicMPATH",mA)
end

--------------------------------------------------------------------------
-- Print set shell function
-- @param self A MainControl object
function M.set_shell_function(self, name, bashStr, cshStr)
   local a = {}
   name    = name    or "<unknown>"
   bashStr = bashStr or ""
   cshStr  = cshStr  or ""

   a[#a+1] = "set_shell_function("
   a[#a+1] = '"'..name..'",'
   a[#a+1] = bashStr:doubleQuoteString()..','
   a[#a+1] = cshStr:doubleQuoteString()..')\n'
   A[#A+1] = concatTbl(a,"")
end

--------------------------------------------------------------------------
-- Print unset shell function
-- @param self A MainControl object
function M.unset_shell_function(self, ...)
   l_ShowCmd("set_shell_function", ...)
end

function M.LmodBreak(self, msg)
   l_ShowCmd("LmodBreak", msg)
end

function M.source_sh(self, shell, script)
   l_ShowCmd("--source_sh", shell, script)
   MainControl.source_sh(self, shell, script)
end

function M.complete(self, ...)
   l_ShowCmd("complete", ...)
end

function M.uncomplete(self, ...)
   l_ShowCmd("uncomplete", ...)
end

function M.purge(self, ...)
    l_ShowCmd("purge", ...)
end

return M
