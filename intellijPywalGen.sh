#!/usr/bin/env bash

# Attempts to retrieve wals colors
cache_dir="${HOME}/.cache/wal"

# Import colors
c=($(< "${cache_dir}/colors"))
c=("${c[@]//\#}")

# Set colors based on pywal
backgroundColor=${c[0]}
foregroundColor=${c[15]}
baseColor=${c[1]}
contrastColor=${c[6]}
accentColor=${c[4]}

# Associative array for text replacement in template files
declare -A exp=( \
["leBG"]="${backgroundColor}" \
["leFG"]="${foregroundColor}" \
["leTXT"]="${foregroundColor}" \
["leSFG"]="${foregroundColor}" \
["leSBG"]="${backgroundColor}" \
["leActive"]="${baseColor}" \
["leBG2"]="${baseColor}" \
["leDisabled"]="${foregroundColor}" \
["leContrast"]="${contrastColor}" \
["leTblSel"]="${baseColor}" \
["leSBC"]="${baseColor}" \
["leTree"]="${baseColor}" \
["leNotification"]="${backgroundColor}"
["leAccent"]="${accentColor}" \
["leCaret"]="${contrastColor}"
["leCROW"]="${backgroundColor}" \
["leLN"]="${contrastColor}" \
["leLN2"]="${accentColor}" \
["leVCSNC"]="999999" \
)



# Get current Directory
DIR=$(dirname "$0")

# Paths to templates
templatePath=${DIR}/material_scheme_template.xml
materialTPath=${DIR}/material_template.xml

# Read input param
ijConfigPath=$1

# Paths to IDE
ijCfPath=$ijConfigPath/colors/material-pywal.icls
ijMPath=$ijConfigPath/options/material_custom_theme.xml

# Override existing config
cp -f "$templatePath" "$ijCfPath"
cp -f "$materialTPath" "$ijMPath"

# Get current OS
OS=$(uname)

# Replace placeholders for colors
if [ "${OS}" == 'Darwin' ]; then
  for key in "${!exp[@]}"
  do
    text_replace="s/$key/${exp[$key]}/g"
    sed -i '' "$text_replace" "$ijCfPath"
    sed -i '' "$text_replace" "$ijMPath"
  done
elif [ "${OS}" == "Linux" ]; then
  for key in "${!exp[@]}"
  do
    text_replace="s/$key/${exp[$key]}/g"
    sed -i "$text_replace" "$ijCfPath"
    sed -i "$text_replace" "$ijMPath"
  done
fi

exit 0
