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
--  Copyright (C) 2008-2025 Robert McLay
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
local cosmic    = require("Cosmic"):singleton()
local readlink  = posix.readlink
local sort      = table.sort
local stat      = posix.stat
local user_id   = 0
local getuid    = posix.getuid
if (getuid) then
   user_id = getuid()
end

local load      = (_VERSION == "Lua 5.1") and loadstring or load

local s_ignoreT = {
   ['.']          = true,
   ['..']         = true,
   ['.git']       = true,
   ['.gitignore'] = true,
   ['.svn']       = true,
   ['.lua']       = true,
   ['.DS_Store']  = true,
}

local s_defaultFnT = {
   default           = 1,
   ['.modulerc.lua'] = 2,
   ['.modulerc']     = 3,
   ['.version']      = 4,
}

local function l_keepFile(fn)
   if (s_defaultFnT[fn]) then
      return true
   end

   local firstChar = fn:sub(1,1)
   local lastChar  = fn:sub(-1,-1)
   local firstTwo  = fn:sub(1,2)

   local result    = not (s_ignoreT[fn]   or lastChar == '~'  or firstChar == '#' or
                          lastChar == '#' or firstTwo == '.#' or firstTwo == '__')
   if (not result) then
      return false
   end

   if (firstChar == "." and fn:sub(-4,-1) == ".swp") then
      return false
   end

   local ignorePattA = cosmic:value("LMOD_FILE_IGNORE_PATTERNS")
   for i = 1,#ignorePattA do
      local patt = ignorePattA[i]
      if (fn:find(patt)) then
         return false
      end
   end

   return true
end

local function l_checkValidTCLModulefileReal(fn)
   local f = open(fn,"r")
   if (not f) then
      return false
   end

   local line = f:read(20) or ""
   f:close()

   return (line:find("^#%%Module") ~= nil)
end

local function l_checkValidTCLModulefileFake(fn)
   return true
end

local l_checkValidTCLModulefile = l_checkValidTCLModulefileReal

--------------------------------------------------------------------------
-- Use readlink to find the link
-- @param path the path to the module file.
local function l_walk_link(path)
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
-- This routine is given the absolute path to all possible default
-- files.
-- @param defaultA - An array entries that contain: { fullName=, fn=, mpath=, luaExt=, barefn=}
-- return the first defaultA.  All other ones are ignored.
local function l_versionFile(mrc, mpath, defaultA)
   --dbg.start{"DirTree:l_versionFile(mrc, mpath, defaultA)"}
   sort(defaultA, function(x,y)
                    return x.defaultIdx < y.defaultIdx
                  end)
   repeat
      local defaultT = defaultA[1]
      local path     = defaultT.fn
      if (defaultT.barefn == "default") then
         defaultT.value = barefilename(l_walk_link(defaultT.fn)):gsub("%.lua$","")
         break
      end

      local modA = mrc_load(path)
      local _, _, name = defaultT.fullName:find("(.*)/.*")

      defaultT.value = mrc:parseModA_for_moduleA(name, mpath, modA)
   until true
   --dbg.fini("DirTree:l_versionFile")
   return defaultA
end

