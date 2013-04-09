require("sandbox")

function foo()
   setenv("FOO","1.0.0.1")
end

sandbox_registration{ foo = foo }
