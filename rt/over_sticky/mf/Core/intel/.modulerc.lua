if (os.getenv("RSNT_ARCH") == "avx512") then
   io.stderr:write("Marking intel/2018.3 as default\n")
   module_version("intel/2018.3","default")
else 
   io.stderr:write("Marking intel/2016.4 as default\n")
   module_version("intel/2016.4","default")
end

