require("strict")


local Dbg         = require("Dbg")
local ModuleStack = require("ModuleStack")
local _concatTbl  = table.concat

local function concatTbl(aa,sep)

   local a = {}
   for i = 1, #aa do
      local v     = aa[i]
      local vType = type(v)
      if ( vType == "string") then
         a[i] = v
      elseif (vType == "number") then
         a[i] = tostring(v)
      else
         a[i] = vType
      end
   end
   return _concatTbl(a, sep)
end


function validateStringArgs(cmdName, msg, ...)
   for i, v in ipairs{...} do
      if (type(v) ~= "string") then
         local fn = myFileName()
         mcp:report("Syntax error in file: ",fn, " with command: ",
                   cmdName, " One or more arguments are not strings\n")
      end
   end
end

function validateArgsWithValue(cmdName, ...)
   local arg = { n = select('#', ...), ...}

   for i = 1, arg.n -1 do
      local v = arg[i]
      if (type(v) ~= "string") then
         local fn = myFileName()
         mcp:report("Syntax error in file: ",fn, " with command: ",
                   cmdName, " One or more arguments are not strings\n")
      end
   end

   local v = arg[arg.n]
   if (type(v) ~= "string" and type(v) ~= "number") then
      local fn = myFileName()
      mcp:report("Syntax error in file: ",fn, " with command: ",
                cmdName, " The last argument is  not string or number\n")
   end
end





--- Load family functions ----


function load(...)
   local dbg = Dbg:dbg()
   dbg.start("load(",concatTbl({...},", "),")")
   validateStringArgs("load",...)

   local b = mcp:load(...)
   dbg.fini()
   return b
end

function try_load(...)
   local dbg = Dbg:dbg()
   dbg.start("try_load(",concatTbl({...},", "),")")
   validateStringArgs("try_load",...)

   local b = mcp:try_load(...)
   dbg.fini()
   return b
end

try_add = try_load

function unload(...)
   local dbg = Dbg:dbg()
   dbg.start("unload(",concatTbl({...},", "),")")
   validateStringArgs("unload",...)

   local b = mcp:unload(...)
   dbg.fini()
   return b
end


function always_load(...)
   local dbg = Dbg:dbg()
   dbg.start("always_load(",concatTbl({...},", "),")")
   validateStringArgs("always_load",...)

   local b = mcp:always_load(...)
   dbg.fini()
   return b
end

function always_unload(...)
   local dbg = Dbg:dbg()
   dbg.start("always_unload(",concatTbl({...},", "),")")
   validateStringArgs("always_unload",...)

   local b = mcp:always_unload(...)
   dbg.fini()
   return b
end

--- PATH functions ---

function prepend_path(...)
   local dbg = Dbg:dbg()
   dbg.start("prepend_path(",concatTbl({...},", "),")")
   validateStringArgs("prepend_path",...)

   local b = mcp:prepend_path(...)
   dbg.fini()
   return b
end

function append_path(...)
   local dbg = Dbg:dbg()
   dbg.start("append_path(",concatTbl({...},", "),")")
   validateStringArgs("append_path",...)

   local b = mcp:append_path(...)
   dbg.fini()
   return b
end

function remove_path(...)
   local dbg = Dbg:dbg()
   dbg.start("remove_path(",concatTbl({...},", "),")")
   validateStringArgs("remove_path",...)

   local b = mcp:remove_path(...)
   dbg.fini()
   return b
end

--- SETENV functions ----

function setenv(...)
   local dbg = Dbg:dbg()
   dbg.start("setenv(",concatTbl({...},", "),")")
   validateArgsWithValue("setenv",...)

   local b = mcp:setenv(...)
   dbg.fini()
   return b
end

function unsetenv(...)
   local dbg = Dbg:dbg()
   dbg.start("unsetenv(",concatTbl({...},", "),")")
   validateStringArgs("unsetenv",...)

   local b = mcp:unsetenv(...)
   dbg.fini()
   return b
end

--- Property functions ----

function add_property(...)
   local dbg = Dbg:dbg()
   dbg.start("add_property(",concatTbl({...},", "),")")
   validateStringArgs("add_property",...)

   local b = mcp:add_property(...)
   dbg.fini()
   return b
end

function remove_property(...)
   local dbg = Dbg:dbg()
   dbg.start("remove_property(",concatTbl({...},", "),")")
   validateStringArgs("remove_property",...)

   local b = mcp:remove_property(...)
   dbg.fini()
   return b
end


--- Set Alias functions ---

function set_alias(...)
   local dbg = Dbg:dbg()
   dbg.start("set_alias(",concatTbl({...},", "),")")
   validateArgsWithValue("set_alias",...)

   local b = mcp:set_alias(...)
   dbg.fini()
   return b
end

function unset_alias(...)
   local dbg = Dbg:dbg()
   dbg.start("unset_alias(",concatTbl({...},", "),")")
   validateStringArgs("unset_alias",...)

   local b = mcp:unset_alias(...)
   dbg.fini()
   return b
