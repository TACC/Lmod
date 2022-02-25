#!/bin/zsh
# -*- shell-script -*-

for i in */**/t1/*; do
  mv $i/*.txt $i/../..
done

#for i in */**/out.txt; do
#gsed -i.bak -e 's/^__LMOD_REF_COUNT_LOADEDMODULES.*$//g'        \
#            -e 's/^export __LMOD_REF_COUNT_LOADEDMODULES;.*//g' \
#            -e 's/^unset __LMOD_REF_COUNT_LOADEDMODULES;.*//g' \
#            -e 's/^__LMOD_REF_COUNT__LMFILES_.*$//g'            \
#            -e 's/^export __LMOD_REF_COUNT__LMFILES_;.*//g'     \
#            -e 's/^unset __LMOD_REF_COUNT__LMFILES_;.*//g'     \
#            -e '/^ *$/d'                                        \
#            $i
#rm $i.bak
#done




