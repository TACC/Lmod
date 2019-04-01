#!/bin/bash
# -*- shell-script -*-

type -p lsb_release > /dev/null 2>&1
if [ "$?" = 0 ]; then
    result=$(lsb_release -a 2> /dev/null | grep '^Description:' | sed -e 's/^Description:[ \t]*//g')
    echo $result
    exit 0
fi

if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $PRETTY_NAME
    exit 0
fi

if [ -f /etc/SuSe-release ]; then
    result=$(cat /etc/SuSe-release | head -n 1)
    echo $result
    exit 0
fi

if [ -f /etc/redhat-release ]; then
    result=$(cat /etc/redhat-release | head -n 1)
    echo $result
    exit 0
fi

result=$(uname -v)
echo $result

