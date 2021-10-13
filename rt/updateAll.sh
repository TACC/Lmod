#!/bin/zsh
# -*- shell-script -*-

for i in */**/t1/*; do
  mv $i/*.txt $i/../..
done
