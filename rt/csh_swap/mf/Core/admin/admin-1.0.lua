-- -*- lua -*-
setenv("ADMIN_MODULE_LOADED","1")
prepend_path('PATH','/usr/sbin/://sbin///')
setenv("FOO","aa,bb$bb,$cc,dd plus spaces")
setenv("BAR","ab?c")
setenv("BAZ","ab-c")
setenv("GZ","a[b-c]")
