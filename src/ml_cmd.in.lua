#!@path_to_lua@/lua
-- -*- lua -*-
------------------------------------------------------------------------
-- Use command name to add the command directory to the package.path
------------------------------------------------------------------------
local LuaCommandName = arg[0]
local i,j = LuaCommandName:find(".*/")
local LuaCommandName_dir = "./"
if (i) then
   LuaCommandName_dir = LuaCommandName:sub(1,j)
end
package.path = LuaCommandName_dir .. "tools/?.lua;" .. 
               LuaCommandName_dir .. "?.lua;"       .. package.path

require("strict")
require("string_split")
local concatTbl = table.concat
local function quoteWrap(a)
   return "'" .. tostring(a) .. "'"
end

function usage()
   io.stderr:write("\n",
                   "ml: A handy front end for the module command:\n\n",
                   "Simple usage:\n",
                   " -------------\n",
                   "  $ ml\n",
                   "                           means: module list\n",
                   "  $ ml foo bar\n",
                   "                           means: module load foo bar\n",
                   "  $ ml -foo -bar baz goo\n",
                   "                           means: module unload foo bar;\n",
                   "                                  module load baz goo;\n\n",
                   "Command usage:\n",
                   "--------------\n\n",
                   "Any module command can be given after ml:\n\n",
                   "if name is avail, getdefault setdefault, show, swap,...\n",
                   "    $ ml name  arg1 arg2 ...\n\n",
                   "Then this is the same :\n",
                   "    $ module name arg1 arg2 ...\n\n",
                   "In other words you can not load a module named: show swap etc\n")
   io.stderr:write("\n\n-----------------------------------------------\n",
                   "  Robert McLay, TACC\n",
                   "     mclay@tacc.utexas.edu\n")
end



function main()

   local argA     = {}
   local optA     = {}
   local cmdA     = {}

   ------------------------------------------------------------
   -- lmodOptA: Hash table of command line arguments.  The key
   --           is the name of the argument and the value is the
   --           number of arguments the option requires
   
   local lmodOptA = {
      ["-?"] = 0, ["-h"] = 0, ["--help"] = 0, ["-d"]=0, ["--version"]=0,
      ["--old_style"] = 0, ["--expert"]=0, ["--novice"]=0, ["-D"]=0, 
      ["--localvar"]=1, ["-D"]=1, ["--versoin"]=0, ["--ver"]=0, ["--v"]=0,
      ["--terse"] = 0, ["-t"] = 0,
   }

   local translateT = {
      ["--versoin"]="--version",
      ["--ver"]="--version",
      ["--v"]="--version",
   }

   ------------------------------------------------------------
   -- lmodCmdA: Hash table of module commands.  The value just
   --           has to be non-nil

   local lmodCmdA = {
      add="load",
      avail="avail",  av="avail", 
      getdefault="getdefault", gd="getdefault", 
      help="help",
      key="keyword", keyword="keyword",
      list="list",
      listdefault="listdefault", ld="listdefault",
      purge="purge",
      r="restore", restore="restore",
      refresh="refresh",
      reset="reset",
      s="save",
      save="save",
      savelist="savelist", sl="savelist",
      setdefault="save", sd="save", 
      show="show",
      spider="spider",
      swap="swap", sw="swap", switch="swap",
      tablelist="tablelist",
      unload="unload", rm = "unload", del = "unload", delete="unload",
      unuse="unuse",
      update="update",
      use="use",
      whatis="whatis",
   }

   local grab     = 0
   local verbose  = false
   local oldStyle = false

   for _,v in ipairs(arg) do
      local done = false
      if (grab > 0) then
         optA[#optA+1] = v
         grab          = grab - 1
         done          = true
      end

      if (not done and v == "-v") then
         done    = true
         verbose = true
      end
      
      if (not done and v == "--old_style") then
         done     = true
         oldStyle = true
      end

      if (not done and v == "--help" or v == "-?" or v== "-h") then
         done = true
         usage()
         return
      end


      local num = lmodOptA[v]
      if (not done and num) then
         grab          = num
         optA[#optA+1] = translateT[v] or v
         done          = true
      end

      local cmd = lmodCmdA[v]
      if (not done and cmd) then
         cmdA[#cmdA + 1] = cmd
         done            = true
      end

      if (not done) then
         argA[#argA+1] = v
      end
   end

   if (#cmdA > 1) then
      io.stderr:write("ml error: too many commands\n")
      os.exit(1)
   end

   local opts = concatTbl(optA," ")

   local a = {}

   local kind = nil

   a[#a + 1] = "module"
   a[#a + 1] = opts

   if (#cmdA == 1) then
      a[#a + 1] = cmdA[1]
   elseif (#argA < 1) then
      a[#a + 1] = "list"
   else
      if (oldStyle) then
         kind      = "load"
      else
         a[#a + 1] = "load"
      end
   end

   if (kind == 'load') then
      local b = {}
      local u = {}
      for i = 1,#argA do
         if (argA[i]:sub(1,1) == "-") then
            u[#u+1] = quoteWrap(argA[i]:sub(2,-1))
         else
            b[#b+1] = quoteWrap(argA[i])
         end
      end
      if (#u > 0) then
         a[#a+1] = "unload"
         a[#a+1] = concatTbl(u," ")
         if (#b > 0) then
            a[#a+1] = "; module"
            a[#a+1] = opts
         end
      end

      if (#b > 0) then
         a[#a+1] = "load "
         a[#a+1] = concatTbl(b," ")
      end
   else
      for i = 1,#argA do
         a[#a+1] = quoteWrap(argA[i])
      end
   end

   local s = concatTbl(a," ")
      
   if (verbose) then
      io.stderr:write(s, "\n")
   end
      
   io.stdout:write(s, "\n")
end

main()
