#!/bin/bash
# -*- shell-script -*-

unset LMOD_ROOT
unset LMOD_PKG
unset LMOD_SETTARG_FULL_SUPPORT
unset LMOD_FULL_SETTARG_SUPPORT
unset NVM_DIR
unset XDG_CONFIG_HOME


OLD_IFS=$IFS
IFS=:
NEW_PATH=
for dir in $PATH; do
  if   [[ $dir =~ /.dotnet/ ]]; then
    :
  elif [[ $dir =~ /.config/ ]]; then
    :
  elif [[ $dir =~ /.local/ ]]; then
    :
  else
    NEW_PATH=$NEW_PATH:$dir
  fi
done
IFS=$OLD_IFS
PATH=${NEW_PATH#:}

pathA=( /scratch1/projects/compilers/intel20u0/intelpython3/bin
        /scratch1/projects/compilers/intel20u0/intelpython3/condabin
        /scratch1/projects/compilers/intel20u0/parallel_studio_xe_2020/bin64
        /scratch1/projects/compilers/intel20u0/parallel_studio_xe_2020/bin64
        /scratch1/projects/compilers/intel20u0/parallel_studio_xe_2020/bin64
        /scratch1/projects/compilers/intel20u0/itac/2020.0.015/intel64/bin
        /scratch1/projects/compilers/intel20u0/itac/2020.0.015/intel64/bin
        /scratch1/projects/compilers/intel20u0/parallel_studio_xe_2020.0.088/bin/intel64
        /scratch1/projects/compilers/intel20u0/compilers_and_libraries_2020.0.166/linux/bin/intel64
        /scratch1/projects/compilers/intel20u0/compilers_and_libraries_2020.0.166/linux/bin
        /scratch1/projects/compilers/intel20u0/compilers_and_libraries_2020.0.166/linux/mpi/intel64/libfabric/bin
        /scratch1/projects/compilers/intel20u0/compilers_and_libraries_2020.0.166/linux/mpi/intel64/bin
        /scratch1/projects/compilers/intel20u0/debugger_2020/gdb/intel64/bin )

(( num = "${#pathA[@]}" - 1 ))
for (( i = $num; i >= 0; i--)); do
  PATH=${pathA[$i]}:$PATH
done

PATH=$PATH:/scratch1/projects/compilers/intel20u0/parallel_studio_xe_2020.0.088/bin

echo $PATH
