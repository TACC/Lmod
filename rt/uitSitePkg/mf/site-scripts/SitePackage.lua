-- -*- lua -*-
-- vim:ft=lua:et:ts=4
-- author: jonas.juselius@uit.no

require("lmod_system_execute")
local Dbg    = require("Dbg")
local dbg    = Dbg:dbg()
local hook   = require("Hook")
local siteAppRoot = os.getenv("LMOD_PKG_ROOT") or "/global/apps"
local defaultsDir = pathJoin(os.getenv("MODULEPATH_ROOT"), "defaults")
local helpDirRoot = os.getenv("LMOD_HELP_ROOT") or
              pathJoin(os.getenv("MODULEPATH_ROOT"), "help")
local siteUrl = "http://hpc.uit.no/"

---- Retrieve the directory portion of a path, or an empty string if
---- the path does not include a directory.
----
local function getdirectory(p)
    local n = string.find(p:reverse(), "/")
    local i = 0
    if n then i = p:len() - string.find(p:reverse(), "/") + 1 end
    if (i) then
        if i > 1 then i = i - 1 end
        return p:sub(1, i)
    else
        return "."
    end
end

function checkRestrictedGroup(pkg, group)
   dbg.start{"checkRestrictedGroup(pkg, \"",tostring(group),"\")"}
   if (mode() ~= "load") then
      dbg.fini("checkRestrictedGroup")
      return true
   end
   if (group == nil)     then
      dbg.fini("checkRestrictedGroup")
      return true
   end
   local err_message = "Only users in group \'" .. group ..
        "\' can access module \'" .. pkg.id .. "\'"
   local found = false
   local grps = capture("groups")

   for g in grps:split("[ \n]") do
      if (g == group) then
         dbg.fini("checkRestrictedGroup")
         return true
      end
   end
   LmodError(err_message,"\n")
   dbg.fini("checkRestrictedGroup")
   return false
end

function logUsage(pkg)
   dbg.start{"logUsage(pkg)"}
   if (mode() ~= "load") then
      dbg.fini("logUsage")
      return true
   end
   local user  = os.getenv("USER") or "__unknown__"
   local jobid = os.getenv("PBS_JOBID")
   local msg = ""
   dbg.print{"user: ",user," jobid: ",jobid,"\n"}
   if jobid == nil then
      msg = string.format("user=%s,app=%s", user, pkg.id)
   else
      msg = string.format("user=%s,app=%s,job=%s",
                          user, pkg.id, jobid)
   end
   local cmd = "logger -t lmod -p local0.info " .. msg
   --lmod_system_execute(cmd)
   dbg.fini("logUsage")
end

function prependModulePath(subdir)
   local mroot = os.getenv("MODULEPATH_ROOT")
   local mdir  = pathJoin(mroot, subdir)
   prepend_path("MODULEPATH", mdir)
end

function appendModulePath(subdir)
   local mroot = os.getenv("MODULEPATH_ROOT")
   local mdir  = pathJoin(mroot, subdir)
   append_path("MODULEPATH", mdir)
end

function readHelpFile(file_name)
   -- file_name required to end with ".rst" eg "help.rst"
   local help_text = "No help file found"
   if file_name:sub(-4,-1) == ".rst" then
      local file = io.open(pathJoin(helpDirRoot, file_name), "r")
      if file then
	 help_text = file:read("*all")
	 file:close()
      end
   end
   return help_text
end

function getAppRoot()
    return siteAppRoot
end

function setPkgInfo(pkg)
    if pkg.help:match(siteUrl) then
        pkg.help = "Site help: " .. pkg.help
    elseif pkg.help:match("http://.*") then
        pkg.help = "Off-site help: " .. pkg.help
    end
    help(pkg.help)

    whatis("Name: "        .. pkg.display_name)
    whatis("Version: "     .. pkg.version)
    whatis("Module: "      .. pkg.id)
    whatis("Category: "    .. pkg.category)
    whatis("Keyword: "     .. pkg.keywords)
    whatis("URL: "         .. pkg.url)
    whatis("License: "     .. pkg.license)
    whatis("Description: " .. pkg.description)
    if pkg.help:match("[Ss]ite help: http://.*") then
        whatis("Help: " .. pkg.help:gsub(".* (http://.*)", "%1"))
    else
        whatis("Help: " .. pkg.url)
    end
end

function loadPkgDefaults()
    local pkg = {}
    local status
    local msg
    local whole
    local fn
    local f
    dbg.start{"loadPkgDefaults()"}

    pkg.name              = myModuleName()
    pkg.version           = myModuleVersion()
    pkg.id                = myModuleFullName()
    pkg.prefix            = pathJoin(getAppRoot(), pkg.id)
    pkg.display_name      = pkg.name
    pkg.url               = ""
    pkg.license           = ""
    pkg.category          = ""
    pkg.keywords          = ""
    pkg.description       = ""
    pkg.help              = ""


    dbg.print{"name: ", pkg.name, " version: ", pkg.version, " id: ",pkg.id,"\n"}

    fn = pathJoin(defaultsDir, pkg.name .. ".lua")
    f  = io.open(fn)


    if (f) then
        whole = f:read("*all")
        f:close()
    end

    if (whole) then
        status, msg = sandbox_run(whole)
    end

    if (not status) then
        LmodError("Unable to load file: ", fn, ": ", msg, "\n")
    end

    for k,v in pairs(msg) do pkg[k] = v end

    dbg.fini("loadPkgDefaults")
    return pkg
end

sandbox_registration {
      getAppRoot           = getAppRoot
    , loadPkgDefaults      = loadPkgDefaults
    , setPkgInfo           = setPkgInfo
    , prependModulePath    = prependModulePath
    , appendModulePath     = appendModulePath
    , logUsage             = logUsage
    , checkRestrictedGroup = checkRestrictedGroup
    , readHelpFile         = readHelpFile
}

