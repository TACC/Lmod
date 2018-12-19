if os.getenv("RSNT_ARCH") == "avx512" then
	module_version("intel/2018.3","default")
else 
	module_version("intel/2016.4","default")
end

