help([==[
Description: CubeWriter
]==])
whatis([==[Description: CubeWriter]==])

local root = "/fake/CubeWriter/4.8.2-GCCcore-13.3.0"
conflict("CubeWriter")
prepend_path("PATH", pathJoin(root, "bin"))
setenv("EBROOTCUBEWRITER", root)
