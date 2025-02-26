   local _func = [==[
    STR="
    foo
    bar
"
    echo $STR \





]==]

set_shell_function("foo", _func)
