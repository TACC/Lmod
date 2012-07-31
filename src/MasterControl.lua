-- MasterControl
require("strict")
require("inherits")

local M            = {}
local BeautifulTbl = require("BeautifulTbl")
local Dbg          = require("Dbg")
local ModuleStack  = require("ModuleStack")
local Var          = require("Var")
local concatTbl    = table.concat
local format       = string.format
local getenv       = os.getenv
local print	   = print
local setmetatable = setmetatable
local type	   = type

------------------------------------------------------------------------
--module ('MasterControl')
------------------------------------------------------------------------

function M.name(self)
   return self.my_name
end


local function valid_name(nameTbl, name)
   if (not nameTbl[name]) then
      return nameTbl.default
   end
   return nameTbl[name]
end

function M.build(name)

   local nameTbl          = {}
   local MCLoad           = require('MC_Load')
   local MCUnload         = require('MC_Unload')
   local MCShow           = require('MC_Show')
   local MCAccess         = require('MC_Access')
   local MCSpider         = require('MC_Spider')
   local MCComputeHash    = require('MC_ComputeHash')
   nameTbl["load"]        = MCLoad
   nameTbl["unload"]      = MCUnload
   nameTbl["show"]        = MCShow
   nameTbl["access"]      = MCAccess
   nameTbl["spider"]      = MCSpider
   nameTbl["computeHash"] = MCComputeHash
   nameTbl.default        = MCLoad

   return valid_name(nameTbl, name):create()
end

-------------------------------------------------------------------
-- Load / Unload functions
-------------------------------------------------------------------

function M.load(self, ...)
   local master = Master:master()
   local dbg    = Dbg:dbg()
   local mStack = ModuleStack:moduleStack()

   dbg.start("MasterControl:load(",concatTbl({...},", "),")")
   mStack:loading()

   local a = master.load(...)

   if (not expert()) then

      local mt      = MT:mt()
      local t       = {}
      readAdmin()
      for _, moduleName in ipairs{...} do
         local moduleFn  = mt:fileNameActive(moduleName)
         local modFullNm = mt:modFullNameActive(moduleName)
         local message
         local key
         if (adminT[moduleFn]) then
            message = adminT[moduleFn]
            key     = moduleFn
         elseif (adminT[modFullNm]) then
            message = adminT[modFullNm]
            key     = modFullNm
         end

         if (message) then
            t[key] = message
         end
      end

      if (next(t)) then
         local term_width  = tonumber(capture("tput cols") or "80")
         if (term_width < 40) then
            term_width = 80
         end
         local bt
         local a       = {}
         local border  = string.rep("-", term_width-1)
         io.stderr:write("\n",border,"\n","Module(s):\n",border,"\n")
         for k, v in pairs(t) do
            io.stderr:write("\n",k," :\n")
            a[1] = { " ", v}
            bt = BeautifulTbl:new{tbl=a, wrapped=true, column=term_width-1,prt=prtErr}
            bt:printTbl()
            io.stderr:write("\n")
         end
         io.stderr:write(border,"\n\n")
      end
   end

   dbg.fini()
   return a
end

function M.try_load(self, ...)
   local dbg = Dbg:dbg()
   dbg.start("MasterControl:try_load(",concatTbl({...},", "),")")
   dbg:deactivateWarning()
   self:load(...)
   dbg.fini()
end

function M.unload(self, ...)
   local master = Master:master()
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()
   dbg.start("MasterControl:unload(", concatTbl({...},", "),")")

   for _,v in ipairs{...} do
      if (mt:haveModuleAnyTotal(v)) then
         mt:removeTotal(v)
      end
   end
   mStack:loading()

   local aa     = master.unload(...)

   dbg.fini()
   return aa
end

   
function M.unloadsys(self, ...)
   local master = Master:master()
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()
   local a      = {}

   dbg.start("MasterControl.unloadsys(",concatTbl({...},", "),")")
   mStack:loading()

   a      = master.unload(...)
   dbg.fini()
   return a
end

function M.bad_unload(self,...)
   local dbg = Dbg:dbg()
   local a   = {}

   dbg.start("MasterControl.bad_unload()")

   dbg.warning("Stubbornly refusing to unload module(s): \"",
               concatTbl({...},"\", \""),"\"",
               "\n   during an unload\n")

   dbg.fini()
end


-------------------------------------------------------------------
-- Path Modification Functions
-------------------------------------------------------------------

function M.prepend_path(self, name, value, sep)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:prepend_path(\"",name,"\", \"",value,"\",\"",tostring(sep),"\")")
   sep          = sep or ":"

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name, nil, sep)
   end

   varTbl[name]:prepend(value)
   mStack:setting()
   dbg.fini()
end

function M.append_path(self, name,value,sep)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:append_path(\"",name,"\", \"",value,"\",\"",tostring(sep),"\")")
   sep          = sep or ":"

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name, nil, sep)
   end
   varTbl[name]:append(value)
   mStack:setting()
   dbg.fini()
end

function M.remove_path(self, name, value, sep)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:remove_path(\"",name,"\", \"",value,"\",\"",tostring(sep),"\")")
   sep          = sep or ":"
   mStack:setting()

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name,nil, sep)
   end
   varTbl[name]:remove(value)
   dbg.fini()
end


