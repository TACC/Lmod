local testDir = os.getenv("testDir")
setenv("LMOD_MODULERC", pathJoin(testDir,"MRC","lmodRC.lua"))
depends_on("A")

