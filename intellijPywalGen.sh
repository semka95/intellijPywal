#!/usr/bin/env bash
# value=\"(\K[a-f0-9]{6})
# (?sm)(^[^\r\n]+$)(?!.*^\1$)

# Attempts to retrieve wals colors
cache_dir="${HOME}/.cache/wal"

# Import colors
c=($(< "${cache_dir}/colors"))
c=("${c[@]//\#}")

# Set colors based on pywal
txtColor=${c[15]}
bgColor=${c[0]}
sbgColor=${c[1]}
sfgColor=${c[0]}
caretRowColor=${sfgColor}
lnColor=${c[1]}
fgColor=${c[15]}
bg2Color=${c[1]}
contrastColor=${c[1]}
sbColor=${c[1]}
treeColor=${c[15]}
disabledColor=${c[15]}
activeColor=${c[2]}

# Associative array for text replacement in template files
declare -A exp=( \
["leTXT"]="${txtColor}" \
["leBG"]="${bgColor}" \
["leSFG"]="${sfgColor}" \
["leSBG"]="${sbgColor}" \
["leCROW"]="${caretRowColor}" \
["leLN"]="${lnColor}" \
["leFG"]="${fgColor}" \
["leBG2"]="${bg2Color}" \
["leContrast"]="${contrastColor}" \
["leSBC"]="${sbColor}" \
["leTree"]="${treeColor}" \
["leDisabled"]="${disabledColor}" \
["leActive"]="${activeColor}" )

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
else
  for key in "${!exp[@]}"
  do
    text_replace="s/$key/${exp[$key]}/g"
    sed -i "$text_replace" "$ijCfPath"
    sed -i "$text_replace" "$ijMPath"
  done
fi

exit 0
