--------------------------------------------------------------------------
-- Report how a site has configured Lmod.
-- @classmod Configuration

_G._DEBUG      = false
local posix    = require("posix")

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
local access       = posix.access
local concatTbl    = table.concat
local cosmic       = require("Cosmic"):singleton()
local dbg          = require('Dbg'):dbg()
local getenv       = os.getenv
local lfs          = require("lfs")
local M            = {}

local s_configuration = false


local function l_new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   local HashSum    = cosmic:value("LMOD_HASHSUM_PATH")
   local locSitePkg = locatePkg("SitePackage") or "unknown"

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
         cosmic:assign("LMOD_SITEPACKAGE_LOCATION", "<srctree>")
      else
         cosmic:assign("LMOD_SITEPACKAGE_LOCATION", locSitePkg)
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
   local readLmodRC        = ReadLmodRC:singleton()
   local pkgName           = Pkg.name() or "unknown"
   local scDescriptT       = readLmodRC:scDescriptT()
   local numSC             = #scDescriptT
   local uname             = capture("uname -a")
   local adminFn, readable = findAdminFn()
   local activeTerm        = haveTermSupport() and "true" or colorize("red","false")
   local allow_root_use    = cosmic:value("LMOD_ALLOW_ROOT_USE")
   local allow_tcl_mfiles  = cosmic:value("LMOD_ALLOW_TCL_MFILES")
   local ancient           = cosmic:value("LMOD_ANCIENT_TIME")
   local auto_swap         = cosmic:value("LMOD_AUTO_SWAP")
   local avail_extensions  = cosmic:value("LMOD_AVAIL_EXTENSIONS")
   local avail_style       = cosmic:value("LMOD_AVAIL_STYLE")
   local cached_loads      = cosmic:value("LMOD_CACHED_LOADS")
   local case_ind_sorting  = cosmic:value("LMOD_CASE_INDEPENDENT_SORTING")
   local dfltModules       = cosmic:value("LMOD_SYSTEM_DEFAULT_MODULES")
   local disable1N         = cosmic:value("LMOD_DISABLE_SAME_NAME_AUTOSWAP")
   local duplicate_paths   = cosmic:value("LMOD_DUPLICATE_PATHS")
   local dynamic_cache     = cosmic:value("LMOD_DYNAMIC_SPIDER_CACHE")
   local exactMatch        = cosmic:value("LMOD_EXACT_MATCH")
   local export_module     = cosmic:value("LMOD_EXPORT_MODULE")
   local extended_default  = cosmic:value("LMOD_EXTENDED_DEFAULT")
   local fast_tcl_interp   = cosmic:value("LMOD_FAST_TCL_INTERP")
   local find_first        = cosmic:value("LMOD_TMOD_FIND_FIRST")
   local hashsum_path      = cosmic:value("LMOD_HASHSUM_PATH")
   local have_term         = cosmic:value("LMOD_HAVE_LUA_TERM")
   local hiddenItalic      = cosmic:value("LMOD_HIDDEN_ITALIC")
   local ignore_cache      = cosmic:value("LMOD_IGNORE_CACHE")
   local ksh_support       = cosmic:value("LMOD_KSH_SUPPORT")
   local ld_lib_path       = cosmic:value("LMOD_LD_LIBRARY_PATH") or "<empty>"
   local ld_preload        = cosmic:value("LMOD_LD_PRELOAD")      or "<empty>"
   local lfsV              = cosmic:value("LFS_VERSION")
   local lmod_colorize     = cosmic:value("LMOD_COLORIZE")
   local lmod_configDir    = cosmic:value("LMOD_CONFIG_DIR")
   local lmod_lang         = cosmic:value("LMOD_LANG")
   local lmodrc            = cosmic:value("LMOD_RC")
   local lmod_branch       = cosmic:value("LMOD_BRANCH") 
   local lua_path          = cosmic:value("PATH_TO_LUA")
   local mpath_avail       = cosmic:value("LMOD_MPATH_AVAIL")
   local mpath_init        = cosmic:value("LMOD_MODULEPATH_INIT")
   local mpath_root        = cosmic:value("MODULEPATH_ROOT")
   local mAutoHanding      = cosmic:value("MODULES_AUTO_HANDLING")
   local nag               = cosmic:value("LMOD_ADMIN_FILE")
   local pager             = cosmic:value("LMOD_PAGER")
   local pager_opts        = cosmic:value("LMOD_PAGER_OPTS")
   local pin_versions      = cosmic:value("LMOD_PIN_VERSIONS")
   local dsConflicts       = cosmic:value("LMOD_DOWNSTREAM_CONFLICTS")
   local prepend_block     = cosmic:value("LMOD_PREPEND_BLOCK")
   local rc                = cosmic:value("LMOD_MODULERC")
   local redirect          = cosmic:value("LMOD_REDIRECT")
   local settarg_support   = cosmic:value("LMOD_SETTARG_FULL_SUPPORT")
   local shortTime         = cosmic:value("LMOD_SHORT_TIME")
   local site_msg_file     = cosmic:value("LMOD_SITE_MSG_FILE") or "<empty>"
   local site_name         = cosmic:value("LMOD_SITE_NAME")   or "<empty>"
   local site_prefix       = cosmic:value("SITE_CONTROLLED_PREFIX")
   local syshost           = cosmic:value("LMOD_SYSHOST")     or "<empty>"
   local system_name       = cosmic:value("LMOD_SYSTEM_NAME") or "<empty>"
   local threshold         = cosmic:value("LMOD_THRESHOLD")
   local tmod_rule         = cosmic:value("LMOD_TMOD_PATH_RULE")
   local tracing           = cosmic:value("LMOD_TRACING")
   local useDotConfigOnly  = cosmic:value("LMOD_USE_DOT_CONFIG_ONLY")
   local lmod_cfg_path     = cosmic:value("LMOD_CONFIG_LOCATION")
   local using_fast_tcl    = usingFastTCLInterp()
   cosmic:assign("LMOD_USING_FAST_TCL_INTERP",using_fast_tcl)

   if (dfltModules == "") then
      dfltModules = "<empty>"
   end

   if (lmodrc == "") then
      lmodrc = "<empty>"
   end

   if (not rc:find(":")) then
      if (not exists(rc)) then
         rc = rc .. " -> <empty>"
      elseif (not access(rc,"r")) then
         rc = rc .. " -> <unreadable>"
      end
   end
   if (not readable) then
      adminFn = adminFn .. " -> <empty>"
   end
   if (not isFile(mpath_init)) then
      mpath_init = mpath_init .. " -> <empty>"
   end

   local tcl_version = "<N/A>"
   if (allow_tcl_mfiles == "yes" and not optionTbl().rt) then
      tcl_version = capture("echo 'puts [info patchlevel]' | tclsh")
   end

   local tbl = {}
   tbl.allowRoot    = { k = "Allow root to use Lmod"            , v = allow_root_use,   n = "LMOD_ALLOW_ROOT_USE"             }
   tbl.allowTCL     = { k = "Allow TCL modulefiles"             , v = allow_tcl_mfiles, n = "LMOD_ALLOW_TCL_FILES"            }
   tbl.avail_style  = { k = "Avail Style"                       , v = avail_style,      n = "LMOD_AVAIL_STYLE"                }
   tbl.autoSwap     = { k = "Auto swapping"                     , v = auto_swap,        n = "LMOD_AUTO_SWAP"                  }       
   tbl.case         = { k = "Case Independent Sorting"          , v = case_ind_sorting, n = "LMOD_CASE_INDEPENDENT_SORTING"   }
   tbl.colorize     = { k = "Colorize Lmod"                     , v = lmod_colorize,    n = "LMOD_COLORIZE"                   }
   tbl.configDir    = { k = "Configuration dir"                 , v = lmod_configDir,   n = "LMOD_CONFIG_DIR"                 } 
   tbl.disable1N    = { k = "Disable Same Name AutoSwap"        , v = disable1N,        n = "LMOD_DISABLE_SAME_NAME_AUTOSWAP" }
   tbl.disp_av_ext  = { k = "Display Extension w/ avail"        , v = avail_extensions, n = "LMOD_AVAIL_EXTENSIONS"           }
   tbl.dotConfOnly  = { k = "Use ~/.config dir only"            , v = useDotConfigOnly, n = "LMOD_USE_DOT_CONFIG_ONLY"        }
   tbl.dupPaths     = { k = "Allow duplicate paths"             , v = duplicate_paths,  n = "LMOD_DUPLICATE_PATHS"            }
   tbl.dynamicC     = { k = "Dynamic Spider Cache"              , v = dynamic_cache,    n = "LMOD_DYNAMIC_SPIDER_CACHE"       }
   tbl.extendDflt   = { k = "Allow extended default"            , v = extended_default, n = "LMOD_EXTENDED_DEFAULT"           }
   tbl.exactMatch   = { k = "Require Exact Match/no defaults"   , v = exactMatch,       n = "LMOD_EXACT_MATCH"                }
   tbl.expMCmd      = { k = "Export the module command"         , v = export_module,    n = "LMOD_EXPORT_MODULE"              }
   tbl.fastTCL      = { k = "Use attached TCL over system call" , v = fast_tcl_interp,  n = "LMOD_FAST_TCL_INTERP"            }
   tbl.fastTCLUsing = { k = "Is fast TCL interp available"      , v = using_fast_tcl,   n = "LMOD_USING_FAST_TCL_INTERP"      }
   tbl.hiddenItalic = { k = "Use italic instead of dim"         , v = hiddenItalic,     n = "LMOD_HIDDEN_ITALIC"              }
   tbl.ksh_support  = { k = "KSH Support"                       , v = ksh_support,      n = "LMOD_KSH_SUPPORT"                }
   tbl.lang         = { k = "Language used for err/msg/warn"    , v = lmod_lang,        n = "LMOD_LANG"                       }
   tbl.lang_site    = { k = "Site message file"                 , v = site_msg_file,    n = "LMOD_SITE_MSG_FILE"              }
   tbl.lua_cpath    = { k = "LUA_CPATH"                         , v = "@sys_lua_cpath@",n = false                             }
   tbl.lua_path     = { k = "LUA_PATH"                          , v = "@sys_lua_path@", n = false                             }
   tbl.ld_preload   = { k = "LD_PRELOAD at config time"         , v = ld_preload,       n = "LMOD_LD_PRELOAD"                 }
   tbl.ld_lib_path  = { k = "LD_LIBRARY_PATH at config time"    , v = ld_lib_path,      n = "LMOD_LD_LIBRARY_PATH"            }
   tbl.lfsV         = { k = "LuaFileSystem version"             , v = lfsV,             n = false                             }
   tbl.lmod_cfg     = { k = "lmod_config.lua location"          , v = lmod_cfg_path,    n = "LMOD_CONFIG_LOCATION"            }
   tbl.lmodV        = { k = "Lmod version"                      , v = lmod_version,     n = false                             }
   tbl.lmod_branch  = { k = "Lmod branch"                       , v = lmod_branch,      n = "LMOD_BRANCH"                     }
   tbl.luaV         = { k = "Lua Version"                       , v = _VERSION,         n = false                             }
   tbl.lua_term     = { k = "System lua-term"                   , v = have_term,        n = "LMOD_HAVE_LUA_TERM"              }
   tbl.lua_term_A   = { k = "Active lua-term"                   , v = activeTerm,       n = false                             }
   tbl.mAutoHndl    = { k = "Modules Auto Handling"             , v = mAutoHanding,     n = "MODULES_AUTO_HANDLING"         }
   tbl.mpath_av     = { k = "avail: Include modulepath dir"     , v = mpath_avail,      n = "LMOD_MPATH_AVAIL"                }
   tbl.mpath_init   = { k = "MODULEPATH_INIT"                   , v = mpath_init,       n = "LMOD_MODULEPATH_INIT"            }
   tbl.mpath_root   = { k = "MODULEPATH_ROOT"                   , v = mpath_root,       n = "MODULEPATH_ROOT"                 }
   tbl.modRC        = { k = "MODULERC"                          , v = rc,               n = "LMOD_MODULERC"                   }
   tbl.nag          = { k = "NAG File"                          , v = nag,              n = "LMOD_ADMIN_FILE"                 }
   tbl.numSC        = { k = "number of cache dirs"              , v = numSC,            n = false                             }
   tbl.os_name      = { k = "OS Name"                           , v = os_name,          n = false                             }
   tbl.pager        = { k = "Pager"                             , v = pager,            n = "LMOD_PAGER"                      }
   tbl.pager_opts   = { k = "Pager Options"                     , v = pager_opts,       n = "LMOD_PAGER_OPTS"                 }
   tbl.path_hash    = { k = "Path to HashSum"                   , v = hashsum_path,     n = "LMOD_HASHSUM_PATH"               }
   tbl.path_lua     = { k = "Path to Lua"                       , v = lua_path,         n = false                             }
   tbl.dsConflicts  = { k = "Downstream Module Conflicts"       , v = dsConflicts,    n = "LMOD_DOWNSTREAM_CONFLICTS"         }
   tbl.pin_v        = { k = "Pin Versions in restore"           , v = pin_versions,     n = "LMOD_PIN_VERSIONS"               }
   tbl.pkg          = { k = "Pkg Class name"                    , v = pkgName,          n = false                             }
   tbl.prefix       = { k = "Lmod prefix"                       , v = "@PREFIX@",       n = false                             }
   tbl.prefix_site  = { k = "Site controlled prefix"            , v = site_prefix,      n = "SITE_CONTROLLED_PREFIX"          }
   tbl.prpnd_blk    = { k = "Prepend order"                     , v = prepend_block,    n = "LMOD_PREPEND_BLOCK"              }
   tbl.rc           = { k = "LMOD_RC"                           , v = lmodrc,           n = "LMOD_RC"                         }
   tbl.settarg      = { k = "Supporting Full Settarg Use"       , v = settarg_support,  n = "LMOD_SETTARG_FULL_SUPPORT"       }
   tbl.shell        = { k = "User shell"                        , v = myShellName(),    n = false                             }
   tbl.sitePkg      = { k = "Site Pkg location"                 , v = locSitePkg,       n = false                             }
   tbl.siteName     = { k = "Site Name"                         , v = site_name,        n = "LMOD_SITE_NAME"                  }
   tbl.spdr_ignore  = { k = "Ignore Cache"                      , v = ignore_cache,     n = "LMOD_IGNORE_CACHE"               }
   tbl.spdr_loads   = { k = "Cached loads"                      , v = cached_loads,     n = "LMOD_CACHED_LOADS"               }
   tbl.sysDfltM     = { k = "System Default Modules"            , v = dfltModules,      n = "LMOD_SYSTEM_DEFAULT_MODULES"     }
   tbl.sysName      = { k = "System Name"                       , v = system_name,      n = "LMOD_SYSTEM_NAME"                }
   tbl.syshost      = { k = "SYSHOST (cluster name)"            , v = syshost,          n = "LMOD_SYSHOST"                    }
   tbl.tcl_version  = { k = "TCL Version"                       , v = tcl_version,      n = false                             }
   tbl.tm_ancient   = { k = "User cache valid time(sec)"        , v = ancient,          n = "LMOD_ANCIENT_TIME"               }
   tbl.tm_short     = { k = "Write cache after (sec)"           , v = shortTime,        n = "LMOD_SHORT_TIME"                 }
   tbl.tm_threshold = { k = "Threshold (sec)"                   , v = threshold,        n = "LMOD_THRESHOLD"                  }
   tbl.tmod_find1st = { k = "Tmod find first rule"              , v = find_first,       n = "LMOD_TMOD_PATH_RULE"             }
   tbl.tmod_rule    = { k = "Tmod prepend PATH Rule"            , v = tmod_rule,        n = "LMOD_TMOD_PATH_RULE"             }
   tbl.tracing      = { k = "Tracing"                           , v = tracing,          n = "LMOD_TRACING"                    }
   tbl.uname        = { k = "uname -a"                          , v = uname,            n = false                             }
   tbl.usrCacheDir  = { k = "User Cache Directory"              , v = usrCacheDir,      n = false                             }
   tbl.redirect     = { k = "Redirect to stdout"                , v = redirect,         n = "LMOD_REDIRECT"                   }
   tbl.z01_admin    = { k = "Admin file"                        , v = adminFn,          n = false                             }

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
function M.report(self, t)
   local readLmodRC = ReadLmodRC:singleton()
   local tbl        = t or {}
   local mini       = tbl.mini
   local a          = {}
   local tbl        = self.tbl
   a[#a+1]          = {"Description", "Value", }
   a[#a+1]          = {"-----------", "-----", }

   for _, v in pairsByKeys(tbl) do
      local descript = v.k
      if (v.n) then
         descript = descript .. " (" .. v.n .. ")"
      end
      a[#a+1] = {descript, v.v }
   end

   local b = {}
   local bt 
   if (not mini) then
      bt      = BeautifulTbl:new{tbl=a}
      b[#b+1] = bt:build_tbl()
      b[#b+1] = "\n"
   end

   local aa = cosmic:reportChangesFromDefault()
   b[#b+1] = "Changes from Default Configuration"
   b[#b+1] = "----------------------------------\n"

   
   if (next(aa) ~= nil) then
      bt      = BeautifulTbl:new{tbl=aa}
      b[#b+1] = bt:build_tbl()
      b[#b+1] = "\n"
      b[#b+1] = "Where Set -> D: default, E: environment, C: configuration"
      b[#b+1] = "             lmod_cfg: lmod_config.lua SitePkg: SitePackage StdPkg: StandardPackage"
      b[#b+1] = "             Other: Set somewhere outside of normal locations\n"
   else
      b[#b+1] = "--- None ---"
   end


   if (not mini) then
      local rcFileA = readLmodRC:rcFileA()
      if (#rcFileA) then
         b[#b+1] = "Active RC file(s):"
         b[#b+1] = "------------------"
         for i = 1, #rcFileA do
            b[#b+1] = realpath(rcFileA[i])
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
      local str    = " Lmod Property Table (LMOD_RC):"
      b[#b+1]  = border
      b[#b+1]  = str
      b[#b+1]  = border
      b[#b+1]  = "\n"
      b[#b+1]  = serializeTbl{indent = true, name="propT", value = readLmodRC:propT() }
      b[#b+1]  = "\n"
   end

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
   if (_VERSION ~= "Lua 5.1") then
      require("declare")
      declare("loadstring")
      loadstring = load
   end
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
