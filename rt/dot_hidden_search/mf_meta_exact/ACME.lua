-- IS849 Track B: exact undotted meta wins
whatis("ACME meta exact undotted")
local usrName, trueUsrName = myModuleUsrAndAliasName()
setenv("DH849_SLOT", "meta_exact_undotted")
setenv("DH849_USR", usrName)
setenv("DH849_TRUE", trueUsrName)
