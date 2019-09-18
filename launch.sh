#!/usr/bin/env bash

## intelliJPywal/lanuch.sh
## author: Richard Loveless III (RLovelessIII)
## description: launch script for IntelliJPywal

# Supported IDE's
IDE=( "IntelliJIdea" "PyCharm" "WebStorm" )

# Get current Operating System
OS=$(uname)

if [ "${OS}" == "Darwin" ]; then
  usr_conf_dir="${HOME}/Library/Preferences"
  for i in "${IDE[@]}"
    do
      ide_name="$i"
      ide_dir=$(find "${usr_conf_dir}" -maxdepth 1 -type d -name "${ide_name}*")
      ide_conf_dir+=( "${ide_dir}" )
    done
elif [ "${OS}" == "Linux" ]; then
  usr_conf_dir="${HOME}"
  for i in "${IDE[@]}"
    do
      ide_name=".$i"  
      ide_dir=$(find "${usr_conf_dir}" -maxdepth 1 -type d -name "${ide_name}*")
      ide_conf_dir+=( "${ide_dir}/config" ) 
    done
fi

# Get current directory
DIR=$(dirname "$0")

for i in "${ide_conf_dir[@]}"
  do
    echo "${DIR}/intelliJPywalGen.sh" "$i";
  done

exit 0
