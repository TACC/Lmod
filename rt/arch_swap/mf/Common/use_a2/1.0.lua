if (mode() == "load") then
   local mpath = os.getenv("MODULEPATH")
   mpath = mpath:gsub("/a1/","/a2/")
   io.stderr:write("MPATH: ",mpath,"\n")
   pushenv("MODULEPATH",mpath)
end
