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

require("utils")

local dbg    = require("Dbg"):dbg()
function collectFileA(sn, versionStr, extended_default, v, fileA)
   --dbg.start{"collectFileA(",sn,",", versionStr,",v,fileA)"}
   if (v.file and versionStr == nil) then
      fileA[#fileA+1] = { sn = sn, version = nil, fullName = sn, fn=v.file, wV="~", pV="~" }
   end
   if (v.fileT and next(v.fileT) ~= nil ) then
      if (versionStr) then
         local k  = pathJoin(sn, versionStr)
         local vv = v.fileT[k]
         --dbg.print{"k: ",k,", vv: ",vv,"\n"}
         if (vv) then
            fileA[#fileA+1] = { sn = sn, fullName = build_fullName(sn, versionStr),
                                version = versionStr, fn = vv.fn, wV = vv.wV, pV = vv.pV }
            --dbg.print{"versionStr:",versionStr,"\n"}
            --dbg.fini("collectFileA")
            return
         end
         if (extended_default == "yes") then
            local vp = versionStr
            if (vp:sub(-1) ~= ".") then
               vp = vp .. "."
            end
            local keyPat = pathJoin(sn,vp:gsub("%.","%%.") .. ".*")
            dbg.print{"collectFileA: versionStr: ",versionStr,", keyPat: ",keyPat,"\n"}
            for k,vvv in pairs(v.fileT) do
               if (k:find(keyPat)) then
                  fileA[#fileA+1] = { sn = sn, fullName = k, version = k:gsub("^" .. sn .. "/",""),
                                      fn = vvv.fn, wV = vvv.wV, pV = vvv.pV }
               end
            end
         end
      else
         for fullName, vv in pairs(v.fileT) do
            local version   = extractVersion(fullName, sn)
            fileA[#fileA+1] = { sn = sn, fullName = fullName, version = version, fn = vv.fn,
                                wV = vv.wV, pV = vv.pV }
         end
      end
   end
   --if (v.dirT and next(v.dirT) ~= nil and versionStr == nil) then
   if (v.dirT and next(v.dirT) ~= nil) then
      for k, vv in pairs(v.dirT) do
         collectFileA(sn, nil, extended_default, vv, fileA)
      end
   end
   --dbg.fini("collectFileA")
end
