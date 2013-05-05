require("strict")


local Dbg         = require("Dbg")
local MName       = require("MName")
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


function validateStringArgs(cmdName, ...)
   local dbg = Dbg:dbg()
   local arg = { n = select('#', ...), ...}
   dbg.print("cmd: ",cmdName, " arg.n: ",arg.n,"\n")
   for i = 1, arg.n do
      local v = arg[i]
      if (type(v) ~= "string") then
         local fn = myFileName()
         mcp:report("Syntax error in file: ",fn, "\n with command: ",
                   cmdName, " One or more arguments are not strings\n")
         return false
      end
   end
   return true
end

function validateArgsWithValue(cmdName, ...)
   local arg = { n = select('#', ...), ...}

   for i = 1, arg.n -1 do
      local v = arg[i]
      if (type(v) ~= "string") then
         local fn = myFileName()
         mcp:report("Syntax error in file: ",fn, " with command: ",
                   cmdName, " One or more arguments are not strings\n")
         return false
      end
   end

   local v = arg[arg.n]
   if (type(v) ~= "string" and type(v) ~= "number") then
      local fn = myFileName()
      mcp:report("Syntax error in file: ",fn, " with command: ",
                cmdName, " The last argument is  not string or number\n")
      return false
   end
   return true
end

--- Load family functions ----

function load(...)
   local dbg = Dbg:dbg()
   dbg.start("load(",concatTbl({...},", "),")")
   if (not validateStringArgs("load",...)) then return {} end

   local b = mcp:load(...)
   dbg.fini()
   return b
end

function try_load(...)
   local dbg = Dbg:dbg()
   dbg.start("try_load(",concatTbl({...},", "),")")
   if (not validateStringArgs("try_load",...)) then return {} end

   local b = mcp:try_load(...)
   dbg.fini()
   return b
end

try_add = try_load

function unload(...)
   local dbg = Dbg:dbg()
   dbg.start("unload(",concatTbl({...},", "),")")
   if (not validateStringArgs("unload",...)) then return {} end

   local b = mcp:unload(...)
   dbg.fini()
   return b
end


function always_load(...)
   local dbg = Dbg:dbg()
   dbg.start("always_load(",concatTbl({...},", "),")")
   if (not validateStringArgs("always_load",...)) then return {} end

   local b = mcp:always_load(...)
   dbg.fini()
   return b
end

function always_unload(...)
   local dbg = Dbg:dbg()
   dbg.start("always_unload(",concatTbl({...},", "),")")
   if (not validateStringArgs("always_unload",...)) then return {} end

   local b = mcp:always_unload(...)
   dbg.fini()
   return b
end

--- PATH functions ---

function prepend_path(...)
   local dbg = Dbg:dbg()
   dbg.start("prepend_path(",concatTbl({...},", "),")")
   if (not validateStringArgs("prepend_path",...)) then return end

   mcp:prepend_path(...)
   dbg.fini()
end

function append_path(...)
   local dbg = Dbg:dbg()
   dbg.start("append_path(",concatTbl({...},", "),")")
   if (not validateStringArgs("append_path",...)) then return end

   mcp:append_path(...)
   dbg.fini()
end

function remove_path(...)
   local dbg = Dbg:dbg()
   dbg.start("remove_path(",concatTbl({...},", "),")")
   if (not validateStringArgs("remove_path",...)) then return end

   mcp:remove_path(...)
   dbg.fini()
end

--- Set Environment functions ----

function setenv(...)
   local dbg = Dbg:dbg()
   dbg.start("setenv(",concatTbl({...},", "),")")
   if (not validateArgsWithValue("setenv",...)) then return end

   mcp:setenv(...)
   dbg.fini()
   return
end

function unsetenv(...)
   local dbg = Dbg:dbg()
   dbg.start("unsetenv(",concatTbl({...},", "),")")
   if (not validateStringArgs("unsetenv",...)) then return end

   mcp:unsetenv(...)
   dbg.fini()
   return
end

function pushenv(...)
   local dbg = Dbg:dbg()
   dbg.start("pushenv(",concatTbl({...},", "),")")
   if (not validateArgsWithValue("pushenv",...)) then return end

   mcp:pushenv(...)
   dbg.fini()
   return
end

--- Property functions ----

function add_property(...)
   local dbg = Dbg:dbg()
   dbg.start("add_property(",concatTbl({...},", "),")")
   if (not validateStringArgs("add_property",...)) then return end

   mcp:add_property(...)
   dbg.fini()
end

