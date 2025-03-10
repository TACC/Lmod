_G._DEBUG          = false
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
require("declare")
require("fileOps")
require("myGlobals")
require("pairsByKeys")
require("string_utils")

local Version      = require("Version")
local access       = posix.access
local arg_0        = arg[0]
local base64       = require("base64")
local concatTbl    = table.concat
local cosmic       = require("Cosmic"):singleton()
local dbg          = require("Dbg"):dbg()
local decode64     = base64.decode64
local encode64     = base64.encode64
local floor        = math.floor
local getenv       = os.getenv
local hook         = require("Hook")
local huge         = math.huge
local load         = (_VERSION == "Lua 5.1") and loadstring or load
local min          = math.min
local open         = io.open
local readlink     = posix.readlink
local setenv_posix = posix.setenv
local stat         = posix.stat
local strfmt       = string.format
local s_envT       = {}
local s_clrEnvT    = {}
local blank          = " "
local s_indentLevel  = 0
local s_indentString = ""

--------------------------------------------------------------------------
-- This is 5.1 Lua function to cover the table.pack function
-- that is in Lua 5.2 and later.
function argsPack(...)
   local argA = { n = select("#", ...), ...}
   return argA
end
local pack     = (_VERSION == "Lua 5.1") and argsPack or table.pack

function __FILE__()
   return debug.getinfo(2,'S').source
end

function __LINE__()
   return debug.getinfo(2, 'l').currentline
end


local function l_prequire(m)
   local ok, value = pcall(require, m)
   if (not ok) then
      return nil, value
   end
  return value
end



