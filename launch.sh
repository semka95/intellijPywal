#!/usr/bin/env bash

## intelliJPywal/lanuch.sh
## author: Richard Loveless III (RLovelessIII)
## description: lanuch script for IntelliJPywal

# Supported IDE's
IDE=( "IntelliJIdea" "PyCharm" "WebStorm" )

# Get current Operating System
OS=$(uname)

if [ "${OS}" == "Darwin" ]; then
  config_dir="${HOME}"/Library/Preferences
elif [ "${OS}" == "Linux" ]; then
  config_dir="${HOME}"
fi

for i in "${!IDE[@]}"
  do
    ide_config_dir=$(find "${config_dir}" -maxdepth 1 -type d -name "\.${IDE[$i]}*")
    echo ${ide_config_dir}
  done

exit 0
