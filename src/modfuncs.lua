require("strict")


local Dbg = require("Dbg")

--- Load family functions ----


function load(...)
   local dbg = Dbg:dbg()
   dbg.start("load(",concatTbl({...},", "),")")

   local b = mcp:load(...)
   dbg.fini()
   return b
end

function try_load(...)
   local dbg = Dbg:dbg()
   dbg.start("try_load(",concatTbl({...},", "),")")

   local b = mcp:try_load(...)
   dbg.fini()
   return b
end

try_add = try_load

function unload(...)
   local dbg = Dbg:dbg()
   dbg.start("unload(",concatTbl({...},", "),")")

   local b = mcp:unload(...)
   dbg.fini()
   return b
end


--- PATH functions ---

function prepend_path(...)
   local dbg = Dbg:dbg()
   dbg.start("prepend_path(",concatTbl({...},", "),")")

   local b = mcp:prepend_path(...)
   dbg.fini()
   return b
end

function append_path(...)
   local dbg = Dbg:dbg()
   dbg.start("append_path(",concatTbl({...},", "),")")

   local b = mcp:append_path(...)
   dbg.fini()
   return b
end

function remove_path(...)
   local dbg = Dbg:dbg()
   dbg.start("remove_path(",concatTbl({...},", "),")")

   local b = mcp:remove_path(...)
   dbg.fini()
   return b
end

--- SETENV functions ----

function setenv(...)
   local dbg = Dbg:dbg()
   dbg.start("setenv(",concatTbl({...},", "),")")

   local b = mcp:setenv(...)
   dbg.fini()
   return b
end

function unsetenv(...)
   local dbg = Dbg:dbg()
   dbg.start("unsetenv(",concatTbl({...},", "),")")

   local b = mcp:unsetenv(...)
   dbg.fini()
   return b
end

--- Set Alias functions ---

function set_alias(...)
   local dbg = Dbg:dbg()
   dbg.start("set_alias(",concatTbl({...},", "),")")

   local b = mcp:set_alias(...)
   dbg.fini()
   return b
end

function unset_alias(...)
   local dbg = Dbg:dbg()
   dbg.start("unset_alias(",concatTbl({...},", "),")")

   local b = mcp:unset_alias(...)
   dbg.fini()
   return b
end

--- Prereq / Conflict ---

function prereq(...)
   local dbg = Dbg:dbg()
   dbg.start("prereq(",concatTbl({...},", "),")")

   local b = mcp:prereq(...)
   dbg.fini()
   return b
end

function conflict(...)
   local dbg = Dbg:dbg()
   dbg.start("conflict(",concatTbl({...},", "),")")

   local b = mcp:conflict(...)
   dbg.fini()
   return b
end

--- Family function ---

function family(...)
   local dbg = Dbg:dbg()
   dbg.start("family(",concatTbl({...},", "),")")

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

   local b = mcp:whatis(...)
   dbg.fini()
   return b
end

function help(...)
   local dbg = Dbg:dbg()
   dbg.start("help(",concatTbl({...},", "),")")

   local b = mcp:help(...)
   dbg.fini()
   return b
end

-- Misc --

function LmodError(...)
   local dbg = Dbg:dbg()
   dbg.start("LmodError(",concatTbl({...},", "),")")

   local b = mcp:error(...)
   dbg.fini()
   return b
end

function LmodMessage(...)
   local dbg = Dbg:dbg()
   dbg.start("LmodMessage(",concatTbl({...},", "),")")

   local b = mcp:message(...)
   dbg.fini()
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
   return mt:haveModuleActive(m)
end

