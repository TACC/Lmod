In the `SitePackage.lua` in this directory there are a couple of
examples of hook:
- The load hook logs what modules get loaded and which are requested
  by the user and which ones are loaded as dependencies.
- The startup hook logs how Lmod gets called by the user and restores
  LD_LIBRARY_PATH and LD_PRELOAD if they get renamed by the module function.
  (as in https://github.com/hpcugent/Lmod-UGent/blob/master/Lmod-ml-rename-ld-path.patch)
- The msg hook adds a message to avail to request new software at the helpdesk
- The errWarnMsg adds a reference to the helpdesk and overwrites the 'No AutoSwap' message.
  This is tailored specifically to EasyBuild. All errors users get are also logged.
- The isVisible hook hides modules of toolchain which is older then 2 years.

Example grok patterns to parse the logging with Logstash can be found
at https://github.com/hpcugent/logstash-patterns

The version of this `SitePackage.lua` used in production can be at
https://github.com/hpcugent/Lmod-UGent/

It also contains a `get_avail_memory` function that is exported to the module sandbox. It
can be used to find out if the memory is limited (by cgroups) in the environment where
the module is loaded. Example usage for a Java module:

```lua
local mem = get_avail_memory()
if mem then
    setenv("JAVA_TOOL_OPTIONS",  "-Xmx" .. math.floor(mem*0.8))
end
```