local function l_walk(mrc, mpath, path, dirA, fileT, regularFn)
   --dbg.start{"l_walk(mrc,mpath:\"",mpath,"\", path:\"",path,"\", dirA, fileT, regularFn"}
   local defaultA   = {}
   local permissions
   local uid
   local kind

   local attr       = lfs.attributes(path)
   if (not attr or type(attr) ~= "table" or attr.mode ~= "directory" or
       not access(path,"rx")) then
      --dbg.fini("l_walk")
      return defaultA, regularFn
   end


   for f in lfs.dir(path) do
      repeat
         local file = pathJoin(path, f)
         if (not l_keepFile(f)) then break end

         local attr = (f == "default") and lfs.symlinkattributes(file) or lfs.attributes(file)
         if (attr == nil) then break end
         local kind = attr.mode

         if (attr.uid == 0 and user_id == 0 and not attr.permissions:find("......r..")) then break end

         --dbg.print{"file: ",file,", kind: ",kind,"\n"}

         if (kind == "directory" and f ~= "." and f ~= "..") then
            if (user_id == 0 or attr.permissions:find("^r.x")) then
               dirA[#dirA + 1 ] = file
            end
         elseif (kind == "file" or kind == "link") then
            local dfltIdx   = s_defaultFnT[f]
            local fullName  = extractFullName(mpath, file)
            if (dfltIdx) then
               local luaExt = f:find("%.lua$")
               local sizeFn = lfs.attributes(file,"size")
               if (f ~= "default" and not luaExt and sizeFn > 0 and (not l_checkValidTCLModulefile(file))) then break end
               defaultA[#defaultA+1] = { fullName = fullName, fn = file, mpath = mpath, luaExt = luaExt,
                                         barefn = f, defaultIdx = dfltIdx, value = false}
               if (f == "default" and kind == "file") then
                  fileT[fullName] = {fn = file, canonical = f, mpath = mpath}
               end
            elseif (not fileT[fullName] or not fileT[fullName].luaExt) then
               local luaExt = f:find("%.lua$")
               if ((user_id == 0 or attr.permissions:find("^r")) and accept_fn(file) and (luaExt or l_checkValidTCLModulefile(file))) then
                  local dot_version = f:find("^%.version") or f:find("^%.modulerc")
                  fileT[fullName]   = {fn = file, canonical = f:gsub("%.lua$", ""), mpath = mpath,
                                       luaExt = luaExt, dot_version = dot_version}
               else
                  if (f:sub(1,1) ~= ".") then
                     regularFn = regularFn + 1
                  end
               end
            end
         end
      until true
   end
   if (next(defaultA) ~= nil) then
      defaultA = l_versionFile(mrc, mpath, defaultA)
   end

   --dbg.fini("l_walk")
   return defaultA, regularFn
end

----------------------------------------------------------------------
-- Since defaultA is sorted by defaultIdx.  The first one will be the
-- marked default, assuming that defaultA has any entries.

local function l_find_default(defaultA)
   local defaultT   = {}
   if (next(defaultA) ~= nil) then
      defaultT = defaultA[1]
   end
   return defaultT
end



local function l_walk_tree(mrc, mpath, pathIn, dirT, regularFn)

   local defaultA
   local dirA          = {}
   local fileT         = {}
   defaultA, regularFn = l_walk(mrc, mpath, pathIn, dirA, fileT, regularFn)

   dirT.fileT    = fileT
   dirT.defaultA = defaultA
   dirT.defaultT = l_find_default(defaultA)
   dirT.dirT     = {}

   for i = 1,#dirA do
      local path     = dirA[i]
      local fullName = extractFullName(mpath, path)

      dirT.dirT[fullName] = {}
      regularFn = l_walk_tree(mrc, mpath, path, dirT.dirT[fullName], regularFn)

      ----------------------------------------------------------------
      -- if the directory is empty or bad symlinks then do not save it
      local T = dirT.dirT[fullName]
      if (next(T.dirT)     == nil and next(T.fileT)    == nil) then
         dirT.dirT[fullName] = nil
      end
   end
   return regularFn
end

local function l_build(mpathA)
   --dbg.start{"l_build(mpathA)"}
   local dirA      = {}
   local mrc       = MRC:singleton()

   for i = 1,#mpathA do
      local regularFn = 0
      local mpath     = mpathA[i]
      if (isDir(mpath)) then
         local dirT  = {}
         regularFn = l_walk_tree(mrc, mpath, mpath, dirT, regularFn)
         --dbg.print{"regularFn: ",tostring(regularFn),"\n"}
         if (regularFn > 100) then
            LmodWarning{msg="w_Too_Many_RegularFn",mpath=mpath,regularFn=tostring(regularFn)}
         end
         dirA[#dirA+1] = {mpath=mpath, dirT=dirT}
      end
   end
   --dbg.fini("l_build")
   return dirA
end

function M.new(self, mpathA)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   self.__dirA  = l_build(mpathA)
   return o
end

function M.dirA(self)
   return self.__dirA
end

return M
