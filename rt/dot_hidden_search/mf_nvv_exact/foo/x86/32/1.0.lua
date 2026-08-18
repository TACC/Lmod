-- IS849 Track B: exact undotted NVV wins over dotted sibling
whatis("foo NVV exact undotted")
local usrName, trueUsrName = myModuleUsrAndAliasName()
setenv("DH849_SLOT", "nvv_exact_undotted")
setenv("DH849_USR", usrName)
setenv("DH849_TRUE", trueUsrName)
