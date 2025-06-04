local pkg = {}
pkg.name    = myModuleName()
pkg.version = myModuleVersion()

if tonumber(pkg.version) > 22  then
    pushenv("FOO", "bar")
end

whatis("Name:        " .. pkg.name)
whatis("Version:     " .. pkg.version)
whatis("Category:    " .. "test_cat")
whatis("URL:         " .. "http:/test")
