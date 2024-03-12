local hook = require("Hook")

require("test_hooks")

hook.register("load",load_hook_a,"prepend")
hook.register("load",load_hook_b,"prepend")



