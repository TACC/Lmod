
local posix      = require("posix")
_G._DEBUG        = false

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

local M              = {}
local getenv         = os.getenv
local s_envT         = {}
local s_remove_pathA = nil
local s_replacementA = nil
local s_path_search  = ":"
local s_envA         = {
   "HOME",
   "gitV",
   "PATH_to_SHA1",
   "SHA1SUM",
   "PATH_to_LUA",
   "PATH_TO_SED",
   "PATH_to_TM",
   "outputDir",
   "projectDir",
   "old",
   "new",
}

local function l_init_envTable(self)
   for i = 1, #s_envA do
      local n   = s_envA[i]
      local v   = getenv(n)
      if (not v) then
         io.stderr:write(n," is unknown\n")
      end
      s_envT[n] = v:escape() or "UNKNOWN"
   end
   local path_to_hashsum = " "..s_envT.PATH_to_SHA1.."/"..s_envT.SHA1SUM
   local banner          = "============================="
   s_replacementA = {
      {"@".."git@",                           s_envT.gitV          },
      {s_envT.PATH_to_LUA .. "/lua",          "lua"                },
      {s_envT.outputDir,                      "OutputDIR"          },
      {s_envT.projectDir,                     "ProjectDIR"         },
      {s_envT.old,                            s_envT.new,          },
      {s_envT.PATH_to_TM,                     "PATH_to_TM"         },
      {path_to_hashsum,                       " PATH_to_HASHSUM"   },
      {s_envT.HOME,                           "~"                  },
      {"/usr/.*/sha1sum",                     "PATH_to_HASHSUM"    },
      {"/bin/.*/sha1sum|PATH_to_HASHSUM|g",   "PATH_to_HASHSUM"    },
      {"\027",                                "\\\\033"            },   -- Real Escape to string \033
      {"\\27",                                "\\\\033"            },   -- Real Escape to string \033
      {'"%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d"',    '"YYYY-MM-DDTHH:mm"' },
      {'"%d%d%d%d%-%d%d%-%d%d"',              '"YYYY-MM-DD"'       },
      {"^(TARG_HOST=).*",                     "%1'some_host';"     },
      {"^(TARG_OS_FAMILY=).*",                "%1'some_os_family';"},
      {"^(TARG_OS=).*",                       "%1'some_os';"       },
      {"^(TARG_MACH_DESCRIPT=).*",            "%1'some_descript';" },
      {"^(uname %-a).*",                      "%1"                 },
      {" *%-%-%-%-* *",                       ""                   },
      {"^ *OutputDIR",                        " OutputDIR"         },
      {"^%-%-* *",                            " "                  },             
      {"%-%-%-* *$",                          ""                   },
      {"attempt to call.*WTF.*",              ""                   },
      {".*_AST_FEATURES.*",                   ""                   },
      {"[(]file \"ProjectDIR/rt/end2end.*",   ""                   },
      {"[(]file \"OutputDIR/lmod/lmod/.*",    ""                   },
      {"^ *=============================* *", banner               },
      {"  *$",                                ""                   },
      {"^ *$",                                ""                   }, 
   }

   s_remove_pathA = {
      s_envT.PATH_to_LUA,
      s_envT.PATH_to_SHA1,
      s_envT.PATH_TO_SED,
      "/usr/local/bin",
      "/usr/bin",
      "/bin",
      "/opt/homebrew/bin",
   }
end

local s_removeA = {
   "^User shell.*",
   "^Lua Version.*",
   "^ *Lmod [Vv]ersion.*",
   "^Lmod branch.*",
   "^LMOD BRANCH.*",
   "^LuaFileSystem version.*",
   "^LMOD_LD_PRELOAD.*",
   "^LD_PRELOAD at config time.*",
   "^LD_LIBRARY_PATH at config time.*",
   "Sys.setenv%(._ModuleTable..._.*",
   "Sys.setenv%(._ModuleTable_Sz_.*",
   "unsetenv _ModuleTable..._;",
   "unset _ModuleTable..._.*",
   "unset _ModuleTable..._.*",
   "^Admin file.*",
   "^MODULERC.*",
   "^Changes from Default Configuration.*",
   "^Name * Default *Value.*",
   "^Name * Where Set *Default *Value.*",
   "^Where Set.*",
   "^ *lmod_cfg: l.*",
   "^ *Other: Set.*",
   "^LFS_VERSION.*",
   "^Active lua%-term.*",
   "^.*Rebuilding cache.*done",
   "^.*Using your spider cache file",
   "^_ModuleTable_Sz_=.*",
   "^set.* _ModuleTable_Sz_ .*",
   "^%-%%%%%-.*",
   "^%-%-%%%%%-%-.*",
   "^ *$",
}

local function l_remove(line)
   for i = 1, #s_removeA do
      local entry = s_removeA[i]
      if (line:find(entry)) then
         return true
      end
   end
   return false
end   

local function l_replacement(line)
   for i = 1, #s_replacementA do
      local entry = s_replacementA[i]
      line = line:gsub(entry[1],entry[2])
   end
   return line
end



local l_add_mark
local l_remove_mark
local l_build_patt
local l_isPath
------------------------------------------------------------
-- Bash functions

