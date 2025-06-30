local testDir = os.getenv("testDir")
local script  = pathJoin(testDir,"conda_foo.sh")
source_sh("bash",script)
