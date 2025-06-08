local pkg = {}
pkg.name    = myModuleName()
pkg.version = myModuleVersion()

whatis("Name:        " .. pkg.name)
whatis("Version:     " .. pkg.version)
whatis("Category:    " .. "test_cat")
whatis("URL:         " .. "http:/test")
