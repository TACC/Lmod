help(
[[
This module loads the Ray denovo assembler to your environment.
]])

add_property("type_","bio")
local version = "2.3.0"
local base = pathJoin("/software6/apps/ray/", "2.3.0_intel")

whatis("(Website________) http://denovoassembler.sourceforge.net/")

prepend_path("PATH", base)