local function l_add_mark_bash(kind, line)
   if (kind == "_REF_COUNT_") then
      return line:gsub("([^=]*=)(.*)(;*);", "%1\\;%2\\;;" )
   end
   return line:gsub("([^=]*=)(.*);", "%1:%2:;" )
end

local function l_remove_mark_bash(kind, line)
   if (kind == "_REF_COUNT_") then
      return line:gsub("([^=]*=)\\;(.*)\\;;", "%1%2;" )
   end
   return line:gsub("([^=]*=):(.*):;", "%1%2;" )
end   
local function l_patt_bash(kind, path)
   if (kind == "_REF_COUNT_") then
      return "\\;"..path..":%d\\;", "\\;"
   end
   return ":"..path..":", ":"
end

------------------------------------------------------------
-- Csh functions

local function l_add_mark_csh(kind, line)
   if (kind == "_REF_COUNT_") then
      return line:gsub("(setenv  *[^ ]* )(.*);", "%1\\;%2\\;;" )
   end
   return line:gsub("(setenv  *[^ ]* )(.*);", "%1:%2:;" )
end

local function l_remove_mark_csh(kind, line)
   if (kind == "_REF_COUNT_") then
      return line:gsub("(setenv  *[^ ]* )\\;(.*)\\;;", "%1%2;" )
   end
   return line:gsub("(setenv  *[^ ]* ):(.*):;", "%1%2;" )
end

------------------------------------------------------------
-- Fish functions

local function l_add_mark_fish(kind, line)
   if (kind == "_REF_COUNT_") then
      return line:gsub("(set %-x %-g [^ ]* )(.*);", "%1\\;%2\\;;" )
   end
   return line
end
local function l_remove_mark_fish(kind, line)
   if (kind == "_REF_COUNT_") then
      return line:gsub("(set %-x %-g  *[^ ]* )\\;(.*)\\;;", "%1%2;" )
   end
   return line
end

local function l_patt_fish(kind, path)
   if (kind == "_REF_COUNT_") then
      return "\\;"..path..":%d\\;", "\\;"
   end
   return " "..path.."([ ;])", "%1"
end

local function l_isPath_fish(kind,line)
   local result = nil
   if (kind == "_REF_COUNT_" ) then
      result = line:find(kind,1,true)
   elseif (line:find("_REF_COUNT_")) then
      return false
   else
      local i, j, varName = line:find("set %-x %-g  *([^ ]*)")
      result = varName and varName:find("PATH")
   end
   return result
end

------------------------------------------------------------
-- Nushell functions

local function l_add_mark_nushell(kind, line)
   if (kind == "_REF_COUNT_") then
      return line:gsub("(%$env%.[^ ]* = )r#'(.*)'#;", "%1r#';%2;'#;" )
   end
   return line  -- No marking required here
end
local function l_remove_mark_nushell(kind, line)
   if (kind == "_REF_COUNT_") then
      return line:gsub("(%$env%.[^ ]* = )r#';(.*);'#;", "%1r#'%2'#;" )
   end
   return line  -- No unmarking required here
end
local function l_patt_nushell(kind, path)
   if (kind == "_REF_COUNT_") then
      return ";"..path..":%d;", ";"
   end
   return " *r#'"..path.."'#,", ""
end

local function l_isPath_common(kind,line)
   return line:find(kind,1,true)
end


local function l_remove_paths(kind, line)
   if (not l_isPath(kind,line) ) then
      return line
   end
   line       = l_add_mark(kind, line)
   for i = 1, #s_remove_pathA do
      local path      = s_remove_pathA[i]
      local patt, rpl = l_build_patt(kind, path)
      line            = line:gsub(patt,rpl)
   end
   return l_remove_mark(kind, line)
end

local s_markFuncT = {
   bash    = {add = l_add_mark_bash,    remove = l_remove_mark_bash,    search = ":",  isPath = l_isPath_common, buildPatt = l_patt_bash},
   csh     = {add = l_add_mark_csh,     remove = l_remove_mark_csh,     search = ":",  isPath = l_isPath_common, buildPatt = l_patt_bash},
   fish    = {add = l_add_mark_fish,    remove = l_remove_mark_fish,    search = ":",  isPath = l_isPath_fish,   buildPatt = l_patt_fish},
   nushell = {add = l_add_mark_nushell, remove = l_remove_mark_nushell, search = "[",  isPath = l_isPath_common, buildPatt = l_patt_nushell},
}


function M.new(self, shellName)
   local o       = {}
   setmetatable(o,self)
   self.__index  = self
   self.__shell  = shellName
   l_add_mark    = s_markFuncT[shellName].add
   l_remove_mark = s_markFuncT[shellName].remove
   l_build_patt  = s_markFuncT[shellName].buildPatt
   l_isPath      = s_markFuncT[shellName].isPath
   s_path_search = s_markFuncT[shellName].search
   l_init_envTable(self)
   return o
end

function M.filter(self, whole)
   local a = {}
   for line in whole:split("\n") do
      repeat
         local empty = l_remove(line)
         if (empty) then break end
         line = l_remove_paths("_REF_COUNT_", line)
         line = l_remove_paths(s_path_search, line)
         line = l_replacement(line)
         if (line and line:len() > 0) then
            a[#a+1] = line
         end
      until true
   end
   return a
end

return M
