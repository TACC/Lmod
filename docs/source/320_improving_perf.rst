.. _improving_perf-label:

=============================
Improving performance of Lmod
=============================

Lmod is written two scripting languages: Lua and TCL.  Your site can
improve the loading of modules by doing the following steps:

#. Create a system cache file (described at :ref:`system-spider-cache-label`)

#. **ALWAYS** keep the cache file up-to-date.

#. Configure Lmod to use LMOD_CACHED_LOADS=yes

These are the most important steps.  As long as your site keeps the
cache file up-to-day, the above steps will improve performance the
most.

If your site has many .version or .modulerc files, your site should
consider over time converting them to the .modulerc.lua equivalent.
Parsing Lua files always is faster than TCL.  Lmod uses a TCL program
to convert the TCL into Lua.  This means that any TCL file is
interpreted twice once by TCL and then by Lua.

Lmod used to make a system call to run the TCL interpreter and capture
the output. Lmod 8+ now integrates in a TCL interpreter as part of the
Lmod program to improve performance.  This improves the time to
process the TCL .version or modulefile. But a Lua .modulerc.lua or a
lua modulefile is faster because the double interpretation is avoided.




