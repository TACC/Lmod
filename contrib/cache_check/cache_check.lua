#!/usr/bin/env lua

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
--  Copyright (C) 2008-2014 Robert McLay
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

-- cache_check.lua - intended to be hooked or cron'd
-- does a quick check of all modules in module_dir for corresponding entry in dbT.lua in system_cache
-- prints modules from module_dir not in dbT.lua cache on STDOUT, otherwise is quiet
-- cache_check.lua -c system_cache_dir_containing_dbT.lua -m module_dir
-- Ben McGough bmcgough@fredhutch.org 8.8.16
local lfs = require("lfs")

cachedir = ""
moduledir = ""
exit_value = 0

function check_module(mod)
  for pkg_name, pkgT in pairs(dbT) do
    for cached_mod, modT in pairs(dbT[pkg_name]) do
      if cached_mod == mod then
        return 
      end
    end
  end
  exit_value = 1
  print("module "..mod.." is not in cache at "..cachedir)
  return
end

function scan_dir(directory)
  for file in lfs.dir(directory) do
    full_filename = directory..file
    if lfs.attributes(full_filename, "mode") == "file" then
      check_module(full_filename)
    elseif lfs.attributes(full_filename, "mode") == "directory" then
      if file == "." or file == ".." then
      else
        scan_dir(full_filename.."/")
      end
    end
  end
  return
end

function argparse()
  for i, v in ipairs(arg) do
    if v == "-h" or v == "--help" then
      exit_value = 1
      usage()
    end
    if v == "-c" then
      cachedir = arg[i+1]
    end
    if v == "-m" then
      moduledir = arg[i+1]
      if string.sub(moduledir,-1) ~= "/" then
        moduledir = moduledir.."/"
      end
    end
  end
  if cachedir == "" or moduledir == "" then
    exit_value = 1
    usage()
  end
end

function usage()
  print("Usage: arg[0] -c system_cache_dir -m module_dir")
  os.exit(exit_value)
end

argparse()

dofile(cachedir.."/dbT.lua")
scan_dir(moduledir)
os.exit(exit_value)
