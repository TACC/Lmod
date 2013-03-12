require("strict")
require("fileOps")
require("capture")
require("cmdfuncs")
sandbox_run = false

sandbox_env = {
  require  = require,
  ipairs   = ipairs,
  next     = next,
  pairs    = pairs,
  pcall    = pcall,
  tonumber = tonumber,
  tostring = tostring,
  type     = type,
  unpack   = unpack,
  string   = { byte = string.byte, char = string.char, find = string.find, 
               format = string.format, gmatch = string.gmatch, gsub = string.gsub, 
               len = string.len, lower = string.lower, match = string.match, 
               rep = string.rep, reverse = string.reverse, sub = string.sub, 
               upper = string.upper },
  table    = { insert = table.insert, remove = table.remove, sort = table.sort,
               concat = table.concat },
  math     = { abs = math.abs, acos = math.acos, asin = math.asin, 
               atan = math.atan, atan2 = math.atan2, ceil = math.ceil, cos = math.cos, 
               cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor, 
               fmod = math.fmod, frexp = math.frexp, huge = math.huge, 
               ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max, 
               min = math.min, modf = math.modf, pi = math.pi, pow = math.pow, 
               rad = math.rad, random = math.random, sin = math.sin, sinh = math.sinh, 
               sqrt = math.sqrt, tan = math.tan, tanh = math.tanh },
  os       = { clock = os.clock, difftime = os.difftime, time = os.time, date = os.date,
               getenv = os.getenv},

  io       = { stderr = io.stderr, open = io.open, close = io.close, write = io.write },

  ------------------------------------------------------------
  -- lmod functions
  ------------------------------------------------------------

  --- Load family functions ----

  load                 = load,
  try_load             = try_load,
  try_add              = try_load,
  unload               = unload,
  always_load          = always_load,
  always_unload        = always_unload,

  --- PATH functions ---
  prepend_path         = prepend_path,
  append_path          = append_path,
  remove_path          = remove_path,
  
  --- Set Environment functions ----
  setenv               = setenv,
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

  -- Misc --
  LmodError            = LmodError,
  LmodWarning          = LmodWarning,
  LmodMessage          = LmodMessage,
  is_spider            = is_spider,
  mode                 = mode,
  isloaded             = isloaded,
  isPending            = isPending,
  myFileName           = myFileName,
  hierarchyA           = hierarchyA,

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
  abspath              = abspath,

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
  posix = { uname = posix.uname, setenv = posix.setenv, hostid = posix.hostid,
            open = posix.open, openlog = posix.openlog, closelog = posix.closelog,
            syslog = posix.syslog, }


  ------------------------------------------------------------
  -- Mics functions
  ------------------------------------------------------------
  capture              = capture,
  UUIDString           = UUIDString,
}

function sandbox_registration(t)

   if (type(t) ~= "table") then
      LmodError("sandbox_registration: The argument passed is: \"", type(t), "\". It should be a table")
   end

   for k,v in pairs(t) do
      sandbox_env[k] = v
   end
end



local function run5_1(untrusted_code)
  if untrusted_code:byte(1) == 27 then return nil, "binary bytecode prohibited" end
  local untrusted_function, message = loadstring(untrusted_code)
  if not untrusted_function then return nil, message end
  setfenv(untrusted_function, sandbox_env)
  return pcall(untrusted_function)
end

-- run code under environment [Lua 5.2]
local function run5_2(untrusted_code)
  local untrusted_function, message = load(untrusted_code, nil, 't', sandbox_env)
  if not untrusted_function then return nil, message end
  return pcall(untrusted_function)
end

local version = _VERSION:gsub("^Lua%s+","")
sandbox_run = run5_1
if (version == "5.2") then
   sandbox_run = run5_2
end

   
