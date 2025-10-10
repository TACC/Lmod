--------------------------------------------------------------------------
-- Options: This class is the main options parser for Lmod.  It defines
--          the options it supports and uses Optiks to parse the command
--          line.  All options values are copied to [[optionTbl]] and
--          positional arguments are copied to [[optionTbl.pargs]].
--          The command usage string is retrieved into
--          [[optionTbl.cmdHelpMsg]].
--
-- @classmod Options

_G._DEBUG          = false               -- Required by the new lua posix
local posix        = require("posix")

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

local cosmic       = require("Cosmic"):singleton()
local dbg          = require("Dbg"):dbg()
local i18n         = require("i18n")
local setenv_posix = posix.setenv
local stderr       = io.stderr
local systemG      = _G
local concatTbl    = table.concat
local M = {}

--------------------------------------------------------------------------
-- Private Ctor for Option class.
-- @param self An Option object
--local function l_new(self)
--   local o = {}
--
--   setmetatable(o,self)
--   self.__index = self
--   return o
--end

--------------------------------------------------------------------------
-- This function forces the option parser to write to stderr instead of
-- stdout.
local function l_prt(...)
   stderr:write(...)
end


--------------------------------------------------------------------------
-- This function prevents the option parser from exiting when it finds an
-- error.
local function l_nothing()
end


