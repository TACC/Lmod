local testDir = os.getenv("testDir")
local fn
local func
fn = pathJoin(testDir,"modulerc.d/001.lua")
func = loadfile(fn)
func()
fn = pathJoin(testDir,"modulerc.d/002.lua")
func = loadfile(fn)
func()
