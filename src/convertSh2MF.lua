_G._DEBUG      = false
local posix    = require("posix")

require("strict")
require("capture")
require("fileOps")

MF_Base            = require("MF_Base")
local concatTbl    = table.concat
local dbg          = require("Dbg"):dbg()
local i18n         = require("i18n")
local replaceStr   = require("replaceStr")
local getenv_posix = posix.getenv
local setenv_posix = posix.setenv

local validShellT =
   {
      tcsh = "tcsh",
      csh  = "tcsh",
      sh   = "sh",
      dash = "sh",
      bash = "bash",
      zsh  = "zsh",
      ksh  = "ksh",
   }

local shellTemplateT =
   {
      tcsh = { args = "-e -f -c",             flgErr = "",                source = "source", redirect = ">& /dev/stdout", complete = "complete", alias = "alias", funcs = "" },
      bash = { args = "--noprofile -norc -c", flgErr = "set -e;",         source = ".",      redirect = "2>&1",           complete = "complete", alias = "alias", funcs = "declare -f" },
      ksh  = { args = "-c",                   flgErr = "set -e;",         source = ".",      redirect = "2>&1",           complete = "",         alias = "alias", funcs = "typeset +f | while read f; do typeset -f ${f%\\(\\)}; echo; done" },
      zsh  = { args = "-f -c",                flgErr = "setopt errexit;", source = ".",      redirect = "2>&1",           complete = "",         alias = "alias", funcs = "declare -f" },
      sh   = { args = "-c",                   flgErr = "set -e;",         source = ".",      redirect = "2>&1",           complete = "",         alias = "alias", funcs = "" },
   }

local ignoreA = {
   "BASH_ENV",
   "COLUMNS",
   "DISPLAY",
   "EDITOR",
   "ENV",
   "ENV2",
   "GROUP",
   "HISTFILE",
   "HISTSIZE",
   "HOME",
   "HOST",
   "HOSTTYPE",
   "LC_ALL",
   "LINES",
   "LMOD_CMD",
   "LMOD_DIR",
   "LMOD_FULL_SETTARG_SUPPORT",
   "LMOD_PKG",
   "LMOD_ROOT",
   "LMOD_SETTARG_CMD",
   "LMOD_SETTARG_FULL_SUPPORT",
   "LMOD_VERSION",
   "LOGNAME",
   "MACHTYPE",
   "MAILER",
   "MODULESHOME",
   "OLDPWD",
   "OSTYPE",
   "PAGER",
   "PRINTER",
   "PS1",
   "PS2",
   "PWD",
   "REMOTEHOST",
   "REPLYTO",
   "SHELL",
   "SHLVL",
   "SSH_ASKPASS",
   "SSH_CLIENT",
   "SSH_CONNECTION",
   "SSH_TTY",
   "TERM",
   "TTY",
   "TZ",
   "USER",
   "VENDOR",
   "VISUAL",
   "_",
   "module",
}


