#!/usr/bin/env bash

## intelliJPywal/launch.sh
## author: Richard Loveless III (RLovelessIII)
## description: launch script for IntelliJPywal

# JetBrains IDE's to search for
IDE=( "IntelliJIdea" "PyCharm" "WebStorm" )

# Get current Operating System
OS=$(uname)

###############################################################
#  usr_conf_dir  <-- Parent folder to search for directories  #
#  ide_name      <-- Name of JB ide from $IDE array           #
#  ide_dir       <-- Path to IDE directory                    #
#  ide_conf_dir  <-- Path to IDE config directory             #
###############################################################

# MacOS
if [ "${OS}" == "Darwin" ]; then
  # Default location for JB IDE settings/configs on MACOS
  usr_conf_dir="${HOME}/Library/Preferences"
  for i in "${IDE[@]}"
    do
      ide_name="$i"
      # -maxdepth  <-- Default: 1       -      Only searches through first layer
      # -type      <-- Default: d       -      Searches directories only
      # -name      <-- Default: ${ide_name}* - * is used as a wildcard since JB uses the version number while naming the config directory
      ide_dir=$(find "${usr_conf_dir}" -maxdepth 1 -type d -name "${ide_name}*")
      # Add the directory (if found) to the array
      ide_conf_dir+=( "${ide_dir}" )
    done
# Linux Distributions
elif [ "${OS}" == "Linux" ]; then
  # Default location for JB IDE settings/configs on Linux (manjaro-i3 tested)
  usr_conf_dir="${HOME}"
  for i in "${IDE[@]}"
    do
      ide_name=".$i" # Prepend a '.' to search for hidden directories on Linux
      # -maxdepth  <-- Default: 1       -      Only searches through first layer
      # -type      <-- Default: d       -      Searches directories only
      # -name      <-- Default: ${ide_name}* - * is used as a wildcard since JB uses the version number while naming the config directory
      ide_dir=$(find "${usr_conf_dir}" -maxdepth 1 -type d -name "${ide_name}*")
      # Add the directory (if found) to the array
      # '/config' path is added for Linux distributions
      ide_conf_dir+=( "${ide_dir}/config" ) 
    done
fi

# Get current directory
DIR=$(dirname "$0")

# Loop through and execute intellijPywalGen.sh for each IDE config path
for path in "${ide_conf_dir[@]}"
  do
    "${DIR}"/intellijPywalGen.sh "${path}"
  done

exit 0
