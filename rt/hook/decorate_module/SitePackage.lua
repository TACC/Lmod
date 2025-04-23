local Hook = require("Hook")

function test_hook(t)
   if (t.name == "decorate") then
      return {"LmodMessage('I made it!')"}
   end
   return {}
end

Hook.register("decorate_module", test_hook, "append")

