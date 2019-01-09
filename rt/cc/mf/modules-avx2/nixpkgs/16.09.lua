local arch = os.getenv("RSNT_ARCH") or ""
local mroot = os.getenv("MODULEPATH_ROOT")

prepend_path("MODULEPATH", pathJoin(mroot,"Core-" .. arch))


