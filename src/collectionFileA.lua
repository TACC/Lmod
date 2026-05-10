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

require("utils")

local dbg    = require("Dbg"):dbg()

local function l_normalizeDotHiddenVersion(versionStr)
   if (not versionStr or versionStr == "") then
      return ""
   end
   local a = {}
   for part in versionStr:gmatch("[^/]+") do
      if (part:sub(1,1) == ".") then
         part = part:sub(2)
      end
      a[#a+1] = part
   end
   return table.concat(a, "/")
end

function collectFileA(sn, versionStr, extended_default, v, fileA)
   dbg.start{"collectFileA(sn: \"",sn,"\", versionStr: ", versionStr,", v,fileA)"}
   --dbg.printT("v",v)
   --assert(versionStr ~= "default","wtf")
   if (v.fileT and next(v.fileT) ~= nil ) then
      local found  = false
      if (versionStr and (versionStr ~= "default" or v.fileT.default)) then
         local k  = pathJoin(sn, versionStr)
         dbg.print{"k: ",k,"\n"}
         local vv = v.fileT[k]
         if (vv) then
            fileA[#fileA+1] = { sn = sn, fullName = build_fullName(sn, versionStr),
                                version = versionStr, fn = vv.fn, wV = vv.wV, pV = vv.pV, mpath = vv.mpath }
            --dbg.printT("fileA",fileA)
            dbg.fini("collectFileA exact match")
            return
         end

         local cosmic = require("Cosmic"):singleton()
         if (cosmic:value("LMOD_DOT_HIDDEN_LOAD_ALIAS") == "yes") then
            local targetNorm = l_normalizeDotHiddenVersion(versionStr)
            local candK      = false
            local candVv     = false
            local ambiguous  = false
            local snPrefix   = sn .. "/"
            for fk, fvv in pairs(v.fileT) do
               if (fk:sub(1, #snPrefix) == snPrefix) then
                  local vFromKey = fk:sub(#snPrefix + 1)
                  if (l_normalizeDotHiddenVersion(vFromKey) == targetNorm) then
                     if (candK) then
                        ambiguous = true
                        candK     = false
                        candVv    = false
                        break
                     end
                     candK  = fk
                     candVv = fvv
                  end
               end
            end
            if (candK and candVv and (not ambiguous)) then
               local canonVs = candK:gsub("^" .. sn:escape() .. "/", "")
               -- versionStr is the user's logical spec (e.g. 1.2); canonVs is the
               -- key segment (e.g. .1.2). Keep both so exact-match uses logical
               -- version for entry.version == versionStr while MT fullName uses canonVs.
               fileA[#fileA+1] = { sn = sn, fullName = build_fullName(sn, canonVs),
                                   version = versionStr, dotHiddenCanonVs = canonVs,
                                   fn = candVv.fn, wV = candVv.wV,
                                   pV = candVv.pV, mpath = candVv.mpath }
               dbg.fini("collectFileA dot-hidden alias")
               return
            end
         end

         if (extended_default == "yes") then
            local vp     = versionStr
            local extra  = ""
            local bndPat = "[-+_.=a-zA-Z]"
            if (not vp:sub(-1):find(bndPat)) then
               extra = "[-+_.=/]"
            end
            local keyPat = pathJoin(sn,vp):escape() .. extra .. ".*"
            for k,vvv in pairs(v.fileT) do
               dbg.print{ "k: ",k,", keyPat: ",keyPat," k:find(keyPat): ",k:find(keyPat), "\n"}
               if (k:find(keyPat)) then
                  found = true
                  fileA[#fileA+1] = { sn = sn, fullName = k,
                                      version = k:gsub("^" .. sn:escape() .. "/",""),
                                      fn = vvv.fn, wV = vvv.wV, pV = vvv.pV, mpath = vvv.mpath }
               end
            end
         end

         if (found and (not (v.dirT and next(v.dirT) ~= nil))) then
            -- We can return if we found something or the version string is not /default 
            -- and there are no entries in v.dirT
            --dbg.printT("fileA",fileA)
            dbg.fini("collectFileA via found or versionStr ~= \"default\"")
            return
         end
      else
         dbg.print{"Adding v.fileT to fileA\n"}
         for fullName, vv in pairs(v.fileT) do
            local version   = extractVersion(fullName, sn)
            fileA[#fileA+1] = { sn = sn, fullName = fullName, version = version, fn = vv.fn,
                                wV = vv.wV, pV = vv.pV, mpath = vv.mpath }
         end
      end
      --dbg.printT("fileA",fileA)
   end
   if (v.dirT and next(v.dirT) ~= nil) then
      for k, vv in pairs(v.dirT) do
         dbg.print{"k: ",k,"\n"}
         collectFileA(sn, versionStr, extended_default, vv, fileA)
      end
   end
   dbg.fini("collectFileA")
end
