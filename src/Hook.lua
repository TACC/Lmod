--------------------------------------------------------------------------
-- A way for client sites to register functions that are defined in
-- SitePackage.lua
-- @classmod Hook

require("strict")
--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2018 Robert McLay
--
--  Permission is hereby granted, free of charge, to any person obtaining
--  a copy of this software and associated documentation files (the
--  "Software"), to deal in the Software without restriction, including
--  without limitation the rights to use, copy, modify, merge, publish,
--  distribute, sublicense, and/or sell copies of the Software, and to
--  permit persons to whom the Software is furnished to do so, subject
--  to the following conditions:
--
--  The above copyright notice and this permission notice shall be
--  included in all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------


local M={}

local validT =
{
      ['load']             = {}, -- This load hook is called after a
                                 -- modulefile is loaded.
      unload               = {}, -- This unload hook is called after a
                                 -- modulefile is unloaded.
      parse_updateFn       = {}, -- This hook returns the time on the
                                 -- timestamp file.
      writeCache           = {}, -- This hook return whether a cache
                                 -- should be written.
      SiteName             = {}, -- Hook to specify Site Name
                                 -- It is used to generate family
                                 -- prefix:  site_FAMILY_
      msgHook              = {}, -- Hook to print messages after:
                                 -- avail, overview, list, spider,
      errWarnMsgHook       = {}, -- Hook to print messages after LmodError
                                 -- LmodWarning, LmodMessage
      groupName            = {}, -- This hook adds the arch and os name
                                 -- to moduleT.lua to make it safe on
                                 -- shared filesystems.
      avail                = {}, -- Map directory names to labels
      category             = {}, -- Hook to change output of category
      restore              = {}, -- This hook is run after restore operation
      startup              = {}, -- This hook is run when Lmod is called
      finalize             = {}, -- This hook is run just before Lmod generates its output before exiting
      packagebasename      = {}, -- Hook to find the patterns that spider uses for reverse map
      load_spider          = {}, -- This hook is run evaluating modules for spider/avail
      listHook             = {}, -- This hook gets the list of active modules
      isVisibleHook        = {}, -- Called to evalate if a module should be hidden or not
      isForbiddenHook      = {}, -- Called to evalate if a module should be forbidden or not
      spider_decoration    = {}, -- This hook adds decoration to spider level one output.
                                 -- It can be the category or a property.
      reverseMapPathFilter = {}, -- This hook returns two arrays keepA, ignoreA to keep or
                                 -- ignore a path in the reverseMap mapping
      colorize_fullName    = {}, -- Allow module avail and list to colorize name and/or version
      decorate_module      = {}, -- Allow dynamic additions to modules. The additions are still run through the sandbox. 
                                 -- It passes the following table as a parameter {path, name, version, contents}.
}

local s_actionT = { append = true, prepend = true, replace = true }

--------------------------------------------------------------------------
-- Checks for a valid hook name and stores it if valid.
-- @param name The name of the hook.
-- @param func The function to store with it.
-- @param action The kind of action.  This is an optional argument.
function M.register(name, func, action)
   if (validT[name] == nil) then
      LmodWarning{msg="w_Unknown_Hook",name = tostring(name)}
      return
   end

   -- set default for action to be backwards compatible
   if (action) then
      if (type(action) == "string") then
         action = action:lower()
      else
         action = "append"
      end
   else
      action = "replace"
   end

   -- Check for a valid action
   if (not s_actionT[action]) then
      LmodWarning{msg="w_Unknown_Hook_Action",action = tostring(action)}
   end

   -- Save func depending on action
   if (action == "replace") then
      validT[name] = {func}
   elseif (action == "append") then
      validT[name][#validT[name]+1] = func
   elseif (action == "prepend") then
      table.insert(validT[name],1,func)
   end
end

--------------------------------------------------------------------------
-- If a valid hook function has been registered then apply it.
-- @param name The name of the hook.
-- @return the results of the hook if it exists.
function M.apply(name, ...)
   if (next(validT[name]) ~= nil) then
      local sz = #validT[name]
      for i=1,sz-1 do
         validT[name][i](...)
      end
      return validT[name][sz](...)
   end
end

function M.exists(name)
   return (next(validT[name]) ~= nil) and true or false
end

return M
