#!/usr/bin/env bash

# Get current directory
DIR=$(dirname "$0")
# Source config file
. "${DIR}/config"

# Pywal cache directory
cache_dir="${HOME}/.cache/wal"

# Decide what colors to use for theme
if [[ "${USE_WAL_COLORS}" == "TRUE" && -d "${cache_dir}" ]]; then
    # Import colors
    c=($(< "${cache_dir}/colors"))
    c=("${c[@]//\#}")
else
  # Retrieves colors from config file
  c=("${color[@]}")
fi

# Theme colors
backgroundColor=${c[0]}
foregroundColor=${c[15]}
primaryColor=${c[1]}
secondaryColor=${c[2]}
contrastColor=${c[3]}
accentColor=${c[4]}

# Editor/text colors
stringColor=${c[5]}
tagColor=${c[6]}
attributeColor=${c[7]}
paramColor=${c[8]}

# Associative array for text replacement in template files
declare -A exp=( \
["leBG"]="${backgroundColor}" \
["leFG"]="${foregroundColor}" \
["leTXT"]="${foregroundColor}" \
["leSFG"]="${foregroundColor}" \
["leSBG"]="${backgroundColor}" \
["leActive"]="${primaryColor}" \
["leBG2"]="${secondaryColor}" \
["leDisabled"]="${foregroundColor}" \
["leContrast"]="${contrastColor}" \
["leTblSel"]="${primaryColor}" \
["leSBC"]="${primaryColor}" \
["leTree"]="${primaryColor}" \
["leNotification"]="${backgroundColor}"
["leAccent"]="${accentColor}" \
["leCaret"]="${contrastColor}"
["leCROW"]="${backgroundColor}" \
["leLN"]="${contrastColor}" \
["leLN2"]="${accentColor}" \
["leString"]="${stringColor}" \
["leAttribute"]="${attributeColor}" \
["leTag"]="${tagColor}" \
["leParam"]="${paramColor}" \
["leVCSNC"]="999999" \
)

# Paths to templates
templatePath="${DIR}/material_scheme_template.xml"
materialTPath="${DIR}/material_template.xml"

# Read input param
if [[ -d "${1}" ]]; then
  ijConfigPath=${1}
else
  echo "JetBrains IDE config path (${1}) NOT FOUND" && exit 1
fi

# Paths to IDE
ijCfPath=$ijConfigPath/colors/material-pywal.icls
ijMPath=$ijConfigPath/options/material_custom_theme.xml

# Create colors directory if directory not found
if [[ ! -d ${ijConfigPath}/colors ]]; then
  mkdir "${ijConfigPath}"/colors
fi

# Override existing config
cp -f "$templatePath" "$ijCfPath"
cp -f "$materialTPath" "$ijMPath"

# Get current OS
OS=$(uname)

# Replace placeholders for colors
if [ "${OS}" == "Darwin" ]; then
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