local function l_cleanPath(value)

   local execT = {
      gcc    = 'keep',
      lua    = 'keep',
      python = 'keep',
      csh    = 'keep',
      bash   = 'keep',
   }

   local pathT  = {}
   local pathA  = {}

   local idx = 0
   for myPath in value:split(':') do
      idx        = idx + 1
      local path = path_regularize(myPath)
      if (pathT[path] == nil) then
         pathT[path]     = { idx = idx, keep = false }
         pathA[#pathA+1] = path
      end
   end

   local myPath = concatTbl(pathA,':')
   pathA        = {}

   for execName in pairs(execT) do
      local cmd, found = findInPath(execName, myPath)
      if (found) then
         local dir = dirname(cmd):gsub("/+$","")
         local p = path_regularize(dir)
         if (p and pathT[p]) then
            pathT[p].keep = true
         end
      end
   end

   for path in pairs(pathT) do
      if (value:find('^/usr/')) then
         pathT[path].keep = true
      end
   end

   -- Step 1: Make a sparse array with path as values
   local t = {}

   for k, v in pairs(pathT) do
      if (v.keep) then
         t[v.idx] = k
      end
   end

   -- Step 2: Use pairsByKeys to copy paths into pathA in correct order
   local n = 0
   for _, v in pairsByKeys(t) do
      n = n + 1
      pathA[n] = v
   end

   -- Step 3: rebuild path
   return concatTbl(pathA,':')
end

function l_cleanEnv()
   local keepT = {
      ['HOME']            = 'keep',
      ['USER']            = 'keep',
      ['LD_LIBRARY_PATH'] = 'keep',
      ['LUA_CPATH']       = 'keep',
      ['LUA_PATH']        = 'keep',
      ['PATH']            = 'neat',
   }

   local envT = getenv_posix()

   for k, v in pairs(envT) do
      local keep = keepT[k]
      if (not keep) then
         setenv_posix(k, nil, true)
      elseif (keep == 'neat') then
         setenv_posix(k, l_cleanPath(v), true)
      end
   end
end

local function l_convertSh2MF(shellName, style, makeCleanEnv, script)
   shellName = validShellT[shellName] or "bash"

   local shellT    = shellTemplateT[shellName]
   if (shellT == nil) then
      shellT    = shellTemplateT.bash
      shellName = "bash"
   end

   local ignoreT = {}
   for i = 1, #ignoreA do
      ignoreT[ignoreA[i]] = true
   end

   if (makeCleanEnv) then
      l_cleanEnv()
   end

   local sep    = "%__________blk_divider__________%"

   local LuaCmd = findLuaProg()
   local cmdA   = {
      "%{shell}",
      "%{shellArgs}",
      "\"",
      "%{flgErr}",
      "%{printEnvT} oldEnvT normal;",
      "echo %{sep};",
      "%{alias};",
      "echo %{sep};",
      "%{funcs};",
      "echo %{sep};",
      "%{complete};",
      "echo %{sep};",
      "%{printEnvT} oldEnvT exportFuncs;",
      "echo %{sep};",
      "%{source} %{script} %{redirect};",
      "echo %{sep};",
      "%{printEnvT} envT normal;",
      "echo %{sep};",
      "%{alias};",
      "echo %{sep};",
      "%{funcs};",
      "echo %{sep};",
      "%{complete};",
      "echo %{sep};",
      "%{printEnvT} envT exportFuncs;",
      "echo %{sep};",
      "\"",
   }

   local t     = {}

   t.shell     = findInPath(shellName)
   t.shellArgs = shellT.args
   t.printEnvT = LuaCmd .. " " .. pathJoin(cmdDir(),"printEnvT.lua")
   t.sep       = sep
   t.flgErr    = shellT.flgErr
   t.alias     = shellT.alias
   t.funcs     = shellT.funcs
   t.source    = shellT.source
   t.complete  = shellT.complete
   t.script    = script:gsub("\"","\\\\\"")
   t.redirect  = shellT.redirect

   local cmd   = replaceStr(concatTbl(cmdA," "), t)

   dbg.print{"LD_LIBRARY_PATH: ",os.getenv("LD_LIBRARY_PATH") or "","\n"}

   local output, status = capture(cmd)

   if (dbg.active()) then
      local f = io.open("s.log","w")
      if (f) then
         f:write(cmd,"\n")
         f:write(output)
         f:close()
      end
   end

   local processOrderA = { {"Vars", 1}, {"Aliases", 1}, {"Funcs", 1}, {"Complete", 1}, {"ExportFuncs", 1}, {"SourceScriptOutput", 0},
                           {"Vars", 2}, {"Aliases", 2}, {"Funcs", 2}, {"Complete", 2}, {"ExportFuncs", 2}, }

   local blkA = {}
   sep        = sep:escape()
   for i = 1, #processOrderA do
      local idx, endIdx = output:find(sep)
      if (idx == nil) then
         blkA[i] = output
         break
      end
      blkA[i] = output:sub(1,idx-1):gsub("^%s+","")
      output  = output:sub(endIdx+1,-1)
   end

   local success = true

   if (not status) then
      success = false
      local msg = i18n("e_Sh_Error",{script=script,errorMsg=blkA[6]})
      return success, msg, {}
   end

   if (#blkA < 9) then
      success = false
      local msg = i18n("e_Sh_convertSh2MF",{})
      return success, msg, {}
   end


   local resultT = { Vars        = {{},{}},
                     Aliases     = {{},{}},
                     Funcs       = {{},{}},
                     Complete    = {{},{}},
                     ExportFuncs = {{},{}},
                   }

   for i = 1, #processOrderA do
      local blkName     = processOrderA[i][1]
      local irstIdx     = processOrderA[i][2]
      if (irstIdx ~= 0) then
         resultT[blkName][irstIdx] = blkA[i]
      end
   end

   local factory = MF_Base.build(style)

   return success, "", factory:process(shellName, ignoreT, resultT)
end

return l_convertSh2MF

