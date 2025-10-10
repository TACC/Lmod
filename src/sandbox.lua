--------------------------------------------------------------------------
-- Modulefiles are "loaded" in a sandbox.  That is when the module
-- file is evaluated, it can only run a limited set of functions.
-- This file provides for a default list of functions that can be
-- run.  There is also a sandbox_registration so that sites using
-- SitePackage can register their functions. Finally there are two
-- versions of run function one for Lua 5.1 and another for Lua 5.2
-- The appropriate version is assigned to [[sandbox_run]].
--
-- @module sandbox

_G._DEBUG   = false               -- Required by the new lua posix
local posix = require("posix")

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

require("fileOps")
require("capture")
require("modfuncs")
require("string_utils")
require("utils")
require("declare")
local lfs   = require("lfs")
local dbg   = require("Dbg"):dbg()
sandbox_run = false

local s_old_write    = nil
local s_file_methods = nil

--------------------------------------------------------------------------
-- Table containing valid functions for modulefiles.
local sandbox_env = {
  assert     = assert,
  loadfile   = loadfile,
  require    = require,
  ipairs     = ipairs,
  next       = next,
  pairs      = pairs,
  pcall      = pcall,
  dofile     = dofile_not_supported,
  loadstring = (_VERSION == "Lua 5.1") and loadstring or load,
  tonumber   = tonumber,
  tostring   = tostring,
  type       = type,
  unpack     = (_VERSION == "Lua 5.1") and unpack or table.unpack,
  string     = { byte = string.byte, char = string.char, find = string.find,
                 format = string.format, gmatch = string.gmatch, gsub = string.gsub,
                 len = string.len, lower = string.lower, match = string.match,
                 rep = string.rep, reverse = string.reverse, sub = string.sub,
                 upper = string.upper, split = string.split, escape = string.escape},
  table      = { insert = table.insert, remove = table.remove, sort = table.sort,
                 concat = table.concat, unpack = table.unpack, sqrt = math.sqrt,
                 tan = math.tan, tanh = math.tanh },
  os         = { clock = os.clock, difftime = os.difftime, time = os.time, date = os.date,
                 getenv = os.getenv, execute = os.execute, exit = os.exit },

  io         = { stderr = io.stderr, open = io.open, close = io.close, write = io.write,
                 stdout = io.stdout, popen = io.popen},

  package    = { cpath = package.cpath, loaded = package.loaded, loaders = package.loaders,
                 loadlib = package.loadlib, path = package.path, preload = package.preload,
                 seeall = package.seeall },

  math       = { floor = math.floor, ceil = math.ceil, min = math.min, max = math.max },

  ------------------------------------------------------------
  -- lmod functions
  ------------------------------------------------------------

  --- Load family functions ----

  load                 = load_module,
  load_any             = load_any,
  try_load             = try_load,
  try_add              = try_load,
  mgrload              = mgrload,
  unload               = unload,
  always_load          = always_load,
  depends_on           = depends_on,
  depends_on_any       = depends_on_any,

  --- Load Modify functions ---
  atleast              = atleast,
  atmost               = atmost,
  between              = between,
  latest               = latest,

  --- PATH functions ---
  prepend_path         = prepend_path,
  append_path          = append_path,
  remove_path          = remove_path,

  --- Set Environment functions ----
  setenv               = setenv,
  pushenv              = pushenv,
  unsetenv             = unsetenv,

  --- Property functions ----
  add_property         = add_property,
  remove_property      = remove_property,

  --- Set Alias/shell functions ---
  set_alias            = set_alias,
  unset_alias          = unset_alias,
  set_shell_function   = set_shell_function,
  unset_shell_function = unset_shell_function,

  --- Prereq / Conflict ---
  prereq               = prereq,
  prereq_any           = prereq_any,
  conflict             = conflict,

  --- Family function ---
  family               = family,

  --- Inherit function ---
  inherit              = inherit,

  -- Whatis / Help functions
  whatis               = whatis,
  help                 = help,

  -- meta data foo ---
  extensions           = extensions,

  -- Shell script foo --
  source_sh            = source_sh,
  complete             = complete,
  uncomplete           = uncomplete,

  -- Misc --
  export_shell_function = export_shell_function,
  purge                 = purge,
  haveDynamicMPATH      = haveDynamicMPATH,
  LmodBreak             = LmodBreak,
  source_sh             = source_sh,
  LmodMsgRaw            = LmodMsgRaw,
  LmodError             = LmodError,
  LmodMessage           = LmodMessage,
  LmodVersion           = LmodVersion,
  LmodWarning           = LmodWarning,
  convertToCanonical    = convertToCanonical,
  hierarchyA            = hierarchyA,
  isPending             = isPending,
  isloaded              = isloaded,
  isAvail               = isAvail,
  loaded_modules        = loaded_modules,
  mode                  = mode,
  moduleStackTraceBack  = moduleStackTraceBack,
  myConfig              = myConfig,
  myFileName            = myFileName,
  myModuleFullName      = myModuleFullName,
  myModuleName          = myModuleName,
  myModuleUsrName       = myModuleUsrName,
  myModuleVersion       = myModuleVersion,
  myShellName           = myShellName,
  myShellType           = myShellType,
  print                 = print,
  requireFullName       = requireFullName,
  userInGroup           = userInGroup,
  userInGroups          = userInGroups,
  colorize              = colorize,
  color_banner          = color_banner,


  -- Normal modulefiles should not use these function(s):
  LmodSystemError      = LmodSystemError,   -- Normal Modulefiles should use
                                            -- LmodError instead.  LmodError
                                            -- is inactive during avail and spider.
                                            -- This function ALWAYS produces an
                                            -- error.

  is_spider            = is_spider,         -- This function should not be used.
                                            -- It is better to use
                                            --      if (mode() == "spider") then ... end
                                            -- This function will deprecated and will be removed

  always_unload        = always_unload,     -- This function is exactly the same as unload()
                                            -- This function will deprecated and will be removed
  ------------------------------------------------------------
  -- fileOp functions
  ------------------------------------------------------------
  pathJoin             = pathJoin,
  isDir                = isDir,
  isFile               = isFile,
  mkdir_recursive      = mkdir_recursive,
  dirname              = dirname,
  extname              = extname,
  removeExt            = removeExt,
  barefilename         = barefilename,
  splitFileName        = splitFileName,
  abspath              = realpath,
  realpath             = realpath,
  path_regularize      = path_regularize,

  ------------------------------------------------------------
  -- dbg functions
  ------------------------------------------------------------
  dbg = { active = dbg.active, fini  = dbg.fini, print = dbg.print,
          print2D = dbg.print2D, printA = dbg.printA, printT = dbg.printT,
          start = dbg.start },

  ------------------------------------------------------------
  -- lfs functions
  ------------------------------------------------------------
  lfs = { attributes = lfs.attributes, chdir = lfs.chdir, lock_dir = lfs.lock_dir,
          currentdir = lfs.currentdir, dir = lfs.dir, lock = lfs.lock,
          mkdir = lfs.mkdir, rmdir = lfs.rmdir, rmdir = lfs.rmdir,
          setmode = lfs.setmode, symlinkattributes = lfs.symlinkattributes,
          touch = lfs.touch, unlock = lfs.unlock,
  },

  ------------------------------------------------------------
  -- posix functions
  ------------------------------------------------------------
  posix = { uname = posix.uname, setenv = posix.setenv,
            hostid = posix.hostid, open = posix.open,
            openlog = posix.openlog, closelog = posix.closelog,
            syslog = posix.syslog, stat = posix.stat},

  ------------------------------------------------------------
  -- Misc functions
  ------------------------------------------------------------
  subprocess           = subprocess,
  capture              = capture,
  UUIDString           = UUIDString,
  execute              = execute,
  isDefined            = isDefined,
  isNotDefined         = isNotDefined,

  ------------------------------------------------------------
  -- Misc System Values
  ------------------------------------------------------------
  _VERSION             = _VERSION,
}

