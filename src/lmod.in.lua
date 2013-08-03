#!@path_to_lua@/lua
-- -*- lua -*-

--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
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

BaseShell       = {}
Pager           = "@path_to_pager@"
s_prependBlock  = "@prepend_block@"
prepend_order   = false
allow_dups      = false

------------------------------------------------------------------------
-- Extract directory location of "lmod" command and add it
-- to the lua search path
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Use command name to add the command directory to the package.path
------------------------------------------------------------------------
local LuaCommandName = arg[0]
local i,j = LuaCommandName:find(".*/")
local LuaCommandName_dir = "./"
if (i) then
   LuaCommandName_dir = LuaCommandName:sub(1,j)
end

package.path = LuaCommandName_dir .. "../tools/?.lua;" ..
               LuaCommandName_dir .. "?.lua;"       ..
               LuaCommandName_dir .. "?/init.lua;"  ..
               package.path

package.cpath = LuaCommandName_dir .. "../lib/?.so;"..
                package.cpath


require("strict")
require("myGlobals")

local term     = false
if (pcall(require, "term")) then
   term = require("term")
end

function cmdDir()
   return LuaCommandName_dir
end

local getenv = os.getenv
local rep    = string.rep

function set_prepend_order()
   local ansT = {
      no      = "reverse",
      reverse = "reverse",
      normal  = "normal",
      yes     = "normal",
   }

   local order = ansT[getenv("LMOD_PREPEND_BLOCK") or s_prependBlock] or "normal"
   if (order == "normal") then
      prepend_order = function (n)
         return n, 1, -1
      end
   else
      prepend_order = function (n)
         return 1, n, 1
      end
   end
end


require("utils")
require("pager")
require("fileOps")
MasterControl = require("MasterControl")
require("modfuncs")
require("cmdfuncs")
require("colorize")

Cache         = require("Cache")
Master        = require("Master")
MT            = require("MT")
Exec          = require("Exec")

local BeautifulTbl = require('BeautifulTbl')
local Dbg          = require("Dbg")
local MName        = require("MName")
local Version      = require("Version")
local concatTbl    = table.concat
local unpack       = unpack or table.unpack

function set_duplication()
   local dbg  = Dbg:dbg()
   local dups = getenv("LMOD_DUPLICATE_PATH") or LMOD_DUPLICATE_PATH or "no"
   dups       = dups:lower()
   if (dups == "yes") then
      dbg.print("Allowing duplication in paths\n")
      allow_dups = function (dupsIn)
         return dupsIn
      end
   else
      dbg.print("No duplication allowed in paths\n")
      allow_dups = function (dupsIn)
         return false
      end
   end
end


