local v = nil

io.stderr:write("BAD/1.0 v: ", tostring(v),"\n")


if tonumber(v) > 22  then
    pushenv("FOO", "bar")
end

whatis("Name:        " .. "bad")
whatis("Version:     " .. myModuleVersion())
whatis("Category:    " .. "test_cat")
whatis("URL:         " .. "http:/bad")