--------------------------------------------------------------------------
-- Generate a message that will fix the available terminal width.
-- @param width The terminal width
function buildMsg(width, argA)
   local a    = {}
   local len  = 0

   if (argA.n == 1 and argA[1]:len() <= width) then
      return argA[1]
   end

   for idx = 1, argA.n do
      local block  = argA[idx] or ""
      local done   = false
      while (not done) do
         local hasNL  = false
         local ja, jb = block:find("\n")
         local line
         if (ja) then
            hasNL = true
            line  = block:sub(1,ja-1)
            block = block:sub(ja+1,-1)
         else
            done  = true
            line  = block
         end

         if (#a > 0 and line:sub(1,1) == '"' and a[#a] == " ") then
            a[#a] = nil
         end

         local i,j, lBlnks = line:find("^( +)")
         local rest        = line
         if (i) then
            a[#a+1] = lBlnks
            len     = len + lBlnks:len()
            rest    = line:sub(j+1,-1)
         end

         for word in rest:split(" +") do
            local wlen = word:len()
            if (wlen + len >= width) then
               a[#a]     = "\n"
               len       = 0
            end
            if (wlen > 0) then
               a[#a + 1] = word
               a[#a + 1] = " "
            end
            len = len + wlen + 1
         end
         if (hasNL) then
            local jc = #a+1
            if (a[#a] == " ") then
               jc = #a
            end
            a[jc] = "\n"
            len   = 0
         end
         if (a[#a] == " ") then
            a[#a] = nil
         end
         local last = (a[#a] or " "):sub(-1)
         if (last ~= '"' and last ~= "\n") then
            a[#a + 1] = " "
         end
      end
   end
   return concatTbl(a,"")
end

function build_fullName(sn, version)
   return (version) and sn .. '/' .. version or sn
end

function build_MT_envT(vstr)
   local vv    = encode64(vstr)
   local vlen  = vv:len()
   local a     = {}
   local blkSz = 512
   local nblks = floor((vlen-1)/blkSz) + 1
   local is    = 1
   local SzStr = "_ModuleTable_Sz_"
   local piece = "_ModuleTable%03d_"
   local t     = {}

   for i = 1, nblks do
      local ie    = min(is + blkSz - 1, vlen)
      local envNm = strfmt(piece,i)
      t[envNm]    = vv:sub(is,ie)
      is          = is + blkSz
   end
   t[SzStr]       = tostring(nblks)
   return t
end

function build_i18n_messages()
   local i18n      = require("i18n")
   local en_msg_fn = pathJoin(cmdDir(),"../messageDir/en.lua")
   if (isFile(en_msg_fn)) then
      i18n.loadFile(en_msg_fn)
   else
      io.stderr:write("Unable to open English message file: ",en_msg_fn,"\n")
      os.exit(1)
   end

   local lmod_lang = cosmic:value("LMOD_LANG")
   if (lmod_lang ~= "en") then
      local msg_fn = pathJoin(cmdDir(),"../messageDir",lmod_lang .. ".lua")
      if (isFile(msg_fn)) then
         i18n.loadFile(msg_fn)
      else
         lmod_lang = "en"
      end
   end

   local site_msg_fn = cosmic:value("LMOD_SITE_MSG_FILE")
   if (site_msg_fn and isFile(site_msg_fn)) then
      lmod_lang = "site"
      i18n.loadFile(site_msg_fn)
   end
   i18n.setLocale(lmod_lang)
end



------------------------------------------------------------
-- Only define the cmdDir function here if it hasn't already
-- been defined. It is defined in the main program unless
-- we are doing unit testing.

if (not _G.cmdDir) then
   function cmdDir()
      return pathJoin(getenv("PROJDIR"),"src")
   end
end

--------------------------------------------------------------------------
-- findLuaProg: Return the path to the lua command or die
function findLuaProg()
   local luaprog, found = "@path_to_lua@", false
   if (luaprog:sub(1,1) == "@") then
      luaprog, found = findInPath("lua")
   else
      found = isFile(luaprog) and posix.access(luaprog, "x")
   end
   if (not found) then
      LmodError{msg="e_Failed_2_Find", name = "lua"}
   end
   return luaprog
end

--------------------------------------------------------------------------
-- Use the *propT* table to colorize the module name when requested by
-- *propT*.
-- @param style How to colorize
-- @param modT The module table contain fullName, sn and fn
-- @param propT The property table
-- @param legendT The legend table.  A key-value pairing of keys to descriptions.
-- @return An array of colorized strings
function colorizePropA(style, mt, modT, mrc, propT, legendT, forbiddenT)
   dbg.start{"colorizePropA(style, mt, modT, mrc, propT, legendT)"}
   local readLmodRC   = require("ReadLmodRC"):singleton()
   local propDisplayT = readLmodRC:propT()
   local iprop        = 0
   local pA           = {}
   local moduleName   = mt:name_w_possible_alias(modT, "full")
   propT              = propT or {}
   forbiddenT         = forbiddenT or {}

   local resultT = mrc:isVisible(modT)
   if (resultT.moduleKindT.kind ~= "normal") then
      local i18n = require("i18n")
      local H    = "H"
      local msg  = "HiddenM"
      if (resultT.moduleKindT.kind == "soft") then
         H = "s"
         msg = "Hidden_softM"
      end
      moduleName = colorize("hidden",modT.fullName)
      pA[#pA+1]  = H
      legendT[H] = i18n(msg)
      if (resultT.moduleKindT.hidden_loaded) then
         pA[#pA+1]     = "HL"
         legendT["HL"] = i18n("HiddenLoadM")
      end
   end

   if (forbiddenT.forbiddenState == "forbid") then
      local i18n = require("i18n")
      local F    = "F"
      local msg  = "ForbiddenM"
      moduleName = colorize("forbid",modT.fullName)
      pA[#pA+1]  = F
      legendT[F] = i18n(msg)
   end

   if (forbiddenT.forbiddenState == "nearly") then
      local i18n  = require("i18n")
      local NF    = "NF"
      local msg   = "NearlyForbiddenM"
      moduleName  = colorize("nearly",modT.fullName)
      pA[#pA+1]   = NF
      legendT[NF] = i18n(msg)
   end

   local resultA      = { moduleName }
   for kk,vv in pairsByKeys(propDisplayT) do
      iprop            = iprop + 1
      local propA      = {}
      local t          = propT[kk]
      local result     = ""
      local color      = nil
      local name_color = nil
      local full_color = false
      if (type(t) == "table") then
         for k in pairs(t) do
            propA[#propA+1] = k
         end

         table.sort(propA);
         local full_color = false
         local n          = concatTbl(propA,":")
         if (vv.displayT[n]) then
            result     = vv.displayT[n][style]
            if (result:sub( 1, 1) == "(" and result:sub(-1,-1) == ")") then
               result  = result:sub(2,-2)
            end
            color      = vv.displayT[n].color
            local k    = colorize(color,result)
            legendT[k] = vv.displayT[n].doc
            full_color = vv.displayT[n].full_color
            if (full_color) then
               resultA[1] = colorize(color,resultA[1])
            end
         end
      end
      local s             = colorize(color,result)
      if (result:len() > 0) then
         pA[#pA+1] = s
      end
   end
   if (#pA > 0) then
      resultA[#resultA+1] = concatTbl(pA,",")
   end
   dbg.fini("colorizePropA")
   return resultA
end

local __expert = false
--------------------------------------------------------------------------
-- Return true if in expert mode.
function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
end

function extractFullName(mpath,file)
   local pattern = '^' .. mpath:escape() .. '/+'
   return file:gsub(pattern,""):gsub("%.lua$","")
end

function extractVersion(fullName, sn)
   local pattern = '^' .. sn:escape() .. '/?'
   local version = fullName:gsub(pattern,"")
   if (version == "") then
      version = false
   end
   return version
end


--------------------------------------------------------------------------
-- Find the admin file (or nag message file).
function findAdminFn()
   local adminFn  = cosmic:value("LMOD_ADMIN_FILE")
   local readable = posix.access(adminFn, 'r') and "yes" or "no"
   return adminFn, readable
end

--------------------------------------------------------------------------
--  Read the admin.list file.  It is a Key value pairing of module names
--  and a message.  The module names can be either the full name or the file
--  name.  The message can be multi-line.  A blank line is signifies the
--  end of the message.
--
--  /path/to/modulefile: Blah Blah Blah
--                       Blah Blah Blah
--
--  module/version:      Blah Blah Blah
--                       Blah Blah Blah
function readAdmin()

   -- If there is anything in [[adminT]] then return because
   -- this routine has already read in the file.
   if (next (adminA)) then return end

   local adminFn = findAdminFn()
   local f       = open(adminFn,"r")

   -- Put something in adminT so that this routine will not be
   -- run again even if the file does not exist.
   adminA[#adminA+1] = { "%%_foo_%%", "bar" }

   if (f) then
      local whole = f:read("*all") .. "\n"
      f:close()

      -- Parse file: ignore "#" comment lines and blank lines
      -- Split lines on ":" module:message

      local state = "init"
      local keyA  = {}
      local value = nil
      local a     = {}

      for v in whole:split("\n") do
         repeat
            v = v:gsub("^%s+$","")
            if (v:find("^%s*#")) then
               -- ignore this comment line
               break

            elseif (v:find("^%s*$")) then
               if (state == "value") then
                  value             = concatTbl(a, "")
                  for i = 1, #keyA do
                     adminA[#adminA+1] = { keyA[i], value }
                  end
                  a                 = {}
                  keyA              = {}
                  state             = "init"
               end

               -- Ignore blank lines
            elseif (state == "value") then
               a[#a+1]     = v .. "\n"
            else
               local i     = v:find(":")
               if (i) then
                  local k = v:sub(1,i-1):trim()
                  for key in k:split('|') do
                     keyA[#keyA+1] = key:trim()
                  end
                  local s = v:sub(i+1)
                  if (s:len() > 0) then
                     a[#a+1]  = s
                  end
                  state    = "value"
               end
            end
         until true
      end
   end
end

--------------------------------------------------------------------------
-- Ask the environment for the ModuleTable value.
-- It is uuencoded and broken into pieces so that the
-- quotes and parens won't confuse the shell's poor little
-- brain.  The number of pieces are stored in the global
-- env. variable.

function getMT()
   local a     = {}
   local SzStr = "_ModuleTable_Sz_"
   local piece = "_ModuleTable%03d_"
   local mtSz  = tonumber(getenv(SzStr)) or huge
   local s     = false

   dbg.print{"getMT: Sz: ",mtSz,"\n"}
   for i = 1, mtSz do
      local envNm = strfmt(piece,i)
      local v     = getenv(envNm)
      if (v == nil) then break end

      a[#a+1]    = v
   end
   if (#a > 0) then
      s = decode64(concatTbl(a,""))
   end
   --dbg.print{"getMT s: ",s,"\n"}
   return s
end

------------------------------------------------------------
-- Get the table of modulerc files with proper weights

local s_fnIgnorePatternsA = { "^.*~", "^#.*", "^%.#.*", "^%..*%.swp"}


function getModuleRCT(remove_MRC_home)
   dbg.start{"getModuleRCT(remove_MRC_home: ",remove_MRC_home,")"}
   local A            = {}
   local MRC_system   = cosmic:value("LMOD_MODULERC")
   local MRC_home     = pathJoin(getenv("HOME"), ".modulerc")
   local MRC_home_lua = pathJoin(getenv("HOME"), ".modulerc.lua")
   dbg.print{"MRC_system: ",MRC_system,"\n"}

   if (MRC_system) then
      local a = {}
      for n in MRC_system:split(":") do
         if (isDir(n) and access(n,"rx")) then
            for f in lfs.dir(n) do
               local valid = true
               for i = 1,#s_fnIgnorePatternsA do
                  local patt = s_fnIgnorePatternsA[i]
                  if (f:find(patt)) then
                     valid = false
                     break
                  end
               end
               if (valid) then
                  local fullPath = pathJoin(n, f)
                  if (isFile(fullPath) and access(fullPath,"r")) then
                     a[#a+1] = fullPath
                  end
               end
            end
         elseif (isFile(n) and access(n,"r")) then
            a[#a+1] = n
         end
      end
      for i = #a, 1, -1 do
         A[#A+1] = { a[i], "s"}
      end
   end
   if (not remove_MRC_home) then
      if (isFile(MRC_home_lua) and access(MRC_home_lua,"r")) then
         A[#A+1] = { MRC_home_lua, "u"}
      elseif (isFile(MRC_home) and access(MRC_home,"r")) then
         A[#A+1] = { MRC_home, "u"}
      end
   end
   dbg.printT("fnA",A)
   dbg.fini("getModuleRCT")
   return A
end

-----------------------------------------------------------------------
-- This function decides if the modulefile is a marked default
-- The rule is that a marked default is given in the first character
-- after the '/' if there is one.  A marked default will either be
-- '^','s' or 'u'.  All of these characters are >= '^'
function isMarked(wV)
   local i,j = wV:find(".*/")
   j = j and j+1 or 1
   local c = wV:sub(j,j)
   return (c >= '^')
end

--------------------------------------------------------------------------
-- compute the length of a string and ignore any string
-- colorization.
-- @param s input string
function length(s)
   s = s:gsub("\027[^m]+m","")
   return s:len()
end


local s_optionTbl = {}
--------------------------------------------------------------------------
-- Manage the Hub Hash Table.
function optionTbl()
   return s_optionTbl
end

masterTbl = optionTbl

function paired2pathT(path)
   if (not path) then
      return {}
   end

   local ppathT = {}

   local state = 0
   local left
   local right

   for v in path:split('[;:]') do
      if (state == 0) then
         left = v
         state = 1
      else
         right = v
         state = 0
         ppathT[left] =  tonumber(right)
      end
   end
   return ppathT
end

--------------------------------------------------------------------------
-- This function takes a path like variable and breaks
-- it up into an array.  Each path component is
-- standandized by path_regularize().  This function
-- removes leading and trailing spaces and duplicate '/'
-- etc.
--
-- Typically the separator is a colon but it can be
-- anything.  Some env. vars (such as TEXINPUTS and
-- LUA_PATH) use "::" or ";;" to mean that the
-- specified values are prepended to the system ones.
-- To handle that, the path component is converted to
-- a single space.  This single space is later removed
-- when expanding.
-- @param path A string of *delim* separated paths.
-- @param delim  The separator character.  It is usually
--               a colon.
function path2pathA(path, delim, clearDoubleSlash)
   delim = delim or ":"
   if (not path) then
      return {}
   end
   if (path == '') then
      return { '' }
   end

   -- If path is /sw1/man::/sw2/man then
   -- keep the double delim's
   -- However convert /sw1/man:::/sw2/man to
   --                 /sw1/man::/sw2/man

   local delimPatt = delim .. delim .. "+";
   local delimStr  = delim .. delim
   path = path:gsub(delimPatt,delimStr)

   local pathA = {}
   for v  in path:split(delim) do
      local path = path_regularize(v)
      if (clearDoubleSlash) then
         path = path:gsub("//+" , "/")
         path = path:gsub("/$"  , "")
      end
      pathA[#pathA + 1] = path
   end

   local n = #pathA
   local i = n
   while (pathA[i] == "" or pathA[i] == " ") do
      i = i - 1
   end
   i = i + 2
   for j = i, n do
      pathA[j] = nil
   end

   return pathA
end

local __quiet = false
--------------------------------------------------------------------------
-- Return true if in quiet mode.
function quiet()
   if (__quiet == false) then
      __quiet = getenv("LMOD_QUIET") or getenv("LMOD_EXPERT")
   end
   return __quiet
end

function regular_cmp(x,y)
   return x.pV < y.pV
end


local function l_sanizatizeTbl(replaceA, inT, outT)
   for k, v in pairs(inT) do
      local key = k
      if (type(k) == "string") then
         for i = 1, #replaceA do
            local p  = replaceA[i]
            local s1 = p[1]
            local s2 = p[2]
            key = key:gsub(s1,s2)
         end
      end

      if (type(key) == "string" and key:sub(1,2) == '__') then
         outT[key] = nil
      elseif (type(v) == "table") then
         outT[key] = {}
         l_sanizatizeTbl(replaceA, v, outT[key])
         v = outT[key]
      elseif (type(v) == "string") then
         for i = 1,#replaceA do
            local p  = replaceA[i]
            local s1 = p[1]
            local s2 = p[2]
            v = v:gsub(s1,s2)
         end
         outT[key] = v
      else
         outT[key] = v
      end

   end
end

function sanizatizeTbl(rplmntA, inT, outT)
   local replaceA = {}
   for i = 1,#rplmntA do
      local p = rplmntA[i]
      replaceA[i] = { p[1]:escape(), p[2]}
   end

   l_sanizatizeTbl(replaceA, inT, outT)
end


--------------------------------------------------------------------------
-- Push the Lmod Version into the environment
function setenv_lmod_version()
   local nameA = { "LMOD_VERSION_MAJOR",
                   "LMOD_VERSION_MINOR",
                   "LMOD_VERSION_SUBMINOR"
   }

   local versionStr = Version.tag()

   setenv_posix("LMOD_VERSION",versionStr, true)
   local numA = {}

   for s in versionStr:split("%.") do
      numA[#numA+1] = s
   end

   for i = 1, #nameA do
      setenv_posix(nameA[i],numA[i] or "0", true)
   end

   setenv_posix("ModuleTool",        "Lmod",     true)
   setenv_posix("ModuleToolVersion", versionStr, true)
end

--------------------------------------------------------------------------
-- This routine converts a command into a string.  This is used by MC_Show
-- @param name Input command name.
-- @param mA   An array of Module Name objects.
function ShowCmdA(name, mA)
   local a = {}
   for i = 1, #mA do
      a[i] = mA[i]:show()
   end
   local b = {}
   b[#b+1] = name
   b[#b+1] = "("
   b[#b+1] = concatTbl(a,",")
   b[#b+1] = ")\n"
   return concatTbl(b,"")
end

--------------------------------------------------------------------------
-- Convert number and string to a quoted string.
-- @param v input number or string.
local function l_arg2str(v)
   if (v == nil) then return v end
   local s = tostring(v)
   if (type(v) ~= "boolean") then
      s = "\"".. s .."\""
   end
   return s
end

--------------------------------------------------------------------------
-- Build a string of what the command would be. Used by
-- MC_Show and MC_ComputeHash.

local s_defaultsT = {
   delim    = ":",
   priority = "0",
}

--------------------------------------------------------------------------
-- Modify output indentation by +/- 2 ' '
-- MC_Show

function s_indent(i)
   s_indentLevel  = s_indentLevel + i
   s_indentString = blank:rep(s_indentLevel*2)
end

--------------------------------------------------------------------------
-- This routine converts a command into a string.  This is used by MC_Show
-- @param name Input command name.
function ShowCmdStr(name, argT)
   dbg.start{"ShowCmdStr(",name,", ...)"}
   local a       = {}
   local n       = argT.n
   local hasKeys = false
   local left    = "("
   local right   = ")\n"
   for i = 1, n do
      local s = l_arg2str(argT[i])
      if (s ~= nil) then
         a[#a + 1] = s
      end
   end

   local b = {}
   b[#b+1] = s_indentString
   b[#b+1] = name
   b[#b+1] = left
   b[#b+1] = concatTbl(a,",")
   b[#b+1] = right
   dbg.fini("ShowCmdStr")
   return concatTbl(b,"")
end

--------------------------------------------------------------------------
-- This routine formats table-style module commands to match the modulefile format
-- @param name The command name (e.g. "setenv")
-- @param t The table of arguments
function ShowCmdTbl(name, argT)
   dbg.start{"ShowCmdTbl(",name,", argT)"}
   
   local ignoreKeysT = { n = true, kind = true }
   if (argT.modeA and next(argT.modeA) ~= nil and #argT.modeA  == 1 and argT.modeA[1] == "normal") then
      ignoreKeysT.modeA = true
   end


   local s = name .. serializeTbl{value=argT, ignoreKeysT = ignoreKeysT, dsplyNum = "string", tight = "tight"}
   local a = {}
   a[#a + 1] = s_indentString
   a[#a + 1] = s
   a[#a + 1] = "\n"
   
   dbg.fini("ShowCmdTbl")
   return concatTbl(a,"")
end

--------------------------------------------------------------------------
-- This routine prints a help message.  This is used by MC_Show
function ShowHelpStr(...)
   dbg.start{"ShowHelpStr(...)"}

   local argA    = pack(...)
   local a       = {}
   a[1]          = s_indentString .. "help([["
   for i = 1,argA.n do
      for line in argA[i]:split("\n") do
         a[#a + 1] = line
         a[#a + 1] = "\n" .. s_indentString
      end
      a[#a] = "]],[[\n" .. s_indentString
   end
   a[#a] = "]])\n"
   dbg.fini("ShowHelpStr")
   return concatTbl(a,"")

end

local s_decoyT    = false
local s_decorateT = false

function decorateModule(name, resultT, forbiddenT)
   if (not s_decorateT) then
      s_decoyT = {
         forbiddenState = "normal"
      }
      local decorate = cosmic:value("LMOD_TERSE_DECORATIONS")
      if (decorate == "yes") then
         s_decorateT = {
            normal  = "",
            hidden  = " <H>",
            soft    = " <H>",
            forbid  = " <F>",
            nearly  = " <NF>",
         }
      else
         s_decorateT = {
            normal  = "",
            hidden  = "",
            soft    = "",
            forbid  = "",
            nearly  = "",
         }
      end
   end

   local fT = forbiddenT
   if (not forbiddenT or next(forbiddenT) == nil) then
      fT = s_decoyT
   end

   local a = {}
   a[#a+1] = name
   a[#a+1] = s_decorateT[resultT.moduleKindT.kind or "normal"]
   a[#a+1] = s_decorateT[fT.forbiddenState]
   return concatTbl(a,"")
end

--------------------------------------------------------------------------
-- Unique string that combines the current time/date
-- with a uuid id string.
function UUIDString(epoch)
   local ymd  = os.date("*t", epoch)

   --                                y    m    d    h    m    s
   local uuid_date = string.format("%d_%02d_%02d_%02d_%02d_%02d",
                                   ymd.year, ymd.month, ymd.day,
                                   ymd.hour, ymd.min,   ymd.sec)

   local uuidgen, found = findInPath('uuidgen')
   local uuid_str
   if (found) then
       uuid_str = capture('uuidgen'):sub(1,-2)
   else
      -- if uuidgen is not available, fall back to reading /proc/sys/kernel/random/uuid
      -- note: only works on Linux
      local f = open('/proc/sys/kernel/random/uuid', 'r')
      if f then
         uuid_str = f:read('*all'):sub(1,-2)
      else
         LmodError{msg="e_No_UUID"}
      end
   end

   local uuid      = uuid_date .. "-" .. uuid_str

   return uuid
end

function case_independent_cmp(x,y)
   local x_lower = x.pV:lower()
   local y_lower = y.pV:lower()
   if (x_lower == y_lower) then
      return x.pV < y.pV
   else
      return x_lower < y_lower
   end
end


--------------------------------------------------------------------------
-- Warning functions
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- Allow for the generation of warnings.
function activateWarning()
   s_haveWarnings = true
end

--------------------------------------------------------------------------
-- Disallow the generation of warnings.
function deactivateWarning()
   s_haveWarnings = false
end

--------------------------------------------------------------------------
-- Are the generation of warnings allowed?
function haveWarnings()
   return s_haveWarnings
end

--------------------------------------------------------------------------
-- Set warning flags to true.
function setStatusFlag()
   dbg.print{"setting status flag\n"}
   s_status = true
end

--------------------------------------------------------------------------
-- Get warning flag value.
function getStatusFlag()
   return s_status
end

local function l_restoreEnv(oldEnvT, newEnvT)
   dbg.start{"l_restoreEnv(oldEnvT, newEnvT)"}
   local envT = {}
   for k,v in newEnvT do
      local old = origEnvT[k]
      if (old == nil) then
         envT[k] = false
      elseif (v ~= old) then
         envT[k] = v
      end
      origEnvT[k] = nil
   end

   for k,v in origEnvT do
      local new = newEnvT[k]
      if (new == nil) then
         envT[k] = v
      end
   end

   dbg.printT("envT",envT)
   for k,v in envT do
      setenv_posix(k,v or nil, true)
   end
   dbg.fini("l_restoreEnv")
end


local function l_runTCLprog(TCLprog, tcl_args)
   local a        = {}
   local origEnvT = posix.getenv()
   a[#a + 1]      = cosmic:value("LMOD_TCLSH")
   a[#a + 1]      = TCLprog
   a[#a + 1]      = tcl_args or ""
   local cmd      = concatTbl(a," ")
   local whole, status = capture(cmd)
   local newEnvT  = posix.getenv()

   return whole, status
end

--------------------------------------------------------------------------
-- Build function -> accept, epoch, prepend_order_function(), runTCLprog
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- determine which version of runTCLprog to use

local function l_build_runTCLprog()
   local fast_tcl_interp = cosmic:value("LMOD_FAST_TCL_INTERP")
   if (fast_tcl_interp == "no") then
      _G.runTCLprog = l_runTCLprog
   else
      local m = l_prequire("tcl2lua")
      if (not m) then
         _G.runTCLprog = l_runTCLprog
      else
         _G.runTCLprog = m.runTCLprog
      end
   end
end

function usingFastTCLInterp()
   return (_G.runTCLprog ~= l_runTCLprog) and "yes" or "no"
end

--------------------------------------------------------------------------
-- Create the accept functions to allow or ignore TCL modulefiles.
local function l_build_accept_function()
   local allow_tcl = cosmic:value("LMOD_ALLOW_TCL_MFILES")

   if (allow_tcl == "no") then
      _G.accept_fn = function (fn)
         return fn:find("%.lua$")
      end
   else
      _G.accept_fn = function (fn)
         return true
      end
   end
end

local function l_build_allow_dups_function()
   local dups = cosmic:value("LMOD_DUPLICATE_PATHS")
   if (dups == "yes") then
      _G.allow_dups = function (dupsIn)
         return dupsIn
      end
   else
      _G.allow_dups = function (dupsIn)
         return false
      end
   end
end

local function l_build_epoch_function()
   if (posix.gettimeofday) then
      local gettimeofday = posix.gettimeofday
      local x1, x2 = gettimeofday()
      if (x2 == nil) then
         epoch_type = "posix.gettimeofday() (1)"
         _G.epoch = function()
            local t = gettimeofday()
            return t.sec + t.usec*1.0e-6
         end
      else
         epoch_type = "posix.gettimeofday() (2)"
         _G.epoch = function()
            local t1, t2 = gettimeofday()
            return t1 + t2*1.0e-6
         end
      end
   else
      epoch_type = "os.time"
      local time = os.time
      _G.epoch = function()
         return time()
      end
   end
end

if (not epoch) then
   l_build_epoch_function()
end


--------------------------------------------------------------------------
-- Return the *prepend_order* function.  This function control which order
-- are prepends handled when there are multiple paths passed to a single
-- call.
local function l_build_prepend_order_function()
   local ansT = {
      no      = "reverse",
      reverse = "reverse",
      normal  = "normal",
      yes     = "normal",
   }

   local prepend_block = cosmic:value("LMOD_PREPEND_BLOCK")
   local order         = ansT[prepend_block] or "normal"
   if (order == "normal") then
      _G.prepend_order = function (n)
         return n, 1, -1
      end
   else
      _G.prepend_order = function (n)
         return 1, n, 1
      end
   end
end

local s_checkSyntaxMode = false
function setSyntaxMode(state)
   s_checkSyntaxMode = state
end
function checkSyntaxMode()
   return s_checkSyntaxMode
end

declare("QuarantineT")

local function l_build_quarantineT()

   QuarantineT = {}
   if (LMOD_QUARANTINE_VARS) then
      local qA = path2pathA(LMOD_QUARANTINE_VARS)
      for i = 1,#qA do
         QuarantineT[qA[i]] = true
      end
   end
end

------------------------------------------------------------
-- Save changes to env when processing spider cache
function save_set_env(name, value)
   local oldV = getenv(name)
   if (not  oldV and not s_envT[name]) then
      s_clrEnvT[name] = true
   else
      s_envT[name] = oldV
   end
   posix.setenv(name, value, true)
end

function reset_env()
   local setenv_posix = posix.setenv
   for k, v in pairs(s_envT) do
      setenv_posix(k, v, true)
   end
   for k in pairs(s_clrEnvT) do
      setenv_posix(k, nil, true)
   end
   s_clrEnvT = {}
   s_envT    = {}
end

------------------------------------------------------------
-- Initialize Lmod

function initialize_lmod()
   -- Push Lmod version into environment
   setenv_lmod_version()

   ------------------------------------------------------------------------
   --  The StandardPackage is where Lmod registers hooks.  Sites may
   --  override the hook functions in SitePackage.
   ------------------------------------------------------------------------
   cosmic:set_key("StdPkg")
   require("StandardPackage")

   ------------------------------------------------------------------------
   -- Load a SitePackage Module.
   ------------------------------------------------------------------------

   local configDir = cosmic:value("LMOD_CONFIG_DIR")
   local fn        = pathJoin(configDir,"lmod_config.lua")
   if (isFile(fn)) then
      assert(loadfile(fn))()
      cosmic:assign("LMOD_CONFIG_LOCATION",fn)
   end

   cosmic:set_key("lmod_cfg")
   build_i18n_messages()
   l_build_runTCLprog()
   l_build_accept_function()
   l_build_allow_dups_function()
   l_build_prepend_order_function()
   if (not QuarantineT) then
      l_build_quarantineT()
   end

   local lmodPath = cosmic:value("LMOD_PACKAGE_PATH")
   for path in lmodPath:split(":") do
      path = path .. "/"
      path = path:gsub("//+","/")
      package.path  = path .. "?.lua;"      ..
                      path .. "?/init.lua;" ..
                      package.path

      package.cpath = path .. "../lib/?.so;"..
                      package.cpath
   end

   local locSitePkg = locatePkg("SitePackage")
   cosmic:assign("LMOD_SITEPACKAGE_LOCATION",locSitePkg)
   cosmic:set_key("SitePkg")
   require("SitePackage")
   cosmic:set_key("Other")
   colorize_init()
   if (cosmic:value("LMOD_TMOD_PATH_RULE") == "yes") then
      cosmic:assign("LMOD_DUPLICATE_PATHS", "no")
   end
   local ignore_cache = cosmic:value("LMOD_IGNORE_CACHE") == "yes"
   local cached_loads = cosmic:value("LMOD_CACHED_LOADS")
   cosmic:assign("LMOD_CACHED_LOADS", ignore_cache and "no" or cached_loads)
   local ancient = cosmic:value("LMOD_ANCIENT_TIME")
   ------------------------------------------------------------------------
   -- shortLifeCache: If building the cache file is fast then shorten the
   --                 ancient to this time.
   ------------------------------------------------------------------------
   shortLifeCache = ancient/12

end

function tracing_msg(msgA)
   local FrameStk   = require("FrameStk")
   local shell      = _G.Shell
   local stackDepth = FrameStk:singleton():stackDepth()
   local indent     = ("  "):rep(stackDepth+1)
   local b          = {}
   b[#b + 1]        = indent
   for i = 1,#msgA do
      b[#b+1] = msgA[i]
   end
   b[#b + 1]        = "\n"
   shell:echo(concatTbl(b,""))
end

function dynamic_shell(shellNm)
   local BaseShell = require("BaseShell")
   local success   = false

   if (shellNm ~= "shell") then
      if (BaseShell.isValid(shellNm)) then
         -- Trust a valid shell and report the shell name is valid and return
         success = true
         return shellNm, success
      end
   else
      -- If here then the name of the shell is "shell" and it is "valid"
      success = true
   end

   ------------------------------------------------------------
   -- Dynamically find the shell from the parent process
   local ppid  = posix.getpid("ppid")
   local n     = shellNm
   local fn    = "/proc/"..ppid.."/exe"
   local found = false
   if (isFile(fn)) then
      n = posix.readlink(fn)
      if (not n) then
         local cmd = "readlink "..fn
         n = capture(cmd):gsub("%s+$","")
      end
      n = barefilename(n)
      if (BaseShell.isValid(n)) then
         shellNm = n
         return shellNm, success
      end
   end

   local ps_cmd = "@ps@"
   if ( ps_cmd:sub(1,1) == "@" ) then
      ps_cmd = "ps"
   end
   local cmd = ps_cmd.." -p "..ppid.." -ocomm="
   n         = capture(cmd):gsub("^%-",""):gsub("%s+$","")
   n         = barefilename(n)
   if (BaseShell.isValid(n)) then
      shellNm = n
   else
      shellNm = "bash"  -- If "n" is not a valid shell assume bash.
   end
   return shellNm, success
end

function locatePkg(pkg)
   local result = nil
   for path in package.path:split(";") do
      local s = path:gsub("?",pkg)
      if (isFile(s)) then
         result = realpath(s)
         break
      end
   end
   return result
end

function wrap_kind(kind, name)
   return kind .. "<" .. name .. ">"
end
function unwrap_kind(kind, name)
   local i,j,n = name:find(kind .. "<([^<]*)>")
   return n
end
