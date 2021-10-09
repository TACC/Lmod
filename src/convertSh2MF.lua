require("strict")
require("capture")
require("fileOps")

MF_Base            = require("MF_Base")
local concatTbl    = table.concat
local dbg          = require("Dbg"):dbg()
local replaceStr   = require("replaceStr")

local validShellT =
   {
      tcsh = "tcsh",
      csh  = "tcsh",
      sh   = "sh",
      dash = "sh",
      bash = "bash",
      zsh  = "zsh",
      fish = "fish",
      ksh  = "ksh",
   }

local shellTemplateT =
   {
      tcsh = { args = "-e -f -c",             flgErr = "",                source = "source", redirect = ">& /dev/stdout", alias = "alias", funcs = "" },
      bash = { args = "--noprofile -norc -c", flgErr = "set -e;",         source = ".",      redirect = "2>&1",           alias = "alias", funcs = "declare -f" },
      ksh  = { args = "-c",                   flgErr = "set -e;",         source = ".",      redirect = "2>&1",           alias = "alias", funcs = "typeset +f | while read f; do typeset -f ${f%\\(\\)}; echo; done" },
      zsh  = { args = "-f -c",                flgErr = "setopt errexit;", source = ".",      redirect = "2>&1",           alias = "alias", funcs = "declare -f" },
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


local function convertSh2MF(shellName, style, script)
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

   local sep    = "%__________blk_divider__________%"

   local LuaCmd = findLuaProg()
   local cmdA   = {
      "%{shell}",
      "%{shellArgs}",
      "\"",
      "%{flgErr}",
      "%{printEnvT} oldEnvT;",
      "echo %{sep};",
      "%{alias};",
      "echo %{sep};",
      "%{funcs};",
      "echo %{sep};",
      "%{source} %{script} %{redirect};",
      "echo %{sep};",
      "%{printEnvT} envT;",
      "echo %{sep};",
      "%{alias};",
      "echo %{sep};",
      "%{funcs};",
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
   t.script    = script:gsub("\"","\\\\\"")
   t.redirect  = shellT.redirect

   local cmd   = replaceStr(concatTbl(cmdA," "), t)

   local output,status = capture(cmd)

   if (dbg.active()) then
      local f = io.open("s.log","w")
      if (f) then
         f:write(cmd,"\n")
         f:write(output)
         f:close()
      end
   end

   if (not status) then
      io.stderr:write("status: ",tostring(status)," Error in script!\n")
      os.exit(-1)
   end


   local processOrderA = { {"Vars", 1}, {"Aliases", 1}, {"Funcs", 1}, {"SourceScriptOutput", 0},
                           {"Vars", 2}, {"Aliases", 2}, {"Funcs", 2}}

   local resultT = { Vars    = {{},{}},
                     Aliases = {{},{}},
                     Funcs   = {{},{}},
                   }
   sep = sep:escape()

   for i = 1, #processOrderA do
      repeat
         local idx,endIdx  = output:find(sep)
         local blk         = output:sub(1,idx-1)
         output            = output:sub(endIdx+1,-1)
         local blkName     = processOrderA[i][1]
         local irstIdx     = processOrderA[i][2]
         blk               = blk:gsub("^%s+","")
         if (irstIdx == 0) then break end
         resultT[blkName][irstIdx] = blk
      until (true)
   end
   
   local factory = MF_Base.build(style)

   return factory:process(shellName, ignoreT, resultT)
end

return convertSh2MF