--------------------------------------------------------------------------
-- Parse the command line options. Places the options in *optionTbl*,
-- place the positional arguments in *optionTbl.pargs*
-- @param self An Option object.
-- @param usage The program usage string.
function M.singleton(self, progName, usage, description)

   local Optiks = require("Optiks")
   local cmdlineParser  = Optiks:new{usage    = usage,
                                     error    = LmodWarning,
                                     exit     = l_nothing,
                                     prt      = l_prt,
                                     progName = progName,
                                     envArg   = os.getenv("LMOD_OPTIONS"),
                                     descript = description,
   }

   local styleA       = {}
   local icnt         = 0
   local defaultStyle = "system"

   local style = cosmic:value("LMOD_AVAIL_STYLE")

   for s in style:split(":") do
      icnt = icnt + 1
      if (s:sub(1,1) == "<" and s:sub(-1,-1) == ">") then
         s            = s:sub(2,-2)
         defaultStyle = s
      elseif (icnt == 1) then
         defaultStyle = s
      end
      styleA[icnt] = s
   end

   cmdlineParser:add_option{
      name   = {"-h","-?","-H","--help"},
      dest   = "cmdHelp",
      action = "store_true",
      help   = i18n("help_hlp"),
   }

   cmdlineParser:add_option{
      name    = {"-s","--style"},
      dest    = "availStyle",
      action  = "store",
      default = defaultStyle,
      help    = i18n("style_hlp",{styleA=concatTbl(styleA," "), default = defaultStyle}),
   }

   cmdlineParser:add_option{
      name   = {"--regression_testing"},
      dest   = "rt",
      action = "store_true",
      help   = i18n("rt_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"-b", "--brief"},
      dest   = "brief",
      action = "store_true",
      help   = "brief listing with only user specified modules",
   }

   cmdlineParser:add_option{
      name   = {"-D"},
      dest   = "debug",
      action = "count",
      help   = i18n("dbg_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"--debug"},
      dest   = "dbglvl",
      action = "store",
      help   = i18n("dbg_hlp2"),
   }

   cmdlineParser:add_option{
      name   = {"--pin_versions"},
      dest   = "pinVersions",
      action = "store_true",
      help   = i18n("pin_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"-d","--default"},
      dest   = "defaultOnly",
      action = "store_true",
      help   = i18n("avail_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"-q","--quiet"},
      dest   = "quiet",
      action = "store_true",
      help   = i18n("quiet_hlp")
   }

   cmdlineParser:add_option{
      name   = {"--expert"},
      dest   = "expert",
      action = "store_true",
      help   = i18n("exprt_hlp")
   }

   cmdlineParser:add_option{
      name   = {"-t","--terse"},
      dest   = "terse",
      action = "store_true",
      help   = i18n("terse_hlp")
   }

   cmdlineParser:add_option{
      name   = {"--initial_load"},
      dest   = "initial",
      action = "store_true",
      help   = i18n("initL_hlp")
   }

   cmdlineParser:add_option{
      name   = {"--latest"},
      dest   = "latest",
      action = "store_true",
      help   = i18n("latest_H"),
   }

   cmdlineParser:add_option{
      name   = {"-I", "--ignore_cache"},
      dest   = "ignoreCache",
      action = "store_true",
      help   = i18n("cache_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"--novice"},
      dest   = "novice",
      action = "store_true",
      help   = i18n("novice_H")
   }

   cmdlineParser:add_option{
      name   = {"--raw"},
      dest   = "rawDisplay",
      action = "store_true",
      help   = i18n("raw_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"-w","--width"},
      dest   = "twidth",
      action = "store",
      help   = i18n("width_hlp")
   }

   cmdlineParser:add_option{
      name   = {"-v","--version"},
      dest   = "version",
      action = "store_true",
      help   = i18n("v_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"-r","--regexp"},
      dest   = "regexp",
      action = "store_true",
      help   = i18n("rexp_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"--gitversion"},
      dest   = "gitversion",
      action = "store_true",
      help   = i18n("gitV_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"--dumpversion"},
      dest   = "dumpversion",
      action = "store_true",
      help   = i18n("dumpV_hlp")
   }

   cmdlineParser:add_option{
      name   = {"--dumpname"},
      dest   = "dumpname",
      action = "store_true",
      help   = i18n("dumpN_hlp")
   }

   cmdlineParser:add_option{
      name   = {"--check_syntax", "--checkSyntax"},
      dest   = "checkSyntax",
      action = "store_true",
      help   = i18n("chkSyn_H"),
   }

   cmdlineParser:add_option{
      name   = {"--config" },
      dest   = "config",
      action = "store_true",
      help   = i18n("config_H"),
   }

   cmdlineParser:add_option{
      name   = {"--miniConfig" },
      dest   = "miniConfig",
      action = "store_true",
      help   = i18n("miniConfig_H"),
   }

   cmdlineParser:add_option{
       name   = {"--config_json" },
       dest   = "configjson",
       action = "store_true",
       help   = i18n("jcnfig_H"),
   }

   cmdlineParser:add_option{
      name   = {"--mt" },
      dest   = "reportMT",
      action = "store_true",
      help   = i18n("MT_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"--timer" },
      dest   = "reportTimer",
      action = "store_true",
      help   = i18n("timer_hlp")
   }

   cmdlineParser:add_option{
      name   = {"-f","--force"},
      dest   = "force",
      action = "store_true",
      help   = i18n("force_hlp"),
   }

   cmdlineParser:add_option{
      name   = {"--redirect" },
      dest   = "redirect",
      action = "store_true",
      help   = i18n("redirect_H")
   }

   cmdlineParser:add_option{
      name   = {"--no_redirect" },
      dest   = "redirect_off",
      action = "store_true",
      help   = i18n("nrdirect_H")
   }

   cmdlineParser:add_option{
      name   = {"--show_hidden","-A", "--all"},
      dest   = "show_hidden",
      action = "store_true",
      help   = i18n("hidden_H")
   }

   cmdlineParser:add_option{
      name   = {"--spider_timeout" },
      dest   = "timeout",
      action = "store",
      help   = i18n("spdrT_H"),
      default = 0.0
   }

   cmdlineParser:add_option{
      name   = {"-T", "--trace" },
      dest   = "trace",
      action = "store_true",
      help   = i18n("trace_H"),
      default = 0.0
   }

   cmdlineParser:add_option{
      name   = {"--nx", "--no_extensions"},
      dest   = "no_extensions",
      action = "store_true",
      help   = i18n("nx_H"),
      default = 0.0
   }

   cmdlineParser:add_option{
      name   = {"--loc", "--location"},
      dest   = "location",
      action = "store_true",
      help   = i18n("location_H"),
      default = 0.0
   }

   cmdlineParser:add_option{
      name   = {"--terse_show_extensions"},
      dest   = "terseShowExtensions",
      action = "store_true",
      help   = i18n("terseShowExt_H"),
   }

   cmdlineParser:add_option{
      name   = {"--pod"},
      dest   = "cmdPod",
      action = "store_true",
      help   = i18n("pod_H"),
   }

   local optTbl, pargs = cmdlineParser:parse(arg)
   local optionTbl     = optionTbl()
   optionTbl.pargs     = pargs


   for k in pairs(optTbl) do
      optionTbl[k] = optTbl[k]
   end

   optionTbl.cmdHelpMsg      = ""
   if (optionTbl.cmdHelp or pargs[1] == "help" ) then
      optionTbl.cmdHelpMsg   = cmdlineParser:buildHelpMsg()
   end

   optionTbl.pod      = ""
   if (optionTbl.cmdPod) then
      local a = {}
      a[#a+1] = cmdlineParser:buildManPod()
      a[#a+1] = "\n"
      a[#a+1] = "=head1 COMMAND OVERVIEW\n"
      a[#a+1] = Usage()
      a[#a+1] = "\n"
      a[#a+1] = "=head1 AUTHOR\n\n"
      a[#a+1] = "Robert McLay mclay@tacc.utexas.edu"

      optionTbl.pod   = concatTbl(a,"\n")
   end

   if (optionTbl.trace) then
      cosmic:assign("LMOD_TRACING", "yes")
   end

   if (optionTbl.twidth) then
      setenv_posix("LMOD_TERM_WIDTH",tostring(optionTbl.twidth),true)
   end

   if (optionTbl.novice) then
      setenv_posix("LMOD_EXPERT", nil,true)
      setenv_posix("LMOD_QUIET",  nil,true)
   end

   if (optionTbl.expert) then
      setenv_posix("LMOD_EXPERT", "1",true)
      setenv_posix("LMOD_QUIET",  "1",true)
   end

   if (optionTbl.quiet) then
      setenv_posix("LMOD_QUIET","1",true)
   end

   if (optionTbl.redirect) then
      cosmic:assign("LMOD_REDIRECT", "yes")
   end

   if (optionTbl.redirect_off) then
      cosmic:assign("LMOD_REDIRECT", "no")
   end

   if (optionTbl.pinVersions) then
      cosmic:assign("LMOD_PIN_VERSIONS","yes")
   end
   if (optionTbl.ignoreCache) then
      cosmic:assign("LMOD_IGNORE_CACHE", "yes")
   end

   if (optionTbl.no_extensions) then
      cosmic:assign("LMOD_AVAIL_EXTENSIONS", "no")
   end

   if (optionTbl.show_hidden) then
      cosmic:assign("LMOD_SHOW_HIDDEN", "all")
   end
end

return M
