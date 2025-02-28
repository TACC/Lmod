set_shell_function("_some_spack_func", "\
   local ARG1=$1;\
   if [[ $ARG1 == [a-z]* ]]; then\
     echo found;\
   fi\
","")
export_shell_function("_some_spack_func")
