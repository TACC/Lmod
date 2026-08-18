-- IS849 Track B: unique meta with dotted short name
whatis("ACME meta dotted short name")
local usrName, trueUsrName = myModuleUsrAndAliasName()
setenv("DH849_SLOT", "meta_unique")
setenv("DH849_USR", usrName)
setenv("DH849_TRUE", trueUsrName)
