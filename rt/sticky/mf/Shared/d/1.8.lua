local pkg = Pkg:new{Category     = "base",
                    Keywords     = "base",
                    URL          = "http://acme.com",
                    Description  = "d module",
                    level        = 0,
                    help         = "help",
}
setenv("D_VERSION",pkg:pkgVersion())
