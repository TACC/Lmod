require("strict")
require("utils")

function collectFileA(sn, versionStr, v, fileA)
   if (v.file and versionStr == nil) then
      fileA[#fileA+1] = { sn = sn, version = nil, fn=v.file, wV="~", pV="~" }
   end
   if (v.fileT and next(v.fileT) ~= nil ) then
      if (versionStr) then
         local k  = pathJoin(sn, versionStr)
         local vv = v.fileT[k]
         if (vv) then
            fileA[#fileA+1] = { sn = sn, version = versionStr, fn = vv.fn, wV = vv.wV, pV = vv.pV }
            return
         end
      else
         for fullName, vv in pairs(v.fileT) do
            local version   = extractVersion(fullName, sn)
            fileA[#fileA+1] = { sn = sn, version = version, fn = vv.fn, wV = vv.wV, pV = vv.pV }
         end
      end
   end
   if (v.dirT and next(v.dirT) ~= nil and versionStr == nil) then
      for k, vv in pairs(v.dirT) do
         collectFileA(sn, nil, vv, fileA)
      end
   end
end
