append_path("PATH", "/share/sge6.2/default/pe_scripts")
append_path("PATH", ".")
append_path("MANPATH","/usr/local/man")
prepend_path("PATH", "/usr/local/first")
prepend_path("LD_LIBRARY_PATH", "/opt/ofed/lib64")
help(
[[The TACC-paths modulefile defines the default paths and environment
variables needed to use the local software and utilities
available in /usr/local, placing them after the vendor-supplied
paths in PATH and MANPATH.:
]])
