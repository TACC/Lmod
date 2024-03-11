function load_hook_a(t)
    local frameStk  = require("FrameStk"):singleton()
    local mt        = frameStk:mt()
    local simpleName = string.match(t.modFullName, "(.-)/")
    LmodMessage("Load hook A called on " .. simpleName)
end

function load_hook_b(t)
    local frameStk  = require("FrameStk"):singleton()
    local mt        = frameStk:mt()
    local simpleName = string.match(t.modFullName, "(.-)/")
    LmodMessage("Load hook B called on " .. simpleName)
end
