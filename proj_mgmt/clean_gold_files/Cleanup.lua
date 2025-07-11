
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
local s_envRplA      = {}
local s_replacementA = {}
local s_envA         = {
   "HOME",
   "gitV",
   "PATH_to_SHA1",
   "SHA1SUM",
   "PATH_to_LUA",
   "PATH_TO_SED",
   "PATH_TO_TM",
   "outputDir",
   "projectDir",
   "old",
   "new",
}

local function l_init_envTable(self)
   for i = 1, s_envA do
      n = s_envA[i]
      v = getenv(n)
      s_envT[n] = v
   end
   s_replacementA = {
      {s_envT.HOME,                        "~"                  },
      {"@".."git@",                        s_envT.gitV          },
      {s_envT.outputDir,                   "OutputDIR"          },
      {s_envT.projectDir,                  "ProjectDIR"         },
      {"\027",                             "\\033"              },   -- Real Escape to string \033
      {'"%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d"', '"YYYY-MM-DDTHH:mm"' },
      {'"%d%d%d%d%-%d%d%-%d%d"',           '"YYYY-MM-DD"'       },
      {"^(TARG_HOST=).*",                  "%1'some_host'"      },
      {"^(TARG_OS_FAMILY=).*",             "%1'some_os_family'" },
      {"^(TARG_OS=).*",                    "%1'some_os'"        },
      {"^(TARG_MACH_DESCRIPT=).*",         "%1'some_descript'"  },
      {"^(uname -a).*",                    "%1"                 },
      {"^ *OutputDIR",                     " OutputDIR"         },
      {"attempt to call.*WTF.*",           ""                   },
      {".*_AST_FEATURES.*",                ""                   },
      {"(file \"ProjectDIR/rt/end2end.*)", ""                   },
      {"(file \"OutputDIR/lmod/lmod/.*)",  ""                   },
      {"^ *$",                             ""                   }, 
   }
   s_envRplT = {
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
   "^Active lua-term.*",
   "^.*Rebuilding cache.*done",
   "^.*Using your spider cache file",
   "^_ModuleTable_Sz_=.*",
   "^set.* _ModuleTable_Sz_ .*",
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

function M.new(self)
   local o       = {}
   setmetatable(o,self)
   self.__index = self

   l_init_envTable(self)
   return o
end

function M.filter(self, whole)
   local a = {}
   for line in whole:split("\n") do
      repeat
         local empty = l_remove(line)
         if (empty) then break end
         line = l_replacement(line)
         if (line:len() > 0) then
            a[#a+1] = line
         end
      until true
   end
   return a
end

return M
