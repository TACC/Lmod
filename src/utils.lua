require("strict")
require("fileOps")
require("string_split")
local getenv = os.getenv

function prtErr(...)
   io.stderr:write(...)
end

function length(s)
   s = s:gsub("\027[^m]+m","")
   return s:len()
end

function UUIDString(epoch)
   local ymd  = os.date("*t", epoch)

   --                                y    m    d    h    m    s
   local uuid_date = string.format("%d_%02d_%02d_%02d_%02d_%02d", 
                                   ymd.year, ymd.month, ymd.day, 
                                   ymd.hour, ymd.min,   ymd.sec)
   
   local uuid_str  = capture("uuidgen"):sub(1,-2)
   local uuid      = uuid_date .. "-" .. uuid_str

   return uuid
end

function extractVersion(full, sn)
   if (full == nil or sn == nil) then
      return nil
   end
   local pat     = '^' .. escape(sn) .. '/?'
   local version = full:gsub(pat,"")
   if (version == "") then
      version = nil
   end
   return version
end

local __expert = false

function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
end

function activateWarning()
   s_haveWarnings = true
end

function deactivateWarning()
   s_haveWarnings = false
end

function haveWarnings()
   return s_haveWarnings
end

function setWarningFlag()
   s_warning = true
end
function getWarningFlag()
   return s_warning
end

local s_readRC     = false
RCFileA = {
   pathJoin(getenv("HOME"),".lmodrc.lua"),
   pathJoin(cmdDir(),"../../etc/.lmodrc.lua"),
   pathJoin(cmdDir(),"../init/.lmodrc.lua"),
   os.getenv("LMOD_RC"),
}

function readRC()
   if (s_readRC) then
      s_readRC = true
      return 
   end

   declare("propT",       false)
   declare("scDescriptT", false)
   local results = {}

   for i = 1,#RCFileA do
      local f  = RCFileA[i]
      local fh = io.open(f)
      if (fh) then
         assert(loadfile(f))()
         fh:close()
         break
      end
   end
   s_propT       = _G.propT         or {}
   s_scDescriptT = _G.scDescriptT   or {}
end

function getPropT()
   return s_propT
end

function getSCDescriptT()
   return s_scDescriptT
end


function readAdmin()

   -- If there is anything in [[adminT]] then return because
   -- this routine has already read in the file.
   if (next (adminT)) then return end

   local adminFn = getenv("LMOD_ADMIN_FILE") or pathJoin(cmdDir(),"../../etc/admin.list")
   local f       = io.open(adminFn,"r")

   -- Put something in adminT so that this routine will not be
   -- run again even if the file does not exist.
   adminT["foo"] = "bar"

   if (f) then
      local whole = f:read("*all") .. "\n"
      f:close()


      -- Parse file: ignore "#" comment lines and blank lines
      -- Split lines on ":" module:message

      local state = "init"
      local key   = "unknown"
      local value = nil
      local a     = {}

      for v in whole:split("\n") do

         if (v:sub(1,1) == "#") then
            -- ignore this comment line


         elseif (v:find("^%s*$")) then
            if (state == "value") then
               value       = concatTbl(a, " ")
               a           = {}
               adminT[key] = value
               state       = "init"
            end

            -- Ignore blank lines
         elseif (state == "value") then
            a[#a+1]     = v:trim()
         else
            local i     = v:find(":")
            if (i) then
               key      = v:sub(1,i-1):trim()
               local  s = v:sub(i+1):trim()
               if (s:len() > 0) then
                  a[#a+1]  = s
               end
               state    = "value"
            end
         end
      end
   end
end
