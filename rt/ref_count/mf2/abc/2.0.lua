-- check for node type here and set nodeType variable accordingly

local nodeType = os.getenv("NODE_TYPE") or "cpu"

if (nodeType == "cpu") then load("abc/.cpu/2.0") end
if (nodeType == "gpu") then load("abc/.gpu/2.0") end

whatis("Name : ABC")
whatis("Version : 2.0")
whatis("Short description : Blah blah blah.")
help([[Blah blah blah.]])