end

--- Set Alias functions ---

function set_shell_function(...)
   local dbg = Dbg:dbg()
   dbg.start("set_shell_function(",concatTbl({...},", "),")")
   validateStringArgs("set_shell_function",...)

   local b = mcp:set_shell_function(...)
   dbg.fini()
   return b
end

function unset_shell_function(...)
   local dbg = Dbg:dbg()
   dbg.start("unset_shell_function(",concatTbl({...},", "),")")
   validateStringArgs("unset_shell_function",...)

   local b = mcp:unset_shell_function(...)
   dbg.fini()
   return b
end

--- Prereq / Conflict ---

function prereq(...)
   local dbg = Dbg:dbg()
   dbg.start("prereq(",concatTbl({...},", "),")")
   validateStringArgs("prereq",...)

   local b = mcp:prereq(...)
   dbg.fini()
   return b
end

function conflict(...)
   local dbg = Dbg:dbg()
   dbg.start("conflict(",concatTbl({...},", "),")")
   validateStringArgs("conflict",...)

   local b = mcp:conflict(...)
   dbg.fini()
   return b
end

function prereq_any(...)
   local dbg = Dbg:dbg()
   dbg.start("prereq_any(",concatTbl({...},", "),")")
   validateStringArgs("prereq_any",...)

   local b = mcp:prereq_any(...)
   dbg.fini()
   return b
end

--- Family function ---

function family(...)
   local dbg = Dbg:dbg()
   dbg.start("family(",concatTbl({...},", "),")")
   validateStringArgs("family",...)

   local b = mcp:family(...)
   dbg.fini()
   return b
end

--- Inherit function ---

function inherit(...)
   local dbg = Dbg:dbg()
   dbg.start("inherit(",concatTbl({...},", "),")")

   local b = mcp:inherit(...)
   dbg.fini()
   return b
end


-- Whatis / Help functions

function whatis(...)
   local dbg = Dbg:dbg()
   dbg.start("whatis(",concatTbl({...},", "),")")
   validateStringArgs("whatis",...)

   local b = mcp:whatis(...)
   dbg.fini()
   return b
end

function help(...)
   local dbg = Dbg:dbg()
   dbg.start("help(...)")
   validateStringArgs("help",...)
   local b = mcp:help(...)
   dbg.fini()
   return b
end

-- Misc --

function LmodError(...)
   local dbg = Dbg:dbg()
   --dbg.start("LmodError(",concatTbl({...},", "),")")

   local b = mcp:error(...)
   --dbg.fini()
   return b
end

function LmodWarning(...)
   local dbg = Dbg:dbg()
   --dbg.start("LmodWarning(",concatTbl({...},", "),")")

   local b = mcp:warning(...)
   --dbg.fini()
   return b
end

function LmodMessage(...)
   local dbg = Dbg:dbg()
   --dbg.start("LmodMessage(",concatTbl({...},", "),")")

   local b = mcp:message(...)
   --dbg.fini()
   return b
end

function is_spider()
   local dbg = Dbg:dbg()
   dbg.start("is_spider()")
   local b = mcp:is_spider()
   dbg.fini()
   return b
end

function mode()
   local dbg = Dbg:dbg()
   dbg.start("mode()")
   local b = mcp:mode()
   dbg.fini()
   return b
end

function isloaded(m)
   local mt = MT:mt()
   validateStringArgs("isloaded",m)
   return mt:have(m,"active")
end

function isPending(m)
   local mt = MT:mt()
   validateStringArgs("isPending",m)
   return mt:have(m,"pending")
end

function display(...)
   local dbg = Dbg:dbg()
   dbg.start("display(...)")
   local b = mcp:display(...)
   dbg.fini()
   return b
end

function myFileName()
   local mStack = ModuleStack:moduleStack()
   return mStack:fileName()
end

function hierarchyA(package, levels, numEntries)
   local dbg = Dbg:dbg()
   numEntries = numEntries or 2
   local fn  = myFileName():gsub("%.lua$","")

   -- Remove package from end of string by using the
   -- "plain" matching via string.find function
   package = package:gsub("%.lua$","")
   local i,j = fn:find(package,1,true)
   if (j == fn:len()) then
      fn = fn:sub(1,i-1)
   end

   -- remove any leading or trailing '/' or duplicate '/'
   fn       = fn:gsub("^/","")
   fn       = fn:gsub("/$","")
   fn       = fn:gsub("//+","/")
   local a = {}

   for dir in fn:split("/") do
      a[#a + 1] = dir
   end

   local b = {}
   local n = #a

   for i = 1, levels do
      local bb = {}
      for j = 1, numEntries do
         local idx = n - numEntries + j
         bb[j] = a[idx]
      end
      b[i] = concatTbl(bb,'/')
      n = n - numEntries
   end

   dbg.fini()
   return b
end

