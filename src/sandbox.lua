sandbox_env = {
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
  os       = { clock = os.clock, difftime = os.difftime, time = os.time, date = os.date},

  ------------------------------------------------------------
  -- lmod functions
  ------------------------------------------------------------

  --- Load family functions ----

  load                 = load
  try_load             = try_load
  try_add              = try_load
  unload               = unload
  always_load          = always_load
  always_unload        = always_unload

  --- PATH functions ---
  prepend_path         = prepend_path
  append_path          = append_path
  remove_path          = remove_path
  
  --- Set Environment functions ----
  setenv               = setenv
  unsetenv             = unsetenv

  --- Property functions ----
  add_property         = add_property 
  remove_property      = remove_property 
  
  --- Set Alias/shell functions ---
  set_alias            = set_alias
  unset_alias          = unset_alias
  set_shell_function   = set_shell_function
  unset_shell_function = unset_shell_function
  
  --- Prereq / Conflict ---
  prereq               = prereq
  prereq_any           = prereq_any
  conflict             = conflict
  
  --- Family function ---
  family               = family
  
  --- Inherit function ---
  inherit              = inherit

  -- Whatis / Help functions
  whatis               = whatis
  help                 = help

  -- Misc --
  LmodError            = LmodError
  LmodWarning          = LmodWarning
  LmodMessage          = LmodMessage
  is_spider            = is_spider
  mode                 = mode
  isloaded             = isloaded
  isPending            = isPending

  myFileName           = myFileName

  hierarchyA           = hierarchyA
}
