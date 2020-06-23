--------------------------------------------------------------------------
-- Copyright 2016-2017 Ward Poelmans (wpoely86@gmail.com)
--------------------------------------------------------------------------

require("strict")
require("cmdfuncs")
require("utils")
require("lmod_system_execute")
require("parseVersion")

local Dbg   = require("Dbg")
local dbg   = Dbg:dbg()
local hook  = require("Hook")
local FrameStk  = require("FrameStk")


local function logmsg(logTbl)
    -- Print to syslog with generic header
    -- All the elements in the table logTbl are
    -- added in order. Expect format:
    -- logTbl[#logTbl+1] = {'log_key', 'log_value'}

    local jobid = os.getenv("PBS_JOBID") or "" -- for MOAB/PBS
    local user  = os.getenv("USER")
    local msg   = string.format("username=%s, jobid=%s", user, jobid)

    for _, val in ipairs(logTbl) do
        msg = msg .. string.format(", %s=%s", val[1], val[2] or "")
    end

    lmod_system_execute("logger -t lmod -p user.notice -- " .. msg)
end

local function load_hook(t)
    -- Called every time a module is loaded
    -- the arg t is a table:
    --     t.modFullName:  the module full name: (i.e: gcc/4.7.2)
    --     t.fn:           the file name: (i.e /apps/modulefiles/Core/gcc/4.7.2.lua)

    if (mode() ~= "load") then return end

    -- if userload is yes, the user request to load this module. Else
    -- it is getting loaded as a dependency.
    local frameStk = FrameStk:singleton()
    local userload = (frameStk:atTop()) and "yes" or "no"

    local logTbl      = {}
    logTbl[#logTbl+1] = {"userload", userload}
    logTbl[#logTbl+1] = {"module", t.modFullName}
    logTbl[#logTbl+1] = {"fn", t.fn}

    logmsg(logTbl)
end

local function startup_hook(usrCmd)
    -- This hook is called right after starting Lmod
    -- usrCmd holds the currect active command
    -- if you want access to all give arguments, use
    -- masterTbl
    dbg.start{"startup_hook"}

    local masterTbl = masterTbl()

    dbg.print{"Received usrCmd: ", usrCmd, "\n"}
    dbg.print{"masterTbl:", masterTbl, "\n"}

    -- Log how Lmod was called
    local fullargs    = table.concat(masterTbl.pargs, " ") or ""
    local logTbl      = {}
    logTbl[#logTbl+1] = {"cmd", usrCmd}
    logTbl[#logTbl+1] = {"args", fullargs}

    logmsg(logTbl)

    -- restore the original LD_LIBRARY_PATH and LD_PRELOAD
    -- The bash module/ml function renames both to ensure that
    -- lua (and thus Lmod) keep on working. We restore them
    -- once lua is started.
    local env_vars = {"LD_LIBRARY_PATH", "LD_PRELOAD"}

    for _, var in ipairs(env_vars) do
        local orig_val = os.getenv("ORIG_" .. var) or ""
        if orig_val ~= "" then
            dbg.print{"Setting ", var, " to ", orig_val, "\n"}
            posix.setenv(var, orig_val)
        end
    end

    dbg.fini()
end

local function msg_hook(mode, output)
    -- mode is avail, list and spider
    -- output is a table with the current output

    dbg.start{"msg_hook"}

    dbg.print{"Mode is ", mode, "\n"}

    if mode == "avail" then
        output[#output+1] = "\nIf you need software that is not listed, request it at the helpdesk.\n"
    end

    dbg.fini()

    return output
end

-- This gets called on every message, warning and error
local function errwarnmsg_hook(kind, key, msg, t)
    -- kind is either lmoderror, lmodwarning or lmodmessage
    -- msg is the actual message to display (as string)
    -- key is a unique key for the message (see messageT.lua)
    -- t is a table with the keys used in msg
    dbg.start{"errwarnmsg_hook"}

    dbg.print{"kind: ", kind," key: ",key,"\n"}
    dbg.print{"keys: ", t}

    if key == "e_No_AutoSwap" then
        -- Customize this error for EasyBuild modules
        -- When the users gets this error, it mostly likely means
        -- that they are trying to load modules belonging to different version of the same toolchain
        --
        -- find the module name causing the issue (almost always toolchain module)
        local sname = t.sn
        local frameStk = FrameStk:singleton()

        local errmsg = {"A different version of the '"..sname.."' module is already loaded (see output of 'ml')."}
        if not frameStk:empty() then
            local framesn = frameStk:sn()
            errmsg[#errmsg+1] = "You should load another '"..framesn.."' module for that is compatible with the currently loaded version of '"..sname.."'."
            errmsg[#errmsg+1] = "Use 'ml spider "..framesn.."' to get an overview of the available versions."
        end
        errmsg[#errmsg+1] = "\n"

        msg = table.concat(errmsg, "\n")
    end

    if kind == "lmoderror" or kind == "lmodwarning" then
        msg = msg .. "\nIf you don't understand the warning or error, contact the helpdesk at <email>"
    end

    -- log any errors users get
    if kind == "lmoderror" then
        local logTbl      = {}
        logTbl[#logTbl+1] = {"error", key}

        for tkey, tval in pairs(t) do
            logTbl[#logTbl+1] = {tkey, tval}
        end

        logmsg(logTbl)
    end

    dbg.fini()

    return msg
end


local function site_name_hook()
    -- set the SiteName, it must be a valid
    -- shell variable name.
    return "Something"
end


-- To combine EasyBuild with XALT
local function packagebasename(t)
    -- Use the EBROOT variables in the module
    -- as base dir for the reverse map
    t.patDir = "^EBROOT.*"
end


local function visible_hook(modT)
    -- modT is a table with: fullName, sn, fn and isVisible
    -- The latter is a boolean to determine if a module is visible or not

    dbg.start{"visible_hook"}

    dbg.print{"Received modT: ", modT, "\n"}

    -- EasyBuild example: if the intel or foss toolchain is older then 2 years, hide it.
    -- Lua patterns do not support "intel|foss"
    local tcver = modT.fullName:match("intel%-(20[0-9][0-9][ab])") or modT.fullName:match("foss%-(20[0-9][0-9][ab])")
    if tcver == nil then return end

    local cutoff = string.format("%da", os.date("%Y") - 2)
    if parseVersion(tcver) < parseVersion(cutoff) then
        modT.isVisible = false
    end

    dbg.fini()
end


local function get_avail_memory()
    -- If a limit is set at the point the module is loaded,
    -- return the maximum allowed memory, else nil

    -- look for the memory cgroup (if any)
    local cgroup = nil
    for line in io.lines("/proc/self/cgroup") do
        cgroup = line:match("^[0-9]+:memory:(.*)$")
        if cgroup then
            break
        end
    end

    if not cgroup then
        return nil
    end

    -- read of the current maximum allowed memory usage (memory + swap)
    local memory_file = io.open("/sys/fs/cgroup/memory/" .. cgroup .. "/memory.memsw.limit_in_bytes")

    if not memory_file then
        return nil
    end

    local memory_value = tonumber(memory_file:read())
    memory_file:close()

    -- if the value is 2^63-1 (rounded down to multiples of 4096), it's unlimited
    if memory_value == 9223372036854771712 then
        return nil
    end

    return memory_value
end


hook.register("load", load_hook)
hook.register("startup", startup_hook)
hook.register("msgHook", msg_hook)
hook.register("SiteName", site_name_hook)
hook.register("packagebasename", packagebasename)
hook.register("errWarnMsgHook", errwarnmsg_hook)
hook.register("isVisibleHook", visible_hook)

sandbox_registration{
    get_avail_memory = get_avail_memory,
}
