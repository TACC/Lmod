# tab-completion
# Author: Alberto Sartori, 2019


function __fish_lmod_commands
    printf "help "
    printf "load try-load add try-add "
    printf "unload rm del "
    printf "swap sw switch "
    printf "purge refresh update "
    printf "list "
    printf "av avail "
    printf "spider "
    printf "whatis keyword key "
    printf "save s "
    printf "reset "
    printf "restore r "
    printf "savelist "
    printf "describe mcc "
    printf "disable "
    printf "show is-loaded is-avail use unuse "
    printf "tablelist "
end


function __fish_lmod_av
    echo (module -t av 2>&1 | sed '/^\//d' | sed -e 's/(@.*//' )
end

function __fish_lmod_list
    set -l out (module -t list 2>&1 | string split ' ')
    if contains 'No' $out and contains 'modules' $out and contains 'loaded' $out
	echo ''
    else
	echo "$out"
    end
end

function __fish_lmod_savelist
    set -l out (module -t savelist 2>&1 | string split ' ')
    if contains 'No' $out and contains 'named' $out and contains 'collections' $out
	echo ''
    else
	echo "$out"
    end
end

function _get_commandline_list
    set -l cmd (commandline | string trim)
    string split ' ' $cmd
end

function __fish_lmod_needs_command
    set -l words (_get_commandline_list)
    for c in (__fish_lmod_commands | string split ' ')
	if contains -- $c $words
	    return 1
	end
    end
    return 0
end
    

function __fish_lmod_using_command
    for a in $argv
	if contains $a (_get_commandline_list)
	    return 0
	end
    end
    return 1
end

# get documentation
complete -f -c module -s h -l help -d 'Prints help message'
complete -f -c module -s H  -d 'Prints help message'
complete -f -c module -s '?' -d 'Prints help message'
complete -f -c module -n '__fish_lmod_needs_command' -a 'help' -d 'Print help message'
complete -f -c module -n '__fish_lmod_using_command help' -r -a (__fish_lmod_av) -d 'Print help message from module(s)'

# few options
complete -f -c module -s v -l version  -d 'Print version info and quit' -r 
complete -f -c module -s r -l regexp  -a 'spider list avail keyword av key' -d 'Use regular expression match'
complete -f -c module -l check_syntax -d 'Checking module command syntax: do not load' -r -a (__fish_lmod_av)
complete -f -c module -l checkSyntax -d 'Checking module command syntax: do not load' -r -a (__fish_lmod_av)

###### subcommands

# load | add
complete -f -c module -n '__fish_lmod_needs_command' -a 'load add' -d 'Load module(s)'
complete -f -c module -n '__fish_lmod_needs_command' -a 'try-load try-add' -d 'Add module(s), do not complain if not found'
complete -f -c module -n '__fish_lmod_using_command load add try-load try-add' -r -a (__fish_lmod_av)

# del | unload | rm
complete -f -c module -n '__fish_lmod_needs_command' -a 'del unload rm' -r -d 'Remove(s), do not complain if not found'
complete -f -c module -n '__fish_lmod_using_command del unload rm' -r -a (__fish_lmod_list)

# swap | sw | switch
complete -f -c module -n '__fish_lmod_needs_command' -a 'swap sw switch' -r -d 'Unload m1 and load m2'
complete -f -c module -n '__fish_lmod_using_command swap sw switch' -r -a (__fish_lmod_av)

# purge
complete -f -c module -n '__fish_lmod_needs_command' -a 'purge' -r -d 'Unload all modules'
complete -f -c module -n '__fish_lmod_using_command purge' -r

# refresh
complete -f -c module -n '__fish_lmod_needs_command' -a 'refresh' -r -d 'Reload aliases from current list of modules'
complete -f -c module -n '__fish_lmod_using_command refresh' -r

# update
complete -f -c module -n '__fish_lmod_needs_command' -a 'update' -r -d 'Reload all currently loaded modules'
complete -f -c module -n '__fish_lmod_using_command update' -r

# list
complete -f -c module -n '__fish_lmod_needs_command' -a 'list' -d 'List loaded modules'
complete -f -c module -n '__fish_lmod_using_command list' -r

# avail | av
complete -f -c module -n '__fish_lmod_needs_command' -a 'av avail' -d 'List available modules'
complete -f -c module -n '__fish_lmod_using_command av avail' -r -a (__fish_lmod_av)

# spider
complete -f -c module -n '__fish_lmod_needs_command' -a 'spider' -d 'List all possible modules'
complete -f -c module -n '__fish_lmod_using_command spider' -r -a (__fish_lmod_av)

# whatis
complete -f -c module -n '__fish_lmod_needs_command' -a 'whatis' -r -d 'Print whatis information about module'
complete -f -c module -n '__fish_lmod_using_command whatis' -r -a (__fish_lmod_av)

# keyword | key
complete -f -c module -n '__fish_lmod_needs_command' -a 'keyword key' -d 'Search all name and whatis that contain "string"'
complete -f -c module -n '__fish_lmod_using_command keyword key' -r

# save | s
complete -f -c module -n '__fish_lmod_needs_command' -a 'save s' -d 'Save the current list of modules'
complete -f -c module -n '__fish_lmod_using_command save' -r

# reset
complete -f -c module -n '__fish_lmod_needs_command' -a 'reset' -d 'The same as "restore system"'
complete -f -c module -n '__fish_lmod_using_command reset' -r

# restore
complete -f -c module -n '__fish_lmod_needs_command' -a 'restore' -d 'Restore modules from collection'
complete -f -c module -n '__fish_lmod_using_command restore' -r -a (__fish_lmod_savelist)

# savelist
complete -f -c module -n '__fish_lmod_needs_command' -a 'savelist' -d 'List of saved collections'
complete -f -c module -n '__fish_lmod_using_command savelist' -r

# describe | mcc
complete -f -c module -n '__fish_lmod_needs_command' -a 'descibe mcc' -d 'Descibe the contents of a module collection'
complete -f -c module -n '__fish_lmod_using_command describe mcc' -r -a (__fish_lmod_savelist)

# disable
complete -f -c module -n '__fish_lmod_needs_command' -a 'disable' -d 'Disable a collection'
complete -f -c module -n '__fish_lmod_using_command disable' -r -a (__fish_lmod_savelist)

# is-loaded
complete -f -c module -n '__fish_lmod_needs_command' -a 'is-loaded' -d 'Return a true status if module is loaded'
complete -f -c module -n '__fish_lmod_using_command is-loaded' -r -a (__fish_lmod_av)

# is-avail
complete -f -c module -n '__fish_lmod_needs_command' -a 'is-avail' -d 'Return a true status if module can be loaded'
complete -f -c module -n '__fish_lmod_using_command is-avail' -r -a (__fish_lmod_av)

# show
complete -f -c module -n '__fish_lmod_needs_command' -r -a 'show' -d 'Show the commands in the module file'
complete -f -c module -n '__fish_lmod_using_command show' -r -a (__fish_lmod_av)

# use
complete -f -c module -n '__fish_lmod_needs_command' -a 'use' -d 'Prepend path to MODULEPATH'
complete -c module -n '__fish_lmod_using_command use' -s a -r -d 'Append path to MODULEPATH'

# unuse
complete -f -c module -n '__fish_lmod_needs_command' -a 'unuse' -d 'Remove path from MODULEPATH'
complete -c module -n '__fish_lmod_using_command unuse' -r

# tablelist
complete -f -c module -n '__fish_lmod_needs_command' -a 'tablelist' -d 'Remove path from MODULEPATH'
complete -c module -n '__fish_lmod_using_command tablelist' -x

