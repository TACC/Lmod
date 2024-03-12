local hook = require("Hook")

require("test_hooks")

hook.register("load",load_hook_a,"append")
hook.register("load",load_hook_b,"append")



