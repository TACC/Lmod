local mroot       = os.getenv("MODULEPATH_ROOT")
local mp_loop     = os.getenv("MODULEPATH_LOOP")

if (mp_loop) then
   prepend_path("MODULEPATH", pathJoin(mroot,"2Core"))
end

