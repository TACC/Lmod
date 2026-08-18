-- IS849 Track B: dotted meta sibling
whatis("ACME meta dotted sibling")
local usrName, trueUsrName = myModuleUsrAndAliasName()
setenv("DH849_SLOT", "meta_exact_dotted")
setenv("DH849_USR", usrName)
setenv("DH849_TRUE", trueUsrName)
