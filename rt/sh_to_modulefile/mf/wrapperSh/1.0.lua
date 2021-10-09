local testDir = os.getenv("testDir")
local script  = pathJoin(testDir,"tstScript.sh")
source_sh("bash",script)
