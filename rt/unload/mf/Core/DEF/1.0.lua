local dbg = require("Dbg"):dbg()
local D2_DIR=os.getenv("D2_DIR")
dbg.print{"DEF/1.0: D2_DIR: ",D2_DIR or "nil","\n"}
setenv("D2_DIR","FOO")
D2_DIR=os.getenv("D2_DIR")
dbg.print{"DEF/1.0: D2_DIR: ",D2_DIR or "nil","\n"}
setenv("D2_TEST",os.getenv("D2_DIR"))
depends_on("ACME")
setenv("DUMMY_TEST",os.getenv("ACME_DIR"))
