std   = "max+busted"
color = false
unused = false
codes  = true
allow_defined = true
files["src/DirTree.lua"]                = {ignore = { "ModA" }}
files["src/MRC.lua"]                    = {ignore = { "ModA" }}
files["src/Spider.lua"]                 = {ignore = { "os","sn"}}
files["src/cmdfuncs.lua"]               = {ignore = { "prtHdr"}}
files["src/colorize.lua"]               = {ignore = { "colorize_kind"}}
files["src/myGlobals.lua"]              = {ignore = {"updateSystemFn", "GIT_VERSION", "epoch_type","prtHdr",
                                                     "ModuleName","ModuleFn","PkgLmod"}}
files["src/spider.in.lua"]              = {ignore = { "xml"}}
files["src/utils.lua"]                  = {ignore = { "__FILE__","__LINE__","epoch_type"}}
files["tools/fileOps.lua"]              = {ignore = {"isExec","dir_walk"}}
files["tools/string_utils.lua"]         = {ignore = { "122" }}
files["settarg/BuildTarget.lua"]        = {ignore = {"BuildScenarioTbl", "TitleTbl", "ModuleTbl", "TargetList",
                                                     "NoFamilyList","HostnameTbl","SettargDirTmpl","TargPathLoc"}} 
files["settarg/ProcessModuleTable.lua"] = {ignore = {"_ModuleTable_"}}
files["settarg/STT.lua"]                = {ignore = {"_SettargTable_"}}
files["settarg/settarg_rc.lua"]         = {ignore = {"BuildScenarioTbl", "TitleTbl", "ModuleTbl", "TargetList",
                                                     "NoFamilyList","HostnameTbl","SettargDirTmpl","TargPathLoc",
                                                     "SettargDirTemplate"}} 
files["settarg/STT.lua"]                = {ignore = {"_SettargTable_"}}
