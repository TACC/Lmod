local pkg = Pkg:new{Category     = "base",
                    Keywords     = "base",
                    URL          = "http://acme.com",
                    Description  = "a module",
                    level        = 0,
                    help         = "help",
}
setenv("A_VERSION",pkg:pkgVersion())
