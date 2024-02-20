    _sp_multi_pathadd() {
        local IFS=':'
        if [ "$_sp_shell" = zsh ]; then
            emulate -L sh
        fi
        for pth in $2; do
            for systype in ${_sp_compatible_sys_types}; do
                _spack_pathadd "$1" "${pth}/${systype}"
            done
        done
    }
