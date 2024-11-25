local pkg = {}
pkg.name = myModuleName()
whatis("Name: " .. pkg.name)
set_shell_function("foo", "echo ok")