function colorizePropA(style, moduleName, propT, legendT)
   local resultA      = { moduleName }
   local propDisplayT = getPropT()
   local iprop        = 0
   propT              = propT or {}

   for kk,vv in pairsByKeys(propDisplayT) do
      iprop        = iprop + 1
      local propA  = {}
      local t      = propT[kk]
      local result = ""
      local color  = nil
      if (type(t) == "table") then
         for k in pairs(t) do
            propA[#propA+1] = k
         end

         table.sort(propA);
         local n = concatTbl(propA,":")

         if (vv.displayT[n]) then
            result     = vv.displayT[n][style]
            color      = vv.displayT[n].color
            local k    = colorize(color,result)
            legendT[k] = vv.displayT[n].doc
         end
      end
      local s             = colorize(color,result)
      resultA[#resultA+1] = s
   end
   return resultA
end


s_Usage = false

function Usage()
   if (s_Usage) then
      return s_Usage
   end
   local website = colorize("red","http://www.tacc.utexas.edu/tacc-projects/lmod")
   local line    = border(0)
   local a = {}
   a[#a+1] = { "module [options] sub-command [args ...]" }
   a[#a+1] = { "" }
   a[#a+1] = { "Help sub-commands:" }
   a[#a+1] = { "------------------" }
   a[#a+1] = { "  help", "",            "prints this message"}
   a[#a+1] = { "  help", "module [...]","print help message from module(s)"}
   a[#a+1] = { "" }
   a[#a+1] = { "Loading/Unloading sub-commands:" }
   a[#a+1] = { "-------------------------------" }
   a[#a+1] = { "  load | add",         "module [...]",  "load module(s)"}
   a[#a+1] = { "  try-load | try-add", "module [...]",  "Add module(s), do not complain if not found"}
   a[#a+1] = { "  del | unload",       "module [...]",  "Remove module(s), do not complain if not found"}
   a[#a+1] = { "  swap | sw | switch", "m1 m2",         "unload m1 and load m2" }
   a[#a+1] = { "  purge",              "",              "unload all modules"}
   a[#a+1] = { "  refresh",            "",              "reload aliases from current list of modules."}
   a[#a+1] = { "  update",             "",              "reload all currently loaded modules."}
   a[#a+1] = { "" }
   a[#a+1] = { "Listing / Searching sub-commands:" }
   a[#a+1] = { "---------------------------------" }
   a[#a+1] = { "  list",         "",             "List loaded modules"}
   a[#a+1] = { "  list",         "s1 s2 ...",    "List loaded modules that match the pattern"}
   a[#a+1] = { "  avail | av",   "",             "List available modules"}
   a[#a+1] = { "  avail | av",   "string",       "List available modules that contain \"string\"."}
   a[#a+1] = { "  spider",       "",             "List all possible modules"}
   a[#a+1] = { "  spider",       "module",       "List all possible version of that module file"}
   a[#a+1] = { "  spider",       "string",       "List all module that contain the \"string\"."}
   a[#a+1] = { "  spider",       "name/version", "Detailed information about that version of the module."}
   a[#a+1] = { "  whatis",       "module",       "Print whatis information about module"}
   a[#a+1] = { "  keyword | key","string",       "Search all name and whatis that contain \"string\"."}
   a[#a+1] = { "" }
   a[#a+1] = { "Searching with Lmod:"}
   a[#a+1] = { "--------------------" }
   a[#a+1] = { "  All searching (spider, list, avail, keyword) support regular expressions:"}
   a[#a+1] = { "" }
   a[#a+1] = { "  spider", "'^p'",  "Finds all the modules that start with `p' or `P'"}
   a[#a+1] = { "  spider", "mpi",   "Finds all modules that have \"mpi\" in their name."}
   a[#a+1] = { "  spider", "'mpi$", "Finds all modules that end with \"mpi\" in their name."}
   a[#a+1] = { "" }
   a[#a+1] = { "Handling a collection of modules:"}
   a[#a+1] = { "--------------------------------" }
   a[#a+1] = { "  save | s",    "",       "Save the current list of modules to a user defined \"default\"."}
   a[#a+1] = { "  save | s",    "name",   "Save the current list of modules to \"name\" collection."}
   a[#a+1] = { "  restore | r", "",       "Restore modules from the user's \"default\" or system default."}
   a[#a+1] = { "  restore | r", "name",   "Restore modules from \"name\" collection."}
   a[#a+1] = { "  restore",     "system", "Restore module state to system defaults."}
   a[#a+1] = { "  savelist",    "",       "List of saved collections."}
   a[#a+1] = { "" }
   a[#a+1] = { "Deprecated commands:"}
   a[#a+1] = { "--------------------"}
   a[#a+1] = { "  reset",     "",        "The same as \"restore system\""}
   a[#a+1] = { "  getdefault", "[name]", "load name collection of modules or "..
                                         "user's \"default\" if no name given."}
   a[#a+1] = { "",            "",        "===> Use \"restore\" instead  <===="}
   a[#a+1] = { "  setdefault","[name]",  "Save current list of modules to name if given, "..
                                         "otherwise save as the default list for you the user."}
   a[#a+1] = { "",            "",        "===> Use \"save\" instead. <===="}
   a[#a+1] = { "" }
   a[#a+1] = { "Miscellaneous sub-commands:"}
   a[#a+1] = { "---------------------------"}
   a[#a+1] = { "  show",     "modulefile", "show the commands in the module file."}
   a[#a+1] = { "  use [-a]", "path",       "Prepend or Append path to MODULEPATH."}
   a[#a+1] = { "  unuse",    "path",       "remove path from MODULEPATH."}
   a[#a+1] = { "  tablelist","",           "output list of active modules as a lua table."}
   a[#a+1] = { "" }
   a[#a+1] = { "Important Environment Variables:"}
   a[#a+1] = { "--------------------------------"}
   a[#a+1] = { "  LMOD_COLORIZE", "", "If defined to be \"YES\" then Lmod prints "..
                                      "properties and warning in color."}
   a[#a+1] = { "" }
   a[#a+1] = { line}
   a[#a+1] = { "The following guides are at "..website}
   a[#a+1] = { "" }
   a[#a+1] = { "  User Guide                 - How to use."}
   a[#a+1] = { "  Advance User Guide         - How to create you own modules."}
   a[#a+1] = { "  System Administrator Guide - How to install Lmod on your own system."}
   a[#a+1] = { line }


   local dbg    = Dbg:dbg()
   local twidth = TermWidth()
   local bt     = BeautifulTbl:new{tbl=a, column = twidth-1, len = length, wrapped=true}
   s_Usage      = bt:build_tbl()

   return s_Usage
end



CmdLineUsage = "module [options] sub-command [args ...]"

--Usage = [[
--module sub-command [args ...]
--
--Help sub-commands:
--  help                                   prints this message
--  help               modulefile [...]    print help message from module(s)
--
--Loading/Unloading sub-commands:
--  add | load         modulefile [...]    Add module(s)
--  try-load | try-add modulefile [...]    Add module(s), do not complain if
--                                         not found
--  del | rm | unload  modulefile [...]    Remove module(s), do not complain
--                                         if not found
--  swap | sw | switch modfile1 modfile2   unload modfile1 and load modfile2
--  purge                                  unload all modules
--  refresh                                reload aliases from current list of
--                                         modules.
--
--Listing / Searching sub-commands:
--  list                                   List loaded modules
--  list             s1 s2 ...             List loaded modules that match the s1
--                                         pattern or the s2 pattern etc.
--  avail | av                             List available modules
--  avail | av       string                List available modules that contain
--                                         "string".
--  spider                                 List all possible modules
--  spider           modulefile            List all possible version of that
--                                         module file
--  spider           string                List all module that contain the
--                                         string.
--  spider           modulefile/version    Detailed information about that
--                                         version of the module
--  whatis           modulefile            print whatis information about module
--  keyword | key    string                search all name and whatis that contain
--                                         "string".
--
--
--Searching with Lmod:
--  All searching (spider, list, avail, keyword) support regular expressions:
--
--  spider        '^p'                     finds all the modules that start
--                                         with `p' or `P'
--
--  spider        mpi                      finds all modules that have "mpi"
--                                         in their name.
--  spider        'mpi$"                   file all modules that end with "mpi"
--                                         in their name.
--
--Handling a collection of modules:
--  save       | s | sd                    Save the current list of modules
--                                         to a user defined "default".
--  save name  | s name                    Save the current list of modules
--                                         to "name" collection.
--
--  restore                                Restore modules from the user's
--                                         "default" or system default.
--
--  restore  name | r name                 Restore modules from "name"
--                                         collection.
--
--  restore  system                        restore module state to system
--                                         defaults.
--
--
--  savelist                               list of saved collections.
--
--
--Deprecated commands
--   reset                                 The same as "restore system"
--   getdefault [name]                     load name collection of modules or
--                                         user's "default" if no name given.
--                                         ===> Use "restore" instead  <====
--
--   setdefault [name]                     Save current list of modules to
--                                         name if given, otherwise save as the
--                                         default list for you the user.
--                                         ===> Use "save" instead. <====
--
--
--Miscellaneous sub-commands:
--  record                                 save the module table.
--  show                modulefile         show the commands in the module file.
--  use [-a] [--append] path               Prepend or Append path to MODULEPATH
--  unuse path                             remove path from MODULEPATH
--  tablelist                              output list of active modules as a
--                                         lua table.
--
--Important Environment Variables:
--  LMOD_COLORIZE                          If defined to be "YES" then Lmod
--                                         prints properties and warning in color.
--
------------------------------------------------------------------------------------
--See:
--
--   http://www.tacc.utexas.edu/tacc-projects/mclay/lmod
--
--for complete documentation. It contains:
--
--   User Guide                  - How to use.
--   Advance User Guide          - How to create you own modules.
--   System Administrator Guide  - If you want to install it on your own system.
--
------------------------------------------------------------------------------------
--]]
--

function version()
   local v = {}
   v[#v + 1] = "\nModules based on Lua: Version " .. Version.name().."\n"
   v[#v + 1] = "    by Robert McLay mclay@tacc.utexas.edu\n\n"
   return concatTbl(v,"")
end

require("serializeTbl")
require("string_split")
require("string_trim")

BaseShell          = require("BaseShell")
local Options      = require("Options")
local Spider       = require("Spider")
local Var          = require("Var")
local lfs          = require("lfs")
local posix        = require("posix")

function None()
   print ("None")
   FooBar=1
end


local function localvar(localvarA)
   local dbg = Dbg:dbg()
   for _, v in ipairs(localvarA) do
      local i = v:find("=")
      if (i) then
         local k  = v:sub(1,i-1)
         if (varTbl[k] == nil) then
            varTbl[k] = Var:new(k)
         end
         local vv = v:sub(i+1)
         dbg.print("setLocal(\"",k,"\", \"",vv,"\")\n")
         varTbl[k]:setLocal(vv)
      end
   end
end



add	     = None
rm	     = None
use          = None
unuse        = None
prtHdr       = None
avail        = Avail
list         = List

ModuleName = ""
ModuleFn   = ""



function main()
   local loadTbl      = { name = "load",        checkMPATH = true,  cmd = Load_Usr    }
   local tryAddTbl    = { name = "try-add",     checkMPATH = true,  cmd = Load_Try    }
   local unloadTbl    = { name = "unload",      checkMPATH = true,  cmd = UnLoad      }
   local refreshTbl   = { name = "refresh",     checkMPATH = false, cmd = Refresh     }
   local swapTbl      = { name = "swap",        checkMPATH = true,  cmd = Swap        }
   local purgeTbl     = { name = "purge",       checkMPATH = true,  cmd = Purge       }
   local resetTbl     = { name = "reset",       checkMPATH = true,  cmd = Reset       }
   local availTbl     = { name = "avail",       checkMPATH = false, cmd = Avail       }
   local listTbl      = { name = "list",        checkMPATH = false, cmd = List        }
   local tblLstTbl    = { name = "tablelist",   checkMPATH = false, cmd = TableList   }
   local helpTbl      = { name = "help",        checkMPATH = false, cmd = Help        }
   local whatisTbl    = { name = "whatis",      checkMPATH = false, cmd = Whatis      }
   local showTbl      = { name = "show",        checkMPATH = false, cmd = Show        }
   local useTbl       = { name = "use",         checkMPATH = true,  cmd = Use         }
   local unuseTbl     = { name = "unuse",       checkMPATH = true,  cmd = UnUse       }
   local updateTbl    = { name = "update",      checkMPATH = true,  cmd = Update      }
   local keywordTbl   = { name = "keyword",     checkMPATH = false, cmd = Keyword     }
   local saveTbl      = { name = "save",        checkMPATH = false, cmd = Save        }
   local gdTbl        = { name = "getDefault",  checkMPATH = false, cmd = GetDefault  }
   local restoreTbl   = { name = "restore",     checkMPATH = false, cmd = Restore     }
   local savelistTbl  = { name = "savelist",    checkMPATH = false, cmd = SaveList    }
   local spiderTbl    = { name = "spider",      checkMPATH = true,  cmd = SpiderCmd   }
   local recordTbl    = { name = "record",      checkMPATH = false, cmd = RecordCmd   }

   local cmdTbl = {
      ["try-add"]  = tryAddTbl,
      ["try-load"] = tryAddTbl,
      add          = loadTbl,
      apropos      = keywordTbl,
      av           = availTbl,
      avail        = availTbl,
      del          = unloadTbl,
      delete       = unloadTbl,
      dis          = showTbl,
      display      = showTbl,
      era          = unloadTbl,
      erase        = unloadTbl,
      gd           = gdTbl,
      getd         = gdTbl,
      getdefault   = gdTbl,
      help         = helpTbl,
      key          = keywordTbl,
      keyword      = keywordTbl,
      ld           = savelistTbl,
      li           = listTbl,
      list         = listTbl,
      listdefault  = savelistTbl,
      savelist     = savelistTbl,
      lo           = loadTbl,
      load         = loadTbl,
      purge        = purgeTbl,
      record       = recordTbl,
      refr         = updateTbl,
      refresh      = refreshTbl,
      reload       = updateTbl,
      remov        = unloadTbl,
      remove       = unloadTbl,
      reset        = resetTbl,
      restore      = restoreTbl,
      r            = restoreTbl,
      rm           = unloadTbl,
      s            = saveTbl,
      save         = saveTbl,
      sd           = saveTbl,
      setd         = saveTbl,
      setdefault   = saveTbl,
      show         = showTbl,
      spider       = spiderTbl,
      sw           = swapTbl,
      swap         = swapTbl,
      switch       = swapTbl,
      tablelist    = tblLstTbl,
      unlo         = unloadTbl,
      unload       = unloadTbl,
      unuse        = unuseTbl,
      update       = updateTbl,
      use          = useTbl,
      wh           = whatisTbl,
      whatis       = whatisTbl,
   }

   local dbg  = Dbg:dbg()
   MCP = MasterControl.build("load")
   mcp = MasterControl.build("load")

   -------------------------------------------------------------------
   -- Is io.stderr connected to a tty or not?
   -- Setup output and pager routines
   colorize = plain
   pager    = bypassPager
   local connectedTerm = false

   if (term and getenv("TERM")) then
      if (term.isatty(io.stderr)) then
         colorize = full_colorize
         pager    = usePager
         connectedTerm = true
      end
   end

   local lmod_colorize = getenv("LMOD_COLORIZE") or "@colorize@"
   if (lmod_colorize:lower() ~= "yes") then
      colorize = plain
   end


   dbg.set_prefix(colorize("red","Lmod"))

   local shell = barefilename(arg[1])
   if (BaseShell.isValid(shell)) then
      table.remove(arg,1)
   else
      shell = "bash"
   end


   local arg_str   = concatTbl(arg," ")
   local masterTbl = masterTbl()

   set_prepend_order()   -- Chose prepend_path order normal/reverse

   Options:options(CmdLineUsage)

   localvar(masterTbl.localvarA)

   if (masterTbl.debug or masterTbl.dbglvl) then
      dbg:activateDebug(masterTbl.dbglvl or 1)
   end
   dbg.start("lmod(", arg_str,")")
   dbg.print("Lmod Version: ",Version.name(),"\n")
   dbg.print("package.path: ",package.path,"\n")
   set_duplication()     -- Chose how to handle duplicate entries in a path.
   readRC()


   ------------------------------------------------------------------------
   --  The StandardPackage is where Lmod registers hooks.  Sites may
   --  override the hook functions in SitePackage.
   ------------------------------------------------------------------------
   require("StandardPackage")

   ------------------------------------------------------------------------
   -- Load a SitePackage Module.
   ------------------------------------------------------------------------

   local lmodPath = getenv("LMOD_PACKAGE_PATH") or ""
   for path in lmodPath:split(":") do
      path = path .. "/"
      path = path:gsub("//+","/")
      package.path  = path .. "?.lua;"      ..
                      path .. "?/init.lua;" ..
                      package.path

      package.cpath = path .. "../lib/?.so;"..
                      package.cpath
   end

   dbg.print("lmodPath: ", lmodPath,"\n")
   require("SitePackage")

   local cmdName = masterTbl.pargs[1]
   table.remove(masterTbl.pargs,1)

   ------------------------------------------------------------
   -- Must output local variables even when there is the command
   -- is not a valid command
   --
   -- So set [[checkMPATH]] to false by default and re-define when there
   -- is a valid command:

   local checkMPATH = false
   if (cmdTbl[cmdName] ) then
      checkMPATH = cmdTbl[cmdName].checkMPATH
   end

   -- print version and quit if requested.
   if (masterTbl.version) then
      io.stderr:write(version())
      os.exit(0)
   end

   -- print Configuration and quit.
   if (masterTbl.config) then
      local Configuration = require("Configuration")
      local configuration = Configuration:configuration()
      io.stderr:write(version())
      io.stderr:write(configuration:report(),"\n")
      os.exit(0)
   end

   -- Create the [[master]] object
   local master = Master:master(checkMPATH)
   master.shell = BaseShell.build(shell)
   local mt     = MT:mt()

   if (masterTbl.checkSyntax) then
      master.shell:setActive(false)
   end

   -- Output local vars
   master.shell:expand(varTbl)


   -- if Help was requested then quit.
   if (masterTbl.cmdHelp) then
      Help()
      os.exit(0)
   end

   if (masterTbl.reportMT) then
      io.stderr:write(mt:serializeTbl("pretty"),"\n")
      os.exit(0)
   end

   -- Now quit if command is unknown.

   if (cmdTbl[cmdName] == nil) then
      io.stderr:write(version())
      io.stderr:write(Usage(),"\n")
      LmodErrorExit()
   end

   if (cmdTbl[cmdName]) then
      local cmd = cmdTbl[cmdName].cmd
      cmdName   = cmdTbl[cmdName].name
      dbg.print("cmd name: ", cmdName,"\n")
      cmd(unpack(masterTbl.pargs))
   end

   -- Get a fresh mt as the command run above may have created
   -- a new one.
   mt = MT:mt()

   -- Report any changes (worth reporting from original MT)
   if (not expert()) then
      mt:reportChanges()
   end

   dbg.print("mt: ",tostring(mt),"\n")
   -- Store the Module table in "_ModuleTable_" env. var.
   local n        = mt:name()
   local oldValue = getMT() or ""
   local value    = mt:serializeTbl()

   if (oldValue ~= value) then
      varTbl[n] = Var:new(n)
      varTbl[n]:set(value)
      dbg.print("Writing out _ModuleTable_\n")
   end
   dbg.fini("Lmod")

   -- Output all newly created path and variables.
   master.shell:expand(varTbl)

   -- Expand any shell command registered.
   Exec:exec():expand()

   if (getWarningFlag() and not expert() ) then
      LmodErrorExit()
   end
end

main()
