#!/usr/bin/env bash

# Attempts to retrieve wals colors
cache_dir="${HOME}/.cache/wal"

# Import colors
c=($(< "${cache_dir}/colors"))
c=("${c[@]//\#}")

# Set colors based on pywal
backgroundColor=${c[0]}
foregroundColor=${c[7]}
accentColor1=${c[1]}
accentColor2=${c[4]}

caretRowColor=${c[0]} # 0
lnColor=${c[0]} # 1

# Associative array for text replacement in template files
declare -A exp=( \
["leBG"]="${backgroundColor}" \
["leFG"]="${foregroundColor}" \
["leTXT"]="${foregroundColor}" \
["leSFG"]="${accentColor2}" \
["leSBG"]="${backgroundColor}" \
["leActive"]="${accentColor1}" \
["leBG2"]="${backgroundColor}" \
["leDisabled"]="${foregroundColor}" \
["leContrast"]="${accentColor1}" \
["leTblSel"]="${backgroundColor}" \
["leSBC"]="${accentColor1}" \
["leTree"]="${backgroundColor}" \
["leAccent"]="${accentColor2}" \
["leCROW"]="${caretRowColor}" \
["leLN"]="${lnColor}" )

# Get current Directory
DIR=$(dirname "$0")

# Paths to templates
templatePath=${DIR}/material_scheme_template_temp.xml
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
