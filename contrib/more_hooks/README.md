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
