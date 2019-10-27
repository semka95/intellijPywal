#!/usr/bin/env bash

# Get current directory
DIR=$(dirname "$0")

# Paths to templates
templatePath="${DIR}/material_scheme_template.xml"
materialTPath="${DIR}/material_template.xml"

# Read input param
if [[ -d "${1}/config" ]]; then
  ijConfigPath="${1}/config"
elif [[ -d "${1}" ]]; then
  ijConfigPath="${1}"
else
  echo "Error: JetBrains IDE config path (${1}) NOT FOUND" && exit 1
fi

# Create colors directory if directory not found
if [[ ! -d ${ijConfigPath}/colors ]]; then
  mkdir "${ijConfigPath}"/colors
fi

# Paths to IDE theme files
ijCfPath="${ijConfigPath}/colors/material-pywal.icls"
ijMPath="${ijConfigPath}/options/material_custom_theme.xml"

# Override existing config
cp -f "$templatePath" "$ijCfPath"
cp -f "$materialTPath" "$ijMPath"

# Source config file
. "${DIR}/config"

# Color-scheme directory
wal_cache_dir="${HOME}/.cache/wal"

# Decide what colors to use for theme
if [[ "${USE_WAL_COLORS}" == "true" && -d ${wal_cache_dir} ]]; then
    # Import colors
    c=($(< "${wal_cache_dir}/colors"))
    c=("${c[@]//\#}")
else
  # Retrieves colors from config file
  c=("${color[@]}")
fi

########################
## THEME COLOR-SCHEME ##
########################

# Main window colors
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

# Independent colors - Set in config file
disabledColor=${disabled_color}
fileNotChangedColor=${file_not_changed_color}

# Associative array for text replacement in template files
declare -A exp=( \
["leBG"]="${backgroundColor}" \
["leFG"]="${foregroundColor}" \
["leTXT"]="${foregroundColor}" \
["leSFG"]="${foregroundColor}" \
["leSBG"]="${primaryColor}" \
["leActive"]="${primaryColor}" \
["leBG2"]="${secondaryColor}" \
["leDisabled"]="${disabledColor}" \
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
["leVCSNC"]="${fileNotChangedColor}" \
)

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
