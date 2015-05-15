help([[
The TACC modulefile defines the default paths and environment
variables needed to use the local software and utilities
on lonestar.
]])

append_path(     "PATH",        "/opt/apps/pki_apps")
append_path(     "MANPATH",     "/opt/apps/pki_apps/man")

setenv(          "APPS",        "/opt/apps")
setenv( 	 "PURGE", 	"168")

prepend_path(    "MANPATH",     "/usr/local/man:/usr/share/man:/usr/X11R6/man:/opt/ganglia/man:/opt/rocks/man:/usr/kerberos/man:/usr/man")

if (mode() == "load" and os.getenv("OMP_NUM_THREADS") == nil) then
  setenv("OMP_NUM_THREADS","1")
end
