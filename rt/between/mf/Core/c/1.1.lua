local pkg = Pkg:new{Category     = "base",
                    Keywords     = "base",
                    URL          = "http://acme.com",
                    Description  = "C module",
                    level        = 0,
                    help         = "help",
}
setenv("C_VERSION",pkg:pkgVersion())
