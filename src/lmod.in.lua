#!@path_to_lua@
-- -*- lua -*-

--------------------------------------------------------------------------
-- The main program for Lmod.
-- @script lmod

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
--  OF MERCHANTABILITY, FITNESS FOR A APRTICULAR PURPOSE AND
--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------

------------------------------------------------------------------------
-- Use command name to add the command directory to the package.path
------------------------------------------------------------------------

local sys_lua_path = "@sys_lua_path@"
if (sys_lua_path:sub(1,1) == "@") then
   sys_lua_path = package.path
end

local sys_lua_cpath = "@sys_lua_cpath@"
if (sys_lua_cpath:sub(1,1) == "@") then
   sys_lua_cpath = package.cpath
end

package.path   = sys_lua_path
package.cpath  = sys_lua_cpath

local arg_0    = arg[0]
_G._DEBUG      = false
local posix    = require("posix")
local readlink = posix.readlink
local stat     = posix.stat

local st       = stat(arg_0)
while (st.type == "link") do
   local lnk = readlink(arg_0)
   if (arg_0:find("/") and (lnk:find("^/") == nil)) then
      local dir = arg_0:gsub("/[^/]*$","")
      lnk       = dir .. "/" .. lnk
   end
   arg_0 = lnk
   st    = stat(arg_0)
end

local ia,ja = arg_0:find(".*/")
local LuaCommandName     = false
local LuaCommandName_dir = "./"
if (ia) then
   LuaCommandName_dir = arg_0:sub(1,ja)
   LuaCommandName     = arg_0:sub(ja+1)
end

package.path  = LuaCommandName_dir .. "?.lua;"       ..
                LuaCommandName_dir .. "../tools/?.lua;"  ..
                LuaCommandName_dir .. "../tools/?/init.lua;"  ..
                LuaCommandName_dir .. "../shells/?.lua;" ..
                LuaCommandName_dir .. "?/init.lua;"  ..
                sys_lua_path
package.cpath = LuaCommandName_dir .. "../lib/?.so;"..
                sys_lua_cpath

require("strict")

--------------------------------------------------------------------------
-- Return the path to the Lmod program
function cmdDir()
   return LuaCommandName_dir
end

--------------------------------------------------------------------------
-- Return this program's name.
function cmdName()
   return LuaCommandName
end

require("myGlobals")
require("TermWidth")
require("fileOps")
require("colorize")
require("pager")
require("string_utils")
require("cmdfuncs")
require("utils")

MainControl         = require("MainControl")

local Banner        = require("Banner")
local BaseShell     = require("BaseShell")
local BeautifulTbl  = require("BeautifulTbl")
local Exec          = require("Exec")
local FrameStk      = require("FrameStk")
local Options       = require("Options")
local Var           = require("Var")
local Version       = require("Version")
local concatTbl     = table.concat
local cosmic        = require("Cosmic"):singleton()
local dbg           = require("Dbg"):dbg()
local hook          = require("Hook")
local getenv        = os.getenv
local i18n          = require("i18n")
local max           = math.max
local timer         = require("Timer"):singleton()
local unpack        = (_VERSION == "Lua 5.1") and unpack or table.unpack -- luacheck: compat