function M.bad_remove_path(self, name,value)
   Dbg:dbg().warning("Refusing remove a path element variable while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Setenv / Unsetenv Functions
-------------------------------------------------------------------

function M.setenv(self, name, value)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:setenv(\"",name,"\", \"",value,"\")")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:set(value)
   mStack:setting()
   dbg.fini()
end

function M.unsetenv(self, name, value)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:unsetenv(\"",name,"\", \"",value,"\")")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unset()
   mStack:setting()
   dbg.fini()
end

function M.bad_unsetenv(self, name, value)
   Dbg:dbg().warning("Refusing unsetenv variable while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Alias Functions
-------------------------------------------------------------------

function M.set_alias(self, name, value)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:set_alias(\"",name,"\", \"",value,"\")")


   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:setAlias(value)
   mStack:setting()
   dbg.fini()
end

function M.unset_alias(self, name, value)
   local mStack = ModuleStack:moduleStack()
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:unset_alias(\"",name,"\", \"",value,"\")")

   if (varTbl[name] == nil) then
      varTbl[name] = Var:new(name)
   end
   varTbl[name]:unsetAlias(value)
   mStack:setting()
   dbg.fini()
end

function M.bad_unset_alias(self, name)
   Dbg:dbg().warning("Refusing unset an alias while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Property Functions
-------------------------------------------------------------------

function M.add_property(self, name, value)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:add_property(\"",name,"\", \"",value,"\")")
   dbg.fini()
end

function M.remove_property(self, name, value)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:remove_property(\"",name,"\", \"",value,"\")")
   dbg.fini()
end

function M.bad_remove_property(self, name, value)
   Dbg:dbg().warning("Refusing to remove a property while unloading: \"",name,"\"\n")
end

-------------------------------------------------------------------
-- Message/Error  Functions
-------------------------------------------------------------------

function lmodErrorExit()
   io.stdout:write("false\n")
   os.exit(1)
end

function LmodSystemError(...)
   io.stderr:write("\nError: ")
   for _,v in ipairs{...} do
      io.stderr:write(v)
   end
   io.stderr:write("\n")
   lmodErrorExit()
end   


function M.error(self, ...)
   LmodSystemError(...)
end

function M.message(self, ...)
   for _,v in ipairs{...} do
      io.stderr:write(v)
   end
   io.stderr:write("\n")
end


-------------------------------------------------------------------
-- Misc Functions
-------------------------------------------------------------------

function M.prereq(self, ...)
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()
   local a      = {}
   local mStack = ModuleStack:moduleStack()
   local mName  = mStack:moduleName()

   dbg.start("MasterControl:prereq(",concatTbl({...},", "),")")

   for _,v in ipairs{...} do
      if (not mt:haveModuleActive(v)) then
         a[#a+1] = v
      end
   end
   dbg.print("number found: ",#a,"\n")
   if (#a > 0) then
      local s = concatTbl(a," ")
      LmodError("Can not load: \"",mName,"\" module without these modules loaded:\n  ",
            s,"\n")
   end
   dbg.fini()
end

function M.conflict(self, ...)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:conflict(",concatTbl({...},", "),")")


   local mt     = MT:mt()
   local a      = {}
   local mStack = ModuleStack:moduleStack()
   local mName  = mStack:moduleName()
   for _,v in ipairs{...} do
      if (mt:haveModuleActive(v)) then
         a[#a+1] = v
      end
   end
   if (#a > 0) then
      local s = concatTbl(a," ")
      LmodError("Can not load: \"",mName,"\" module because these modules are loaded:\n  ",
            s,"\n")
   end
   dbg.fini()
end

function M.family(self, name)
   local dbg                    = Dbg:dbg()
   local mt                     = MT:mt()
   local mStack                 = ModuleStack:moduleStack()
   local mName                  = mStack:moduleName()
   local _, _, baseName,version = mName:find("([^/]*)/?(.*)")

   dbg.start("MasterControl:family(",name,")")
   dbg.print("mt:setfamily(\"",name,"\",\"",baseName,"\")\n")
   local oldName = mt:setfamily(name,baseName)
   if (oldName ~= nil and oldName ~= mName and not expert() ) then
      LmodError("You can only have one ",name," module loaded at time.\n",
                "You already have ", oldName," loaded.\n",
                "To correct the situation, please enter the following command:\n\n",
                "  module swap ",oldName, " ", mName,"\n\n",
                "Please submit a consulting ticket if you require additional assistance.\n")
   end
   dbg.fini()
end

function M.unset_family(self, name)
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()

   dbg.start("MasterControl:unset_family(",name,")")
   dbg.print("mt:unsetfamily(\"",name,"\")\n")
   mt:unsetfamily(name)
   dbg.fini()
end

function M.inherit(self)
   local dbg    = Dbg:dbg()
   local master = Master:master()
   dbg.start("MasterControl:inherit()")
   master.inheritModule()
   dbg.fini()
end

function M.is_spider(self)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:is_spider()")
   dbg.fini()
   return false
end

function M.mode_load(self)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:mode_load()")
   dbg.fini()
   return "load"
end   

function M.mode_unload(self)
   local dbg    = Dbg:dbg()
   dbg.start("MasterControl:mode_unload()")
   dbg.fini()
   return "unload"
end   


-------------------------------------------------------------------
-- Quiet Functions
-------------------------------------------------------------------


function M.quiet(self, ...)
   -- very Quiet !!!
end

M.display = M.quiet

return M
