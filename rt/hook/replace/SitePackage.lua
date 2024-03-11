local hook = require("Hook")

require("test_hooks")

hook.register("load",load_hook_a,"replace")
hook.register("load",load_hook_b,"replace")



