_G._DEBUG       = false
local posix     = require("posix")

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

require("declare")
require("utils")
local M         = {}
local MRC       = require("MRC")
local dbg       = require("Dbg"):dbg()
local lfs       = require("lfs")
local open      = io.open

local access    = posix.access
local concatTbl = table.concat
local readlink  = posix.readlink
local stat      = posix.stat
local user_uid  = 0
local getuid    = posix.getuid
if (getuid) then
   user_uid = getuid()
end

local load      = (_VERSION == "Lua 5.1") and loadstring or load

local ignoreT = {
   ['.']          = true,
   ['..']         = true,
   ['.git']       = true,
   ['.gitignore'] = true,
   ['.svn']       = true,
   ['.lua']       = true,
   ['.DS_Store']  = true,
}

local defaultFnT = {
   default           = 1,
   ['.modulerc.lua'] = 2,
   ['.modulerc']     = 3,
   ['.version']      = 4,
}

local function keepFile(fn)
   local firstChar = fn:sub(1,1)
   local lastChar  = fn:sub(-1,-1)
   local firstTwo  = fn:sub(1,2)

   local result    = not (ignoreT[fn]     or lastChar == '~' or firstChar == '#' or
                          lastChar == '#' or firstTwo == '.#' or firstTwo == '__')
   if (not result) then
      return false
   end

   if (firstChar == "." and fn:sub(-4,-1) == ".swp") then
      return false
   end

   if (defaultFnT[fn]) then
      return true
   end

   return true
end

local function checkValidModulefileReal(fn)
   local f = open(fn,"r")
   if (not f) then
      return false
   end
   local line = f:read(20) or ""
   f:close()

   return line:find("^#%%Module")
end

local function checkValidModulefileFake(fn)
   return true
end

local checkValidModulefile = checkValidModulefileReal

--------------------------------------------------------------------------
-- Use readlink to find the link
-- @param path the path to the module file.
local function walk_link(path)
   local attr   = lfs.symlinkattributes(path)
   if (attr == nil) then
      return nil
   end

   if (attr.mode == "link") then
      local rl = readlink(path)
      if (not rl) then
         return nil
      end
      return pathJoin(dirname(path),rl)
   end
   return path
end

--------------------------------------------------------------------------
-- This routine is given the absolute path to a .version
-- file.  It checks to make sure that it is a valid TCL
-- file.  It then uses the ModulesVersion.tcl script to
-- @param defaultT - A table containing: { fullName=, fn=, mpath=, luaExt=, barefn=}

-- return what the value of "ModulesVersion" is.
local function versionFile(mrc, defaultT)
   local path = defaultT.fn

   if (defaultT.barefn == "default") then
      defaultT.value = barefilename(walk_link(defaultT.fn)):gsub("%.lua$","")
      return defaultT
   end

   local luaExt = path:find("%.lua$")

   if (not luaExt and not checkValidModulefile(path)) then
      return defaultT
   end

   local modA = mrc_load(path)
   local _, _, name = defaultT.fullName:find("(.*)/.*")

   dbg.print{"In versionFile\n"}

   defaultT.value = mrc:parseModA_for_moduleA(name,modA)

   dbg.print{"Back in versionFile\n"}

   return defaultT
end


local function walk(mrc, mpath, path, dirA, fileT)
   local defaultIdx = 1000000
   local defaultT   = {}
   local permissions
   local uid
   local kind

   local attr       = lfs.attributes(path)
   if (not attr or type(attr) ~= "table" or attr.mode ~= "directory" or
       not access(path,"x")) then
      return defaultT
   end


   for f in lfs.dir(path) do
      repeat
         local file = pathJoin(path, f)
         if (not keepFile(f)) then break end

         local attr = (f == "default") and lfs.symlinkattributes(file) or lfs.attributes(file)
         if (attr == nil) then break end
         local kind = attr.mode

         if (attr.uid == 0 and user_uid == 0 and not attr.permissions:find("......r..")) then break end

         if (kind == "directory" and f ~= "." and f ~= "..") then
            dirA[#dirA + 1 ] = file
         elseif (kind == "file" or kind == "link") then
            local dfltFound = defaultFnT[f]
            local idx       = dfltFound or defaultIdx
            local fullName  = extractFullName(mpath, file)
            if (dfltFound) then
               if (idx < defaultIdx) then
                  defaultIdx = idx
                  local luaExt = f:find("%.lua$")
                  defaultT     = { fullName = fullName, fn = file, mpath = mpath, luaExt = luaExt, barefn = f}
                  if (f == "default" and kind == "file") then
                     fileT[fullName] = {fn = file, canonical = f, mpath = mpath}
                  end
               end
            elseif (not fileT[fullName] or not fileT[fullName].luaExt) then
               local luaExt = f:find("%.lua$")
               if (accept_fn(file) and (luaExt or checkValidModulefile(file))) then
                  fileT[fullName] = {fn = file, canonical = f:gsub("%.lua$", ""), mpath = mpath,
                                 luaExt = luaExt}
               end
            end
         end
      until true
   end
   if (next(defaultT) ~= nil) then
      defaultT = versionFile(mrc, defaultT)
   end

   return defaultT
end

local function walk_tree(mrc, mpath, pathIn, dirT)

   local dirA     = {}
   local fileT    = {}
   local defaultT = walk(mrc, mpath, pathIn, dirA, fileT)

   dirT.fileT    = fileT
   dirT.defaultT = defaultT
   dirT.dirT     = {}

   for i = 1,#dirA do
      local path     = dirA[i]
      local fullName = extractFullName(mpath, path)

      dirT.dirT[fullName] = {}
      walk_tree(mrc, mpath, path, dirT.dirT[fullName])

      ----------------------------------------------------------------
      -- if the directory is empty or bad symlinks then do not save it
      local T = dirT.dirT[fullName]
      if (next(T.dirT)     == nil and next(T.fileT)    == nil) then
         dirT.dirT[fullName] = nil
      end
   end
end

local function build(mpathA)
   local dirA = {}
   local mrc  = MRC:singleton()

   for i = 1,#mpathA do
      local mpath = mpathA[i]
      if (isDir(mpath)) then
         local dirT  = {}
         walk_tree(mrc, mpath, mpath, dirT)
         dirA[#dirA+1] = {mpath=mpath, dirT=dirT}
      end
   end
   return dirA
end

function M.new(self, mpathA)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   self.__dirA  = build(mpathA)
   return o
end

function M.dirA(self)
   return self.__dirA
end

return M
