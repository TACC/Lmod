std   = "max"
color = false
unused = false
codes  = true
allow_defined = true
--ignore = { "111", "112", "113"}
files["src/Spider.lua"]          = {ignore = { "122" }}
files["tools/string_utils.lua"]  = {ignore = { "122" }}
files["src/myGlobals.lua"]       = {ignore = {"defaultMpathA", "updateSystemFn", "GIT_VERSION", "PkgLmod",
                                              "accept_extT"}}
files["settarg/BuildTarget.lua"] = {ignore = {"BuildScenarioTbl", "TitleTbl", "ModuleTbl", "TargetList",
                                              "NoFamilyList","HostnameTbl","SettargDirTmpl","TargPathLoc"}} 
files["settarg/settarg_rc.lua"]  = {ignore = {"BuildScenarioTbl", "TitleTbl", "ModuleTbl", "TargetList",
                                              "NoFamilyList","HostnameTbl","SettargDirTmpl","TargPathLoc",
                                              "SettargDirTemplate"}} 
files["settarg/STT.lua"]         = {ignore = {"_SettargTable_"}}
files["tools/fileOps.lua"]       = {ignore = {"isExec"}}
files["tools/deepcopy.lua"]      = {ignore = {"113","112"}}
