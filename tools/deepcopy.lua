--[[ deepcopy.lua
    Deep-copy function for Lua - v0.2
    ==============================
      - Does not overflow the stack.
      - Maintains cyclic-references
      - Copies metatables
      - Maintains common upvalues between copied functions (for Lua 5.2 only)

    TODO
    ----
      - Document usage (properly) and provide examples
      - Implement handling of LuaJIT FFI ctypes
      - Provide option to only set metatables, not copy (as if they were
        immutable)
      - Find a way to replicate `debug.upvalueid` and `debug.upvaluejoin` in
        Lua 5.1
      - Copy function environments in Lua 5.1 and LuaJIT
        (Lua 5.2's _ENV is actually a good idea!)
      - Handle C functions

    Usage
    -----
        copy = table.deecopy(orig)
        copy = table.deecopy(orig, params, customcopyfunc_list)

    `params` is a table of parameters to inform the copy functions how to
    copy the data. The default ones available are:
      - `value_ignore` (`table`/`nil`): any keys in this table will not be
        copied (value should be `true`). (default: `nil`)
      - `value_translate` (`table`/`nil`): any keys in this table will result
        in the associated value, rather than a copy. (default: `nil`)
        (Note: this can be useful for global tables: {[math] = math, ..})
      - `metatable_immutable` (`boolean`): assume metatables are immutable and
        do not copy them (only set). (default: `false`)
      - `function_immutable` (`boolean`): do not copy function values; instead
        use the original value. (default: `false`)
      - `function_env` (`table`/`nil`): Set the enviroment of functions to
        this value (via fourth arg of `loadstring`). (default: `nil`)
        this value. (default: `nil`)
      - `function_upvalue_isolate` (`boolean`): do not join common upvalues of
        copied functions (only applicable for Lua 5.2 and LuaJIT). (default:
        `false`)
      - `function_upvalue_dontcopy` (`boolean`): do not copy upvalue values
        (does not stop joining). (default: `false`)

    `customcopyfunc_list` is a table of typenames to copy functions.
    For example, a simple solution for userdata:
    { ["userdata"] = function(stack, orig, copy, state, arg1, arg2)
        if state == nil then
            copy = orig
            local orig_uservalue = debug.getuservalue(orig)
            if orig_uservalue ~= nil then
                stack:recurse(orig_uservalue)
                return copy, 'uservalue'
            end
            return copy, true
        elseif state == 'uservalue' then
            local copy_uservalue = arg2
            if copy_uservalue ~= nil then
                debug.setuservalue(copy, copy_uservalue)
            end
            return copy, true
        end
    end }
    Any parameters passed to the `params` are available in `stack`.
    You can use custom paramter names, but keep in mind that numeric keys and
    string keys prefixed with a single underscore are reserved.

    License
    -------
    Copyright (C) 2012 Declan White

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.
]]
local function isDefined(name)
   return (rawget(_G, name) ~= nil)
end
local function declare(name, initval)
   rawset(_G, name, initval or false)
end

do
    declare("this_state")
    local type = isDefined("rawtype") or type
    local rawget = rawget
    local rawset = rawset
    local next = isDefined("rawnext") or next
    local getmetatable = debug and debug.getmetatable or getmetatable
    local setmetatable = debug and debug.setmetatable or setmetatable
    local debug_getupvalue = debug and debug.getupvalue or nil
    local debug_setupvalue = debug and debug.setupvalue or nil
    local debug_upvalueid = debug and debug.upvalueid or nil
    local debug_upvaluejoin = debug and debug.upvaluejoin or nil
    local load    = (_VERSION == "Lua 5.1") and loadstring or load
    local unpack  = (_VERSION == "Lua 5.1") and unpack or table.unpack
    local table   = table
    table.deepcopy_copyfunc_list = {
      --["type"] = function(stack, orig, copy, state, temp1, temp2, temp..., tempN)
      --
      --    -- When complete:
      --    state = true
      --
      --    -- Store temporary variables between iterations using these:
      --    -- (Note: you MUST NOT call these AFTER recurse)
      --    stack:_push(tempN+1, tempN+2, tempN+..., tempN+M)
      --    stack:_pop(K)
      --    -- K is the number to pop.
      --    -- If you wanted to pop two from the last state and push four new ones:
      --    stack:_pop(2)
      --    stack:_push('t', 'e', 's', 't')
      --
      --    -- To copy a child value:
      --    -- (Note: any calls to push or pop MUST be BEFORE a call to this)
      --    state:recurse(childvalue_orig)
      --    -- This will leave two temp variables on the stack for the next iteration
      --    -- .., childvalue_orig, childvalue_copy
      --    -- which are available via the varargs (temp...)
      --    -- (Note: the copy may be nil if it was not copied (because caller
      --    -- specified it not to be)).
      --    -- You can only call this once per iteration.
      --
      --    -- Return like this:
      --    -- (Temp variables are not part of the return list due to optimisation.)
      --    return copy, state
      --
      --end,
        _plainolddata = function(stack, orig, copy, state)
            return orig, true
        end,
        ["table"] = function(stack, orig, copy, state, arg1, arg2, arg3, arg4)
            local orig_prevkey, grabkey = nil, false
            if state == nil then -- 'init'
                -- Initial state, check for metatable, or get first key
                -- orig, copy:nil, state
                copy = stack[orig]
                if copy ~= nil then -- Check if already copied
                    return copy, true
                else
                    copy = {} -- Would be nice if you could preallocate sizes!
                    stack[orig] = copy
                    local orig_meta = getmetatable(orig)
                    if orig_meta ~= nil then -- This table has a metatable, copy it
                        if not stack.metatable_immutable then
                            stack:_recurse(orig_meta)
                            return copy, 'metatable'
                        else
                            setmetatable(copy, orig_meta)
                        end
                    end
                end
                -- No metatable, go straight to copying key-value pairs
                orig_prevkey = nil -- grab first key
                grabkey = true --goto grabkey
            elseif state == 'metatable' then
                -- Metatable has been copied, set it and get first key
                -- orig, copy:{}, state, metaorig, metacopy
                local copy_meta = arg2--select(2, ...)
                stack:_pop(2)

                if copy_meta ~= nil then
                    setmetatable(copy, copy_meta)
                end

                -- Now start copying key-value pairs
                orig_prevkey = nil -- grab first key
                grabkey = true --goto grabkey
            elseif state == 'key' then
                -- Key has been copied, now copy value
                -- orig, copy:{}, state, keyorig, keycopy
                local orig_key = arg1--select(1, ...)
                local copy_key = arg2--select(2, ...)

                if copy_key ~= nil then
                    -- leave keyorig and keycopy on the stack
                    local orig_value = rawget(orig, orig_key)
                    stack:_recurse(orig_value)
                    return copy, 'value'
                else -- key not copied? move onto next
                    stack:_pop(2) -- pop keyorig, keycopy
                    orig_prevkey = orig_key
                    grabkey = true--goto grabkey
                end
            elseif state == 'value' then
                -- Value has been copied, set it and get next key
                -- orig, copy:{}, state, keyorig, keycopy, valueorig, valuecopy
                local orig_key   = arg1--select(1, ...)
                local copy_key   = arg2--select(2, ...)
              --local orig_value = arg3--select(3, ...)
                local copy_value = arg4--select(4, ...)
                stack:_pop(4)

                if copy_value ~= nil then
                    rawset(copy, copy_key, copy_value)
                end

                -- Grab next key to copy
                orig_prevkey = orig_key
                grabkey = true --goto grabkey
            end
            --return
            --::grabkey::
            if grabkey then
                local orig_key, orig_value = next(orig, orig_prevkey)
                if orig_key ~= nil then
                    stack:_recurse(orig_key) -- Copy key
                    return copy, 'key'
                else
                    return copy, true -- Key is nil, copying of table is complete
                end
            end
            return
        end,
        ["function"] = function(stack, orig, copy, state, arg1, arg2, arg3)
            local grabupvalue, grabupvalue_idx = false, nil
            if state == nil then
                -- .., orig, copy, state
                copy = stack[orig]
                if copy ~= nil then
                    return copy, true
                elseif stack.function_immutable then
                    copy = orig
                    return copy, true
                else
                    copy = load(string.dump(orig), nil, nil, stack.function_env)
                    stack[orig] = copy

                    if debug_getupvalue ~= nil and debug_setupvalue ~= nil then
                        grabupvalue = true
                        grabupvalue_idx = 1
                    else
                        -- No way to get/set upvalues!
                        return copy, true
                    end
                end
            elseif this_state == 'upvalue' then
                -- .., orig, copy, state, uvidx, uvvalueorig, uvvaluecopy
                local orig_upvalue_idx   = arg1
              --local orig_upvalue_value = arg2
                local copy_upvalue_value = arg3
                stack:_pop(3)

                debug_setupvalue(copy, orig_upvalue_idx, copy_upvalue_value)

                grabupvalue_idx = orig_upvalue_idx+1
                stack:_push(grabupvalue_idx)
                grabupvalue = true
            end
            if grabupvalue then
                -- .., orig, copy, retto, state, uvidx
                local upvalue_idx_curr = grabupvalue_idx
                for upvalue_idx = upvalue_idx_curr, math.huge do
                    local upvalue_name, upvalue_value_orig = debug_getupvalue(orig, upvalue_idx)
                    if upvalue_name ~= nil then
                        local upvalue_handled = false
                        if not stack.function_upvalue_isolate and debug_upvalueid ~= nil and debug_upvaluejoin ~= nil then
                            local upvalue_uid = debug.upvalueid(orig, upvalue_idx)
                            -- Attempting to store an upvalueid of a function as a child of root is UB!
                            local other_orig = stack[upvalue_uid]
                            if other_orig ~= nil then
                                for other_upvalue_idx = 1, math.huge do
                                    if upvalue_uid == debug_upvalueid(other_orig, other_upvalue_idx) then
                                        local other_copy = stack[other_orig]
                                        debug_upvaluejoin(
                                            copy, upvalue_idx,
                                            other_copy, other_upvalue_idx
                                        )
                                        break
                                    end
                                end
                                upvalue_handled = true
                            else
                                stack[upvalue_uid] = orig
                            end
                        end
                        if not stack.function_upvalue_dontcopy and not upvalue_handled and upvalue_value_orig ~= nil then
                            stack:_recurse(upvalue_value_orig)
                            return copy, 'upvalue'
                        end
                    else
                        stack:_pop(1) -- pop uvidx
                        return copy, true
                    end
                end
            end
        end,
        ["userdata"] = nil,
        ["lightuserdata"] = nil,
        ["thread"] = nil,
    }
    table.deepcopy_copyfunc_list["number" ] = table.deepcopy_copyfunc_list._plainolddata
    table.deepcopy_copyfunc_list["string" ] = table.deepcopy_copyfunc_list._plainolddata
    table.deepcopy_copyfunc_list["boolean"] = table.deepcopy_copyfunc_list._plainolddata
    -- `nil` should never be encounted... but just in case:
    table.deepcopy_copyfunc_list["nil"    ] = table.deepcopy_copyfunc_list._plainolddata

    do
        local ORIG, COPY, RETTO, STATE, SIZE = 0, 1, 2, 3, 4
        function table.deepcopy_push(...)
            local arg_list_len = select('#', ...)
            local stack_offset = stack._top+1
            for arg_i = 1, arg_list_len do
                stack[stack_offset+arg_i] = select(arg_i, ...)
            end
            stack._top = stack_top+arg_list_len
        end
        function table.deepcopy_pop(stack, count)
            stack._top = stack._top-count
        end
        function table.deepcopy_recurse(stack, orig)
            local retto = stack._ptr
            local stack_top = stack._top
            local stack_ptr = stack_top+1
            stack._top = stack_top+SIZE
            stack._ptr = stack_ptr
            stack[stack_ptr+ORIG ] = orig
            stack[stack_ptr+COPY ] = nil
            stack[stack_ptr+RETTO] = retto
            stack[stack_ptr+STATE] = nil
        end
        function table.deepcopy(root, params, customcopyfunc_list)
            local stack = params or {}
            --orig,copy,retto,state,[temp...,] partorig,partcopy,partretoo,partstate
            stack[1+ORIG ] = root stack[1+COPY ] = nil
            stack[1+RETTO] = nil  stack[1+STATE] = nil
            stack._ptr = 1 stack._top = 4
            stack._push = table.deepcopy_push stack._pop = table.deepcopy_pop
            stack._recurse = table.deepcopy_recurse
            --[[local stack_dbg do -- debug
                stack_dbg = stack
                stack = setmetatable({}, {
                    __index = stack_dbg,
                    __newindex = function(t, k, v)
                        stack_dbg[k] = v
                        if tonumber(k) then
                            local stack = stack_dbg
                            local line_stack, line_label, line_stptr = "", "", ""
                            for stack_i = 1, math.max(stack._top, stack._ptr) do
                                local s_stack = (
                                        (type(stack[stack_i]) == 'table' or type(stack[stack_i]) == 'function')
                                            and string.gsub(tostring(stack[stack_i]), "^.-(%x%x%x%x%x%x%x%x)$", "<%1>")
                                    or  tostring(stack[stack_i])
                                ), type(stack[stack_i])
                                local s_label = ""--dbg_label_dict[stack_i] or "?!?"
                                local s_stptr = (stack_i == stack._ptr and "*" or "")..(stack_i == k and "^" or "")
                                local maxlen = math.max(#s_stack, #s_label, #s_stptr)+1
                                line_stack = line_stack..s_stack..string.rep(" ", maxlen-#s_stack)
                                --line_label = line_label..s_label..string.rep(" ", maxlen-#s_label)
                                line_stptr = line_stptr..s_stptr..string.rep(" ", maxlen-#s_stptr)
                            end
                            io.stdout:write(
                                          line_stack
                                --..  "\n"..line_label
                                ..  "\n"..line_stptr
                                ..  ""
                            )
                            io.read()
                        elseif false then
                            io.stdout:write(("stack.%s = %s"):format(
                                k,
                                (
                                        (type(v) == 'table' or type(v) == 'function')
                                            and string.gsub(tostring(v), "^.-(%x%x%x%x%x%x%x%x)$", "<%1>")
                                    or  tostring(v)
                                )
                            ))
                            io.read()
                        end
                    end,
                })
            end]]
            local copyfunc_list = table.deepcopy_copyfunc_list
            repeat
                local stack_ptr = stack._ptr
                local this_orig = stack[stack_ptr+ORIG]
                local this_copy, this_state
                stack[0] = stack[0]
                if stack.value_ignore and stack.value_ignore[this_orig] then
                    this_copy = nil
                    this_state = true --goto valuefound
                else
                    if stack.value_translate then
                        this_copy = stack.value_translate[this_orig]
                        if this_copy ~= nil then
                            this_state = true --goto valuefound
                        end
                    end
                    if not this_state then
                        local this_orig_type = type(this_orig)
                        local copyfunc = (
                                customcopyfunc_list and customcopyfunc_list[this_orig_type]
                            or  copyfunc_list[this_orig_type]
                            or  error(("cannot copy type %q"):format(this_orig_type), 2)
                        )
                        this_copy, this_state = copyfunc(
                            stack,
                            this_orig,
                            stack[stack_ptr+COPY],
                            unpack(stack--[[_dbg]], stack_ptr+STATE, stack._top)
                        )
                    end
                end
                stack[stack_ptr+COPY] = this_copy
                --::valuefound::
                if this_state == true then
                    local retto = stack[stack_ptr+RETTO]
                    stack._top = stack_ptr+1 -- pop retto, state, temp...
                    -- Leave orig and copy on stack for parent object
                    stack_ptr = retto -- return to parent's stack frame
                    stack._ptr = stack_ptr
                else
                    stack[stack_ptr+STATE] = this_state
                end
            until stack_ptr == nil
            return stack[1+COPY]
        end
    end
end
