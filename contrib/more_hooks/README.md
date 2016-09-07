In the `SitePackage.lua` in this directory there are a couple of
examples of hook:
- The load hook logs what modules get loaded and which are requested
  by the user and which ones are loaded as dependencies.
- The startup hook logs how Lmod gets called by the user.
- The msg hook adds a message to avail and warnings/errors to refer
  to the helpdesk.

Example grok patterns to parse the logging with Logstash can be found
at https://github.com/hpcugent/logstash-patterns
