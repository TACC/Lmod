--------------------------------------------------------------------------
-- Report how a site has configured Lmod.
-- @classmod Configuration

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


require("capture")
require("fileOps")
require("haveTermSupport")
require("pairsByKeys")
require("serializeTbl")
require("utils")
require("string_utils")
require("colorize")
require("myGlobals")
local Banner       = require("Banner")
local BeautifulTbl = require('BeautifulTbl')
local ReadLmodRC   = require('ReadLmodRC')
local Version      = require("Version")
local concatTbl    = table.concat
local cosmic       = require("Cosmic"):singleton()
local dbg          = require('Dbg'):dbg()
local getenv       = os.getenv
local lfs          = require("lfs")
local M            = {}

local s_configuration = false

local function l_locatePkg(pkg)
   local result = nil
   for path in package.path:split(";") do
      local s = path:gsub("?",pkg)
      local f = io.open(s,"r")
      if (f) then
         f:close()
         result = s
         break;
      end
   end
   return result
end


local function l_new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   local HashSum    = cosmic:value("LMOD_HASHSUM_PATH")
   local locSitePkg = l_locatePkg("SitePackage") or "unknown"

   if (locSitePkg ~= "unknown") then
      local std_sha1 = "1fa3d8f24793042217b8474904136fdde72d42dd"
      local std_md5  = "3c785db2ee60bc8878fe1b576c890a0f"

      local std_hashsum = (HashSum:find("md5") ~= nil) and std_md5 or std_sha1

      if (HashSum == nil) then
         LmodError{msg="e_No_Hashsum"}
      end

      -- The output from HashSum can look like either
      --   $ md5 Makefile
      --   MD5 (Makefile) = 3fecf96f61c44f67ce13124e97cfd612
      -- Or:
      --   $ sha1sum Makefile
      --   3160f0cc15e577c476bd1acd7c096333ba1ec1ea  Makefile

      -- This means that any result need to possibly strip the
      -- front of the result or the end.

      local result = capture(HashSum .. " " .. locSitePkg)
      result       = result:gsub("^.*= *",""):gsub(" .*","")
      if (result == std_hashsum) then
         locSitePkg = "standard"
      end
   end

   local os_name  = "<N/A>"
   local print_os = pathJoin(cmdDir(),"print_os.sh")
   if (isFile(print_os)) then
      os_name = capture(print_os)
   end

   local lmod_version = Version.git()
   if (lmod_version == "") then
      lmod_version = Version.tag()
   else
      lmod_version = lmod_version:gsub("[)(]","")
   end
   local mpath_init        = cosmic:value("LMOD_MODULEPATH_INIT")
   local readLmodRC        = ReadLmodRC:singleton()
   local pkgName           = Pkg.name() or "unknown"
   local scDescriptT       = readLmodRC:scDescriptT()
   local numSC             = #scDescriptT
   local uname             = capture("uname -a")
   local adminFn, readable = findAdminFn()
   local activeTerm        = haveTermSupport() and "true" or colorize("red","false")
   local avail_style       = cosmic:value("LMOD_AVAIL_STYLE")
   local lmod_configDir    = cosmic:value("LMOD_CONFIG_DIR")
   local dynamic_cache     = cosmic:value("LMOD_DYNAMIC_SPIDER_CACHE")
   local ksh_support       = cosmic:value("LMOD_KSH_SUPPORT")
   local extended_default  = cosmic:value("LMOD_EXTENDED_DEFAULT")
   local avail_extensions  = cosmic:value("LMOD_AVAIL_EXTENSIONS")
   local hiddenItalic      = cosmic:value("LMOD_HIDDEN_ITALIC")
   local lfsV              = cosmic:value("LFS_VERSION")
   local lmod_lang         = cosmic:value("LMOD_LANG")
   local site_msg_file     = cosmic:value("LMOD_SITE_MSG_FILE") or "<empty>"
   local settarg_support   = cosmic:value("LMOD_SETTARG_FULL_SUPPORT")
   local lmod_colorize     = cosmic:value("LMOD_COLORIZE")
   local site_name         = cosmic:value("LMOD_SITE_NAME")   or "<empty>"
   local syshost           = cosmic:value("LMOD_SYSHOST")     or "<empty>"
   local system_name       = cosmic:value("LMOD_SYSTEM_NAME") or "<empty>"
   local case_ind_sorting  = cosmic:value("LMOD_CASE_INDEPENDENT_SORTING")
   local disable1N         = cosmic:value("LMOD_DISABLE_SAME_NAME_AUTOSWAP")
   local tmod_rule         = cosmic:value("LMOD_TMOD_PATH_RULE")
   local find_first        = cosmic:value("LMOD_TMOD_FIND_FIRST")
   local exactMatch        = cosmic:value("LMOD_EXACT_MATCH")
   local cached_loads      = cosmic:value("LMOD_CACHED_LOADS")
   local ignore_cache      = cosmic:value("LMOD_IGNORE_CACHE") and "yes" or "no"
   local redirect          = cosmic:value("LMOD_REDIRECT")
   local ld_preload        = cosmic:value("LMOD_LD_PRELOAD")      or "<empty>"
   local ld_lib_path       = cosmic:value("LMOD_LD_LIBRARY_PATH") or "<empty>"
   local allow_tcl_mfiles  = cosmic:value("LMOD_ALLOW_TCL_MFILES")
   local duplicate_paths   = cosmic:value("LMOD_DUPLICATE_PATHS")
   local pager             = cosmic:value("LMOD_PAGER")
   local pager_opts        = cosmic:value("LMOD_PAGER_OPTS")
   local pin_versions      = cosmic:value("LMOD_PIN_VERSIONS")
   local auto_swap         = cosmic:value("LMOD_AUTO_SWAP")
   local mpath_avail       = cosmic:value("LMOD_MPATH_AVAIL")
   local rc                = cosmic:value("LMOD_MODULERCFILE")
   local ancient           = cosmic:value("LMOD_ANCIENT_TIME")
   local site_prefix       = cosmic:value("SITE_CONTROLLED_PREFIX")
   local shortTime         = cosmic:value("LMOD_SHORT_TIME")
   local using_dotfiles    = cosmic:value("LMOD_USE_DOT_FILES")
   local export_module     = cosmic:value("LMOD_EXPORT_MODULE")
   local prepend_block     = cosmic:value("LMOD_PREPEND_BLOCK")
   local threshold         = cosmic:value("LMOD_THRESHOLD")
   local have_term         = cosmic:value("LMOD_HAVE_LUA_TERM")
   local mpath_root        = cosmic:value("MODULEPATH_ROOT")
   local hashsum_path      = cosmic:value("LMOD_HASHSUM_PATH")
   local lua_path          = cosmic:value("PATH_TO_LUA")
   local tracing           = cosmic:value("LMOD_TRACING")
   local fast_tcl_interp   = cosmic:value("LMOD_FAST_TCL_INTERP")
   local allow_root_use    = cosmic:value("LMOD_ALLOW_ROOT_USE")
   local lmodrc            = cosmic:value("LMOD_RC")

   if (lmodrc == "") then
      lmodrc = "<empty>"
   end

   if (not rc:find(":") and not isFile(rc)) then
      rc = rc .. " -> <empty>"
   end
   if (not readable) then
      adminFn = adminFn .. " -> <empty>"
   end
   if (not isFile(mpath_init)) then
      mpath_init = mpath_init .. " -> <empty>"
   end

   local tcl_version = "<N/A>"
   if (allow_tcl_mfiles == "yes" and not masterTbl().rt) then
      tcl_version = capture("echo 'puts [info patchlevel]' | tclsh")
   end

   local tbl = {}
   tbl.allowRoot    = { k = "Allow root to use Lmod"            , v = allow_root_use,   }
   tbl.allowTCL     = { k = "Allow TCL modulefiles"             , v = allow_tcl_mfiles, }
   tbl.avail_style  = { k = "Avail Style"                       , v = avail_style,      }
   tbl.autoSwap     = { k = "Auto swapping"                     , v = auto_swap,        }
   tbl.case         = { k = "Case Independent Sorting"          , v = case_ind_sorting, }
   tbl.colorize     = { k = "Colorize Lmod"                     , v = lmod_colorize,    }
   tbl.configDir    = { k = "Configuration dir"                 , v = lmod_configDir,   }
   tbl.disable1N    = { k = "Disable Same Name AutoSwap"        , v = disable1N,        }
   tbl.disp_av_ext  = { k = "Display Extension w/ avail"        , v = avail_extensions, }
   tbl.dot_files    = { k = "Using dotfiles"                    , v = using_dotfiles,   }
   tbl.dupPaths     = { k = "Allow duplicate paths"             , v = duplicate_paths,  }
   tbl.dynamicC     = { k = "Dynamic Spider Cache"              , v = dynamic_cache,    }
   tbl.extendDflt   = { k = "Allow extended default"            , v = extended_default, }
   tbl.exactMatch   = { k = "Require Exact Match/no defaults"   , v = exactMatch,       }
   tbl.expMCmd      = { k = "Export the module command"         , v = export_module,    }
   tbl.fastTCL      = { k = "Use attached TCL over system call" , v = fast_tcl_interp,  }
   tbl.hiddenItalic = { k = "Use italic instead of dim"         , v = hiddenItalic,     }
   tbl.ksh_support  = { k = "KSH Support"                       , v = ksh_support,      }
   tbl.lang         = { k = "Language used for err/msg/warn"    , v = lmod_lang,        }
   tbl.lang_site    = { k = "Site message file"                 , v = site_msg_file,    }
   tbl.lua_cpath    = { k = "LUA_CPATH"                         , v = "@sys_lua_cpath@",}
   tbl.lua_path     = { k = "LUA_PATH"                          , v = "@sys_lua_path@", }
   tbl.ld_preload   = { k = "LD_PRELOAD at config time"         , v = ld_preload,       }
   tbl.ld_lib_path  = { k = "LD_LIBRARY_PATH at config time"    , v = ld_lib_path,      }
   tbl.lfsV         = { k = "LuaFileSystem version"             , v = lfsV,             }
   tbl.lmodV        = { k = "Lmod version"                      , v = lmod_version,     }
   tbl.luaV         = { k = "Lua Version"                       , v = _VERSION,         }
   tbl.lua_term     = { k = "System lua-term"                   , v = have_term,        }
   tbl.lua_term_A   = { k = "Active lua-term"                   , v = activeTerm,       }
   tbl.mpath_av     = { k = "avail: Include modulepath dir"     , v = mpath_avail,      }
   tbl.mpath_init   = { k = "MODULEPATH_INIT"                   , v = mpath_init,       }
   tbl.mpath_root   = { k = "MODULEPATH_ROOT"                   , v = mpath_root,       }
   tbl.modRC        = { k = "MODULERCFILE"                      , v = rc,               }
   tbl.numSC        = { k = "number of cache dirs"              , v = numSC,            }
   tbl.os_name      = { k = "OS Name"                           , v = os_name,          }
   tbl.pager        = { k = "Pager"                             , v = pager,            }
   tbl.pager_opts   = { k = "Pager Options"                     , v = pager_opts,       }
   tbl.path_hash    = { k = "Path to HashSum"                   , v = hashsum_path,     }
   tbl.path_lua     = { k = "Path to Lua"                       , v = lua_path,         }
   tbl.pin_v        = { k = "Pin Versions in restore"           , v = pin_versions,     }
   tbl.pkg          = { k = "Pkg Class name"                    , v = pkgName,          }
   tbl.prefix       = { k = "Lmod prefix"                       , v = "@PREFIX@",       }
   tbl.prefix_site  = { k = "Site controlled prefix"            , v = site_prefix,      }
   tbl.prpnd_blk    = { k = "Prepend order"                     , v = prepend_block,    }
   tbl.rc           = { k = "LMOD_RC"                           , v = lmodrc,           }
   tbl.settarg      = { k = "Supporting Full Settarg Use"       , v = settarg_support,  }
   tbl.shell        = { k = "User shell"                        , v = myShellName(),    }
   tbl.sitePkg      = { k = "Site Pkg location"                 , v = locSitePkg,       }
   tbl.siteName     = { k = "Site Name"                         , v = site_name,        }
   tbl.spdr_ignore  = { k = "Ignore Cache"                      , v = ignore_cache,     }
   tbl.spdr_loads   = { k = "Cached loads"                      , v = cached_loads,     }
   tbl.sysName      = { k = "System Name"                       , v = system_name,      }
   tbl.syshost      = { k = "SYSHOST (cluster name)"            , v = syshost,          }
   tbl.tcl_version  = { k = "TCL Version"                       , v = tcl_version,      }
   tbl.tm_ancient   = { k = "User cache valid time(sec)"        , v = ancient,          }
   tbl.tm_short     = { k = "Write cache after (sec)"           , v = shortTime,        }
   tbl.tm_threshold = { k = "Threshold (sec)"                   , v = threshold,        }
   tbl.tmod_find1st = { k = "Tmod find first rule"              , v = find_first,       }
   tbl.tmod_rule    = { k = "Tmod prepend PATH Rule"            , v = tmod_rule,        }
   tbl.tracing      = { k = "Tracing"                           , v = tracing,          }
   tbl.uname        = { k = "uname -a"                          , v = uname,            }
   tbl.z01_admin    = { k = "Admin file"                        , v = adminFn,          }
   tbl.redirect     = { k = "Redirect to stdout"                , v = redirect,         }

   o.tbl = tbl
   return o
