local testDir = os.getenv("testDir")
local script  = pathJoin(testDir,"broken.sh")
source_sh("bash",script)