function remove_property(...)
   local dbg = Dbg:dbg()
   dbg.start("remove_property(",concatTbl({...},", "),")")
   if (not validateStringArgs("remove_property",...)) then return end

   mcp:remove_property(...)
   dbg.fini()
end


--- Set Alias/Shell functions ---

function set_alias(...)
   local dbg = Dbg:dbg()
   dbg.start("set_alias(",concatTbl({...},", "),")")
   if (not validateArgsWithValue("set_alias",...)) then return end

   mcp:set_alias(...)
   dbg.fini()
end

function unset_alias(...)
   local dbg = Dbg:dbg()
   dbg.start("unset_alias(",concatTbl({...},", "),")")
   if (not validateStringArgs("unset_alias",...)) then return end

   mcp:unset_alias(...)
   dbg.fini()
end

function set_shell_function(...)
   local dbg = Dbg:dbg()
   dbg.start("set_shell_function(",concatTbl({...},", "),")")
   if (not validateStringArgs("set_shell_function",...)) then return end

   mcp:set_shell_function(...)
   dbg.fini()
end

function unset_shell_function(...)
   local dbg = Dbg:dbg()
   dbg.start("unset_shell_function(",concatTbl({...},", "),")")
   if (not validateStringArgs("unset_shell_function",...)) then return end

   mcp:unset_shell_function(...)
   dbg.fini()
end

--- Prereq / Conflict ---

function prereq(...)
   local dbg = Dbg:dbg()
   dbg.start("prereq(",concatTbl({...},", "),")")
   if (not validateStringArgs("prereq",...)) then return end

   mcp:prereq(...)
   dbg.fini()
end

function conflict(...)
   local dbg = Dbg:dbg()
   dbg.start("conflict(",concatTbl({...},", "),")")
   if (not validateStringArgs("conflict",...)) then return end

   mcp:conflict(...)
   dbg.fini()
end

function prereq_any(...)
   local dbg = Dbg:dbg()
   dbg.start("prereq_any(",concatTbl({...},", "),")")
   if (not validateStringArgs("prereq_any",...)) then return end

   mcp:prereq_any(...)
   dbg.fini()
end

--- Family function ---

function family(...)
   local dbg = Dbg:dbg()
   dbg.start("family(",concatTbl({...},", "),")")
   if (not validateStringArgs("family",...)) then return end

   mcp:family(...)
   dbg.fini()
end

--- Inherit function ---

function inherit(...)
   local dbg = Dbg:dbg()
   dbg.start("inherit(",concatTbl({...},", "),")")

   mcp:inherit(...)
   dbg.fini()
end


-- Whatis / Help functions

function whatis(...)
   local dbg = Dbg:dbg()
   dbg.start("whatis(",concatTbl({...},", "),")")
   if (not validateStringArgs("whatis",...)) then return end

   mcp:whatis(...)
   dbg.fini()
end

function help(...)
   local dbg = Dbg:dbg()
   dbg.start("help(...)")
   if (not validateStringArgs("help",...)) then return end
   mcp:help(...)
   dbg.fini()
end

-- Misc --

function LmodError(...)
   local dbg = Dbg:dbg()
   local b = mcp:error(...)
   return b
end

function LmodWarning(...)
   local dbg = Dbg:dbg()
   local b = mcp:warning(...)
   return b
end

function LmodMessage(...)
   local dbg = Dbg:dbg()
   local b = mcp:message(...)
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
   if (not validateStringArgs("isloaded",m)) then return false end
   local mname = MName:new("mt", m)
   return mt:have(mname:sn(),"active")
end

function isPending(m)
   local mt = MT:mt()
   if (not validateStringArgs("isPending",m)) then return false end
   local mname = MName:new("mt", m)
   return mt:have(mname:sn(),"pending")
end

function myFileName()
   return mcp:myFileName()
end

function myModuleFullName()
   return mcp:myModuleFullName()
end

function myModuleName()
   return mcp:myModuleName()
end

function myModuleVersion()
   return mcp:myModuleVersion()
end

function hierarchyA(package, levels)
   local dbg = Dbg:dbg()
   local fn  = myFileName():gsub("%.lua$","")

   if (levels < 1) then
      return {}
   end

   -- Remove package from end of string by using the
   -- "plain" matching via string.find function
   package = path_regularize(package:gsub("%.lua$",""))
   local i,j = fn:find(package,1,true)
   if (j == fn:len()) then
      fn = fn:sub(1,i-1)
   end

   fn = path_regularize(fn)
   local j          = 0
   local numEntries = 0
   while (j) do
      j          = package:find("/",j+1)
      numEntries = numEntries + 1
   end

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

   return b
end