end

--------------------------------------------------------------------------
-- A Configuration Singleton Ctor.
-- @param self A Configuration object.
-- @return A Configuration Singleton.
function M.singleton(self)
   if (not s_configuration) then
      s_configuration = l_new(self)
   end
   return s_configuration
end

--------------------------------------------------------------------------
-- Report the current configuration.
-- @param self A Configuration object
-- @return the configuration report as a single string.
function M.report(self)
   local readLmodRC = ReadLmodRC:singleton()
   local a          = {}
   local tbl        = self.tbl
   a[#a+1]          = {"Description", "Value", }
   a[#a+1]          = {"-----------", "-----", }

   for _, v in pairsByKeys(tbl) do
      a[#a+1] = {v.k, v.v }
   end

   local b = {}
   local bt = BeautifulTbl:new{tbl=a}
   b[#b+1]  = bt:build_tbl()
   b[#b+1]  = "\n"

   local aa = cosmic:reportChangesFromDefault()
   if (next(aa) ~= nil) then
      b[#b+1] = "Changes from Default Configuration"
      b[#b+1] = "----------------------------------\n"

      bt      = BeautifulTbl:new{tbl=aa}
      b[#b+1] = bt:build_tbl()
      b[#b+1] = "\n"
   end


   local rcFileA = readLmodRC:rcFileA()
   if (#rcFileA) then
      b[#b+1] = "Active RC file(s):"
      b[#b+1] = "------------------"
      for i = 1, #rcFileA do
         b[#b+1] = rcFileA[i]
      end
      b[#b+1]  = "\n"
   end


   local scDescriptT = readLmodRC:scDescriptT()
   if (#scDescriptT > 0) then
      a = {}
      a[#a+1]   = {"Cache Directory",  "Time Stamp File",}
      a[#a+1]   = {"---------------",  "---------------",}
      for i = 1, #scDescriptT do
         a[#a+1] = { tostring(scDescriptT[i].dir), tostring(scDescriptT[i].timestamp)}
      end
      bt = BeautifulTbl:new{tbl=a}
      b[#b+1]  = bt:build_tbl()
      b[#b+1]  = "\n"
   end

   local banner = Banner:singleton()
   local border = banner:border(2)
   local str    = " Lmod Property Table:"
   b[#b+1]  = border
   b[#b+1]  = str
   b[#b+1]  = border
   b[#b+1]  = "\n"
   b[#b+1]  = serializeTbl{indent = true, name="propT", value = readLmodRC:propT() }
   b[#b+1]  = "\n"

   return concatTbl(b,"\n")
end

-- Report the current configuration in json format.
-- It can have 3 keys:
-- - 'config': the Lmod configuration
-- - 'cache': list of caches
-- - 'rcfiles': list of all active rcfiles
-- - 'propt': the current propT table
-- @param self A Configuration object
-- @return the configuration report in json as a single string.
function M.report_json(self)
   local json    = require("json")
   local tbl     = self.tbl
   local configT = {}

   for k, v in pairs(tbl) do
       configT[k] = v.v
   end

   local res = {}
   res.configT = configT

   local readLmodRC = ReadLmodRC:singleton()
   local rcFileA = readLmodRC:rcFileA()
   if (#rcFileA) then
       local a = {}
       for i = 1, #rcFileA do
           a[#a+1] = rcFileA[i]
       end
       res.rcfileA = a
   end

   local scDescriptT = readLmodRC:scDescriptT()
   if (#scDescriptT > 0) then
       local a = {}
       for i = 1, #scDescriptT do
           a[#a+1] = {scDescriptT[i].dir, scDescriptT[i].timestamp}
       end
       res.cache = a
   end

   res.propT = readLmodRC:propT()

   return json.encode(res)
end

return M