--------------------------------------------------------------------------
-- Sites should call this function if they have
-- functions inside their SitePackage.lua file for
-- any functions that they want that are callable
-- via their modulefiles.
-- @param t A table
function sandbox_registration(t)
   if (type(t) ~= "table") then
      LmodError{msg="e_missing_table", kind = type(t)}
   end
   for k,v in pairs(t) do
      sandbox_env[k] = v
   end
end

function sandbox_set_os_exit(func)
   sandbox_env.os.exit = func
end

function turn_off_stdio()
   s_file_methods = getmetatable(io.stdout).__index  -- any file will do
   s_old_write    = s_file_methods.write
   s_file_methods.write =
      function(f,...)
         if (f ~= io.stdout and f ~= io.stderr) then
            return s_old_write(f,...)
         end
         return f
      end
end

function turn_on_stdio()
   s_file_methods.write = s_old_write
end

--------------------------------------------------------------------------
-- This function is what actually "loads" a modulefile with protection
-- against modulefiles call functions they shouldn't or syntax errors
-- of any kind.
-- @param untrusted_code A string containing lua code

local function l_run5_1(untrusted_code)
  if untrusted_code:byte(1) == 27 then return nil, "binary bytecode prohibited" end
  local untrusted_function, message = loadstring(untrusted_code)
  if not untrusted_function then return nil, message end
  setfenv(untrusted_function, sandbox_env)
  return pcall(untrusted_function)
end

--------------------------------------------------------------------------
-- This function is what actually "loads" a modulefile with protection
-- against modulefiles call functions they shouldn't or syntax errors
-- of any kind. This run codes under environment [Lua 5.2] or later.
-- @param untrusted_code A string containing lua code
local function l_run5_2(untrusted_code)
  local untrusted_function, message = load(untrusted_code, nil, 't', sandbox_env)
  if not untrusted_function then return nil, message end
  return pcall(untrusted_function)
end

--------------------------------------------------------------------------
-- Define two version: Lua 5.1 or 5.2.  It is likely that
-- The 5.2 version will be good for many new versions of
-- Lua but time will only tell.
sandbox_run = (_VERSION == "Lua 5.1") and l_run5_1 or l_run5_2
