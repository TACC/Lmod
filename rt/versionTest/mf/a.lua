LmodMessage("5.0rc2:   ",convertToCanonical("5.0rc2"))
LmodMessage("5.0:      ",convertToCanonical("5.0"))
LmodMessage("5.1:      ",convertToCanonical("5.1"))
LmodMessage("5.1.0:    ",convertToCanonical("5.1.0"))
LmodMessage("5.1.1:    ",convertToCanonical("5.1.1"))
LmodMessage("default:  ",convertToCanonical("default"))

local result = (convertToCanonical("default") < convertToCanonical("5.1.1"))
LmodMessage("\"default\" < \"5.1.1\" is ", tostring(result))


if (convertToCanonical(LmodVersion()) > convertToCanonical("0.5")) then
   LmodMessage("(1) Passed Module Test")
end

if (convertToCanonical(LmodVersion()) < convertToCanonical("100000000000.0")) then
   LmodMessage("(2) Passed Module Test")
end

if (convertToCanonical(LmodVersion()) > convertToCanonical("100000000000.0")) then
   LmodMessage("(3) Failed Module Test")
   unknownFunc("A","b","C")
end

local nameA = {
   "LMOD_VERSION",
   "LMOD_VERSION_MAJOR",
   "LMOD_VERSION_MINOR",
   "LMOD_VERSION_SUBMINOR",
   "ModuleTool",
   "ModuleToolVersion",
}

for i = 1,#nameA do
   local vstr = os.getenv(nameA[i])
   if (vstr) then
      LmodMessage("Lmod reports a ",nameA[i])
   end
end

for i = 1,#nameA do
   local vstr = os.getenv(nameA[i])
   if (vstr) then
      LmodMessage("-%%- ",nameA[i],": ",vstr)
   end
end
