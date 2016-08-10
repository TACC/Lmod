# cache_check.lua

## Usage
`cache_check.lua -c <system_cache_dir> -m <module_dir>`

## Intent
This simple script is meant for installations where a system cache is being used, but the system cache update (update_lmod_system_cache_files) is run manually. In our case, we build into a shared production modules dir by default, so having new modules not be readily available to our users is benficial. This script runs daily and notifies us of modules not in the system cache yet.
