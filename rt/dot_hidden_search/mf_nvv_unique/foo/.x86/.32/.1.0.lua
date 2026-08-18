-- IS849 Track B: unique all-dotted NVV
whatis("foo NVV all dotted segments")
local usrName, trueUsrName = myModuleUsrAndAliasName()
setenv("DH849_SLOT", "nvv_unique")
setenv("DH849_USR", usrName)
setenv("DH849_TRUE", trueUsrName)
