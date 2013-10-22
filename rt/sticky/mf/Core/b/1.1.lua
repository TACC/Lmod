local pkg = Pkg:new{Category     = "base",
                    Keywords     = "base",
                    URL          = "http://acme.com",
                    Description  = "b module",
                    level        = 0,
                    help         = "help",
}
setenv("B_VERSION",pkg:pkgVersion())
