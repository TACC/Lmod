LmodMessage("5.0rc2: ",convertToCanonical("5.0rc2"),"\n")
LmodMessage("5.0:    ",convertToCanonical("5.0"),"\n")
LmodMessage("5.1:    ",convertToCanonical("5.1"),"\n")
LmodMessage("5.1.0:  ",convertToCanonical("5.1.0"),"\n")
LmodMessage("5.1.1:  ",convertToCanonical("5.1.1"),"\n")
if (convertToCanonical(LmodVersion()) > convertToCanonical("5.0")) then
   LmodMessage("(1) Passed Module Test\n")
end

if (convertToCanonical(LmodVersion()) < convertToCanonical("100000000000.0")) then
   LmodMessage("(2) Passed Module Test\n")
end

if (convertToCanonical(LmodVersion()) > convertToCanonical("100000000000.0")) then
   LmodMessage("(3) Failed Module Test\n")
   unknownFunc("A","b","C")
end

local nameA = {
   "LMOD_VERSION",
   "LMOD_VERSION_MAJOR",
   "LMOD_VERSION_MINOR",
   "LMOD_VERSION_SUBMINOR",
}

for i = 1,#nameA do
   local vstr = os.getenv(nameA[i])
   if (vstr) then
      LmodMessage("Lmod reports a ",nameA[i],"\n")
   end
end