local s_Usage       = false
--------------------------------------------------------------------------
-- Build the lmod usage message and store in *s_Usage*.
function Usage()
   if (s_Usage) then
      return s_Usage
   end
   local website = colorize("red","https://lmod.readthedocs.org/")
   local webBR   = colorize("red","https://lmod.readthedocs.io/en/latest/075_bug_reporting.html")
   local banner  = Banner:singleton()
   local line    = banner:border(2)
   local a = {}
   a[#a+1] = { i18n("usage_cmdline") }
   a[#a+1] = { "" }
   a[#a+1] = { i18n("help_title") }
   a[#a+1] = { "  help", "",            i18n("help1")}
   a[#a+1] = { "  help", "module [...]",i18n("help2")}
   a[#a+1] = { "" }
   a[#a+1] = { i18n("load_title") }
   a[#a+1] = { "  load | add",         "module [...]",  i18n("load1")}
   a[#a+1] = { "  try-load | try-add", "module [...]",  i18n("load2")}
   a[#a+1] = { "  del | unload",       "module [...]",  i18n("load3")}
   a[#a+1] = { "  swap | sw | switch", "m1 m2",         i18n("load4")}
   a[#a+1] = { "  purge",              "",              i18n("load5")}
   a[#a+1] = { "  refresh",            "",              i18n("load6")}
   a[#a+1] = { "  update",             "",              i18n("load7")}
   a[#a+1] = { "" }
   a[#a+1] = { i18n("list_title") }
   a[#a+1] = { "  list",          "",             i18n("list1")  }
   a[#a+1] = { "  list",          "s1 s2 ...",    i18n("list2")  }
   a[#a+1] = { "  avail | av",    "",             i18n("list3")  }
   a[#a+1] = { "  avail | av",    "string",       i18n("list4")  }
   a[#a+1] = { "  category | cat","",             "List all categories" }
   a[#a+1] = { "  category | cat","s1 s2 ...",    "List all categories that match the pattern and display their modules" }
   a[#a+1] = { "  overview | ov", "",             i18n("ov1")    }
   a[#a+1] = { "  overview | ov", "string",       i18n("ov2")    }
   a[#a+1] = { "  spider",        "",             i18n("list5")  }
   a[#a+1] = { "  spider",        "module",       i18n("list6")  }
   a[#a+1] = { "  spider",        "string",       i18n("list7")  }
   a[#a+1] = { "  spider",        "name/version", i18n("list8")  }
   a[#a+1] = { "  whatis",        "module",       i18n("list9")  }
   a[#a+1] = { "  keyword | key", "string",       i18n("list10") }
   a[#a+1] = { "" }
   a[#a+1] = { i18n("srch_title") }
   a[#a+1] = { i18n("srch0") }
   a[#a+1] = { "  "}
   a[#a+1] = { "" }
   a[#a+1] = { "  -r spider ", "'^p'",  i18n("srch1") }
   a[#a+1] = { "  -r spider ", "mpi",   i18n("srch2") }
   a[#a+1] = { "  -r spider ", "'mpi$", i18n("srch3") }
   a[#a+1] = { "" }
   a[#a+1] = { i18n("collctn_title") }
   a[#a+1] = { "  save | s",    "",         i18n("collctn1") }
   a[#a+1] = { "  save | s",    "name",     i18n("collctn2") }
   a[#a+1] = { "  reset",     "",           i18n("collctn3") }
   a[#a+1] = { "  restore | r", "",         i18n("collctn4") }
   a[#a+1] = { "  restore | r", "name",     i18n("collctn5") }
   a[#a+1] = { "  restore",     "system",   i18n("collctn6") }
   a[#a+1] = { "  savelist",    "",         i18n("collctn7") }
   a[#a+1] = { "  describe | mcc",  "name", i18n("collctn8") }
   a[#a+1] = { "  disable",         "name", i18n("collctn9") }
   a[#a+1] = { "" }
   a[#a+1] = { i18n("depr_title") }
   a[#a+1] = { "  getdefault", "[name]", i18n("depr1") }
   a[#a+1] = { "",            "",        i18n("depr2") }
   a[#a+1] = { "  setdefault","[name]",  i18n("depr3") }
   a[#a+1] = { "",            "",        i18n("depr4") }
   a[#a+1] = { "" }
   a[#a+1] = { i18n("misc_title") }
   a[#a+1] = { "  is-loaded", "modulefile", i18n("misc_isLoaded") }
   a[#a+1] = { "  is-avail",  "modulefile", i18n("misc_isAvail") }
   a[#a+1] = { "  show",      "modulefile", i18n("misc1") }
   a[#a+1] = { "  use [-a]",  "path",       i18n("misc2") }
   a[#a+1] = { "  unuse",     "path",       i18n("misc3") }
   a[#a+1] = { "  tablelist", "",           i18n("misc4") }
   a[#a+1] = { "" }
   a[#a+1] = { i18n("env_title") }
   a[#a+1] = { "  LMOD_COLORIZE", "",      i18n("env1") }
   a[#a+1] = { "" }
   a[#a+1] = { "" }
   a[#a+1] = { i18n("web_sites") }
   a[#a+1] = { "" }
   a[#a+1] = { "  Documentation:    https://lmod.readthedocs.org"}
   a[#a+1] = { "  GitHub:           https://github.com/TACC/Lmod"}
   a[#a+1] = { "  SourceForge:      https://lmod.sf.net"}
   a[#a+1] = { "  TACC Homepage:    https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"}
   a[#a+1] = { "" }
   a[#a+1] = { i18n("rpt_bug")..webBR }


   local twidth = TermWidth()
   local bt     = BeautifulTbl:new{tbl=a, column = twidth-1, len = length, wrapped=true}
   s_Usage      = bt:build_tbl()

   return s_Usage
end

--------------------------------------------------------------------------
-- Build the version string.
function version()
   local v = {}
   v[#v + 1] = "\nModules based on Lua: Version " .. Version.name().."\n"
   v[#v + 1] = "    by Robert McLay mclay@tacc.utexas.edu\n\n"
   return concatTbl(v,"")
end

--------------------------------------------------------------------------
-- The main function of Lmod.  The lmod program always starts here.
function main()
   if (LMOD_RTM_TESTING) then
      os.exit(0)
   end

   local epoch        = epoch
   local t1           = epoch()

   local availTbl     = { name = "cmdfuncs.lua:(Avail)         avail",       checkMPATH = false, cmd = Avail         }
   local gdTbl        = { name = "cmdfuncs.lua:(GetDefault)    getDefault",  checkMPATH = false, cmd = GetDefault    }
   local helpTbl      = { name = "cmdfuncs.lua:(Help)          help",        checkMPATH = false, cmd = Help          }
   local keywordTbl   = { name = "cmdfuncs.lua:(Keyword)       keyword",     checkMPATH = false, cmd = Keyword       }
   local listTbl      = { name = "cmdfuncs.lua:(List)          list",        checkMPATH = false, cmd = List          }
   local loadTbl      = { name = "cmdfuncs.lua:(Load_Usr)      load",        checkMPATH = true,  cmd = Load_Usr      }
   local mcTbl        = { name = "cmdfuncs.lua:(CollectionLst) describe",    checkMPATH = false, cmd = CollectionLst }
   local purgeTbl     = { name = "cmdfuncs.lua:(Purge_Usr)     purge",       checkMPATH = true,  cmd = Purge_Usr     }
   local overviewTbl  = { name = "cmdfuncs.lua:(Overview)      overview",    checkMPATH = false, cmd = Overview      }
   local refreshTbl   = { name = "cmdfuncs.lua:(Refresh)       refresh",     checkMPATH = false, cmd = Refresh       }
   local resetTbl     = { name = "cmdfuncs.lua:(Reset)         reset",       checkMPATH = true,  cmd = Reset         }
   local restoreTbl   = { name = "cmdfuncs.lua:(Restore)       restore",     checkMPATH = false, cmd = Restore       }
   local saveTbl      = { name = "cmdfuncs.lua:(Save)          save",        checkMPATH = false, cmd = Save          }
   local savelistTbl  = { name = "cmdfuncs.lua:(SaveList)      savelist",    checkMPATH = false, cmd = SaveList      }
   local searchTbl    = { name = "cmdfuncs.lua:(SearchCmd)     search",      checkMPATH = false, cmd = SearchCmd     }
   local showTbl      = { name = "cmdfuncs.lua:(Show)          show",        checkMPATH = false, cmd = Show          }
   local spiderTbl    = { name = "cmdfuncs.lua:(SpiderCmd)     spider",      checkMPATH = true,  cmd = SpiderCmd     }
   local swapTbl      = { name = "cmdfuncs.lua:(Swap)          swap",        checkMPATH = true,  cmd = Swap          }
   local tblLstTbl    = { name = "cmdfuncs.lua:(TableList)     tablelist",   checkMPATH = false, cmd = TableList     }
   local tryAddTbl    = { name = "cmdfuncs.lua:(Load_Try)      try-add",     checkMPATH = true,  cmd = Load_Try      }
   local unloadTbl    = { name = "cmdfuncs.lua:(Unload)        unload",      checkMPATH = true,  cmd = UnLoad        }
   local unuseTbl     = { name = "cmdfuncs.lua:(UnUse)         unuse",       checkMPATH = true,  cmd = UnUse         }
   local updateTbl    = { name = "cmdfuncs.lua:(Update)        update",      checkMPATH = true,  cmd = Update        }
   local useTbl       = { name = "cmdfuncs.lua:(Use)           use",         checkMPATH = true,  cmd = Use           }
   local disableTbl   = { name = "cmdfuncs.lua:(Disable)       disable",     checkMPATH = false, cmd = Disable       }
   local whatisTbl    = { name = "cmdfuncs.lua:(Whatis)        whatis",      checkMPATH = false, cmd = Whatis        }
   local isLoadedTbl  = { name = "cmdfuncs.lua:(IsLoaded)      isLoaded",    checkMPATH = false, cmd = IsLoaded      }
   local isAvailTbl   = { name = "cmdfuncs.lua:(IsAvail)       isAvail",     checkMPATH = false, cmd = IsAvail       }
   local categoryTbl  = { name = "cmdfuncs.lua:(Category)      category",    checkMPATH = true,  cmd = Category      }

   local lmodCmdA = {
      {cmd = 'add',          min = 2, action = loadTbl     },
      {cmd = 'avail',        min = 2, action = availTbl    },
      {cmd = 'category',     min = 3, action = categoryTbl },
      {cmd = 'delete',       min = 3, action = unloadTbl   },
      {cmd = 'describe',     min = 3, action = mcTbl       },
      {cmd = 'disable',      min = 4, action = disableTbl  },
      {cmd = 'display',      min = 3, action = showTbl     },
      {cmd = 'erase',        min = 3, action = unloadTbl   },
      {cmd = 'gd',           min = 2, action = gdTbl       },
      {cmd = 'getdefault',   min = 4, action = gdTbl       },
      {cmd = 'help',         min = 1, action = helpTbl     },
      {cmd = 'isAvail',      min = 3, action = isAvailTbl  },
      {cmd = 'isavail',      min = 3, action = isAvailTbl  },
      {cmd = 'is_avail',     min = 4, action = isAvailTbl  },
      {cmd = 'is-avail',     min = 4, action = isAvailTbl  },
      {cmd = 'isLoaded',     min = 3, action = isLoadedTbl },
      {cmd = 'isloaded',     min = 3, action = isLoadedTbl },
      {cmd = 'is_loaded',    min = 4, action = isLoadedTbl },
      {cmd = 'is-loaded',    min = 4, action = isLoadedTbl },
      {cmd = 'keyword',      min = 1, action = keywordTbl  },
      {cmd = 'ld',           min = 2, action = savelistTbl },
      {cmd = 'listdefaults', min = 5, action = savelistTbl },
      {cmd = 'load',         min = 2, action = loadTbl     },
      {cmd = 'list',         min = 1, action = listTbl     },
      {cmd = 'mcc',          min = 2, action = mcTbl       },
      {cmd = 'overview',     min = 2, action = overviewTbl },
      {cmd = 'purge',        min = 2, action = purgeTbl    },
      {cmd = 'refresh',      min = 4, action = refreshTbl  },
      {cmd = 'reload',       min = 3, action = updateTbl   },
      {cmd = 'remove',       min = 3, action = unloadTbl   },
      {cmd = 'reset',        min = 4, action = resetTbl    },
      {cmd = 'rm',           min = 2, action = unloadTbl   },
      {cmd = 'restore',      min = 1, action = restoreTbl  },
      {cmd = 'savelist',     min = 5, action = savelistTbl },
      {cmd = 'sd',           min = 2, action = saveTbl     },
      {cmd = 'search',       min = 3, action = searchTbl   },
      {cmd = 'setdefault',   min = 4, action = saveTbl     },
      {cmd = 'show',         min = 2, action = showTbl     },
      {cmd = 'sl',           min = 2, action = savelistTbl },
      {cmd = 'spider',       min = 2, action = spiderTbl   },
      {cmd = 'swap',         min = 2, action = swapTbl     },
      {cmd = 'switch',       min = 2, action = swapTbl     },
      {cmd = 'save',         min = 1, action = saveTbl     },
      {cmd = 'tablelist',    min = 5, action = tblLstTbl   },
      {cmd = 'try-load',     min = 5, action = tryAddTbl   },
      {cmd = 'try-add',      min = 5, action = tryAddTbl   },
      {cmd = 'try_load',     min = 5, action = tryAddTbl   },
      {cmd = 'try_add',      min = 5, action = tryAddTbl   },
      {cmd = 'tryload',      min = 4, action = tryAddTbl   },
      {cmd = 'tryadd',       min = 4, action = tryAddTbl   },
      {cmd = 'try',          min = 3, action = tryAddTbl   },
      {cmd = 'unload',       min = 3, action = unloadTbl   },
      {cmd = 'unuse',        min = 3, action = unuseTbl    },
      {cmd = 'update',       min = 2, action = updateTbl   },
      {cmd = 'use',          min = 3, action = useTbl      },
      {cmd = 'whatis',       min = 1, action = whatisTbl   },
   }

   -- Get shell name from 1st argument
   local shellNm, success = dynamic_shell(arg[1])
   if (success) then
      table.remove(arg,1)
   else
      shellNm = "bash"
   end

   -- Build Shell object from shellNm
   Shell = BaseShell:build(shellNm)

   local optionTbl = optionTbl()
   MCP  = MainControl.build("load")
   MCPQ = MainControl.build("quiet")
   mcp  = MainControl.build("load")

   ------------------------------------------------------------------
   -- initialize lmod with SitePackage and /etc/lmod/lmod_config.lua
   initialize_lmod()
   dbg.set_prefix(colorize("red","Lmod"))

   local cmdLineUsage = "module [options] sub-command [args ...]"
   local description  = "This tool allow a user to control their environment by load and unloading modulefiles.  See https://lmod.readthedocs.org for more details."

   Options:singleton("module", cmdLineUsage, description)
   local userCmd = optionTbl.pargs[1]
   table.remove(optionTbl.pargs,1)

   if (getenv("LMOD_DEBUG") or optionTbl.debug > 0 or optionTbl.dbglvl) then
      local configuration = require("Configuration"):singleton()
      io.stderr:setvbuf("no")
      io.stderr:write(configuration:report())
      optionTbl.dbglvl = (type(optionTbl.dbglvl) == "number") and optionTbl.dbglvl or 1
      local dbgLevel = max(optionTbl.debug, optionTbl.dbglvl or 1)
      dbg:activateDebug(dbgLevel)
   end

   if (dbg.active()) then
      dbg.start{"lmod(", concatTbl(arg," "),")"}
      dbg.print{"Date: ",os.date(),"\n"}
      dbg.print{"Hostname: ",posix.uname("%n"),"\n"}
      dbg.print{"System: ",posix.uname("%s")," ",posix.uname("%r"),"\n"}
      dbg.print{"Version: ",posix.uname("%v"),"\n"}
      dbg.print{"Lua Version: ", _VERSION:sub(5,-1),"\n"}
      dbg.print{"Lmod Version: ",Version.name(),"\n"}
      dbg.print{"package.path: ",package.path,"\n"}
      dbg.print{"package.cpath: ",package.cpath,"\n"}
      dbg.print{"lmodPath: ", cosmic:value("LMOD_PACKAGE_PATH"),"\n"}
      dbg.print{"LOADEDMODULES: ",getenv("LOADEDMODULES"),"\n"}
      dbg.print{"shellNm: ",shellNm,", Shell:name(): ",Shell:name(),"\n"}
   end

   -- dumpversion and quit if requested.
   if (optionTbl.dumpversion) then
      Shell:echo(Version.tag())
      os.exit(0)
   end

   -- dumpname and quit if requested.
   if (optionTbl.dumpname) then
      Shell:echo("Lmod\n")
      os.exit(0)
   end


   local tracing = cosmic:value("LMOD_TRACING")
   if (tracing == "yes" ) then
      tracing_msg{"Lmod version: ", Version.name(), "\n",
                  "running: module ", concatTbl(arg," ")}
   end

   -- gitversion and quit if requested.
   if (optionTbl.gitversion) then
      local gitV = Version.git()
      if (gitV == "") then
         gitV = Version.tag()
      else
         gitV = gitV:match('%((.*)%)')
      end
      io.stderr:write(gitV,"\n")
      os.exit(0)
   end

   -- print version and quit if requested.
   if (optionTbl.version) then
      io.stderr:write(version())
      os.exit(0)
   end

   -- print Configuration and quit.
   if (optionTbl.config) then
      local configuration = require("Configuration"):singleton()
      local a = {}
      a[1] = version()
      a[2] = configuration:report{mini=false}
      pcall(pager,io.stderr,concatTbl(a,""))
      os.exit(0)
   end

   -- print mini configuration and quit.
   if (optionTbl.miniConfig) then
      local configuration = require("Configuration"):singleton()
      local a = {}
      a[1] = version()
      a[2] = configuration:report{mini=true}
      pcall(pager,io.stderr,concatTbl(a,""))
      os.exit(0)
   end

   -- dump Configuration in json and quit.
   if (optionTbl.configjson) then
      local configuration = require("Configuration"):singleton()
      local a = {}
      a[#a+1] = configuration:report_json()
      a[#a+1] = ""
      io.stderr:write(concatTbl(a,"\n"))
      os.exit(0)
   end

   ------------------------------------------------------------
   -- Search for command, quit if command is unknown.
   local cmdT    = false
   local cmdName = false
   if (userCmd) then
      local uLen = userCmd:len()
      for _, v in ipairs(lmodCmdA) do
         local found = userCmd:find(v.cmd:sub(1,uLen),1,true)
         if (found == 1 and uLen >= v.min) then
            cmdT = v.action
            cmdName = cmdT.name
            break
         end
      end
   end

   hook.apply("startup", cmdName)

   local checkMPATH = (cmdT) and cmdT.checkMPATH or false
   dbg.print{"Calling Hub:singleton(checkMPATH) w checkMPATH: ",checkMPATH,"\n"}
   hub = Hub:singleton(checkMPATH)

   if (optionTbl.checkSyntax) then
      MCP  = MainControl.build("checkSyntax")
      MCPQ = MainControl.build("checkSyntax")
      mcp  = MainControl.build("checkSyntax")
      setSyntaxMode(true)
      Shell:setActive(false)
   end

   -- if Help was requested then quit.
   if (optionTbl.cmdHelp) then
      Help()
      os.exit(0)
   end

   -- if pod was requested then quit.
   if (optionTbl.cmdPod) then
      io.stderr:write(optionTbl.pod,"\n")
      os.exit(0)
   end

   -- Report ModuleTable if requested and exit.
   if (optionTbl.reportMT) then
      local mt = FrameStk:singleton():mt()
      io.stderr:write(mt:serializeTbl("pretty"),"\n")
      os.exit(0)
   end


   -- Print usage and error out for unknown command.
   if (not cmdT) then
      io.stderr:write(version())
      io.stderr:write(Usage(),"\n")
      LmodErrorExit()
      os.exit(1)
   end


   ------------------------------------------------------------
   -- Do the work of Lmod
   ------------------------------------------------------------

   local cmd = cmdT.cmd
   dbg.print{"cmd name: ", cmdT.name,"\n"}
   local cmdT0 = epoch()
   timer:deltaT("pre_cmd", cmdT0 - t1)
   cmd(unpack(optionTbl.pargs))
   local cmdT1 = epoch()
   timer:deltaT("run_cmd",cmdT1 - cmdT0)

   ------------------------------------------------------------
   -- After running command reset frameStk and mt as the
   -- frameStk can be cleared during commands.  Also
   -- the module table (mt) is also on the frame stack
   -- and must be re-initialized!
   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()

   --------------------------------------------------------
   -- Report any admin messages associated with loads
   -- Note that is safe to run every time.
   mcp:reportAdminMsgs()

   --------------------------------------------------------
   -- Report any missing dependent modules
   -- Note that is safe to run every time.
   mcp:performDependencyCk()

   -- Report any changes (worth reporting from original MT)
   if (not quiet()) then
      mt:reportChanges()
   end

   -- Convert MT into a variable _ModuleTable_

   local varT     = frameStk:varT()
   local n        = mt:name()
   varT[n]        = Var:new(n)
   varT[n]:set(mt:serializeTbl())

   -- Extract Loaded modules and filenames into
   -- LOADEDMODULES and _LMFILES_
   local status, loadedmodules, lmfiles = mt:extractModulesFiles()
   dbg.print{"status: ",status,", loadedmodules: \"",loadedmodules,"\"\n"}
   if (status) then
      varT['LOADEDMODULES'] = Var:new('LOADEDMODULES')
      varT['LOADEDMODULES']:set(loadedmodules)
      varT['_LMFILES_'] = Var:new('_LMFILES_')
      varT['_LMFILES_']:set(lmfiles)
   end

   local vPATH = varT["PATH"]
   if (vPATH) then
      vPATH:prt()
   end

   hook.apply("finalize", cmdName)
   ExitHookA.apply()
   dbg.fini("lmod")

   -- Output all newly created path and variables.
   local expandT1 = epoch()
   Shell:expand(varT)
   timer:deltaT("shell:expand", epoch() - expandT1)

   -- Expand any execute\{\} cmds
   if (Shell:real_shell())then
      Exec:exec():expand()
   end

   local t2 = epoch()
   timer:deltaT("post_cmd", t2 - cmdT1)
   timer:deltaT("main", t2 - t1)
   if (optionTbl.reportTimer) then
      io.stderr:write("\n",timer:report(),"\n\n")
   end

   if (getStatusFlag()) then
      LmodErrorExit()
   end
end

main()

