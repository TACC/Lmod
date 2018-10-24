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
      ['load']        = false,  -- This load hook is called after a
                                -- modulefile is loaded.
      unload          = false,  -- This unload hook is called after a
                                -- modulefile is unloaded.
      parse_updateFn  = false,  -- This hook returns the time on the
                                -- timestamp file.
      writeCache      = false,  -- This hook return whether a cache
                                -- should be written.
      SiteName        = false,  -- Hook to specify Site Name
                                -- It is used to generate family
                                -- prefix:  site_FAMILY_
      msgHook         = false,  -- Hook to print messages after:
                                -- avail, list, spider, 
      errWarnMsgHook  = false,  -- Hook to print messages after LmodError
                                -- LmodWarning, LmodMessage
      groupName       = false,  -- This hook adds the arch and os name
                                -- to moduleT.lua to make it safe on
                                -- shared filesystems.
      avail           = false,  -- Map directory names to labels
      restore         = false,  -- This hook is run after restore operation
      startup         = false,  -- This hook is run when Lmod is called
      packagebasename = false,  -- Hook to find the patterns that spider uses for reverse map
      load_spider     = false,  -- This hook is run evaluating modules for spider/avail
      listHook        = false,  -- This hook gets the list of active modules
      isVisibleHook   = false,  -- Called to evalate if a module should be hidden or not
}

--------------------------------------------------------------------------
-- Checks for a valid hook name and stores it if valid.
-- @param name The name of the hook.
-- @param func The function to store with it.
function M.register(name, func)
   if (validT[name] ~= nil) then
      validT[name] = func
   else
      LmodWarning{msg="w_Unknown_Hook",name = tostring(name)}
   end

end

--------------------------------------------------------------------------
-- If a valid hook function has been registered then apply it.
-- @param name The name of the hook.
-- @return the results of the hook if it exists.
function M.apply(name, ...)
   if (validT[name]) then
      return validT[name](...)
   end
end

function M.exists(name)
   return validT[name] and true or false
end

return M
