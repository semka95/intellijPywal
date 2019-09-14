#!/usr/bin/env bash
# value=\"(\K[a-f0-9]{6})
# (?sm)(^[^\r\n]+$)(?!.*^\1$)


# Attempts to retrieve wals colors
cache_dir="${HOME}/.cache/wal"
# Import colors
c=($(< "${cache_dir}/colors"))
c=("${c[@]//\#}")

# Read input param
ijConfigPath=$1

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

# Get current Directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Paths to templates
templatePath=$DIR\/material_scheme_template.xml
materialTPath=$DIR\/material_template.xml

# Paths to IDE
ijCfPath=$ijConfigPath/colors/material-pywal.icls
ijMPath=$ijConfigPath/options/material_custom_theme.xml

# Override existing config
cp -f $templatePath $ijCfPath
cp -f $materialTPath $ijMPath

######################
## RLovelessIII WIP ##
######################

# Replace placeholders for colors
exp0=s/leTXT/$txtColor/g
exp1=s/leBG/$bgColor/g

# Selection/Highlight colors
exp2=s/leSFG/$sfgColor/g
exp3=s/leSBG/$sbgColor/g
exp4=s/leCROW/$caretRowColor/g
exp5=s/leLN/$lnColor/g
exp6=s/leFG/$fgColor/g
exp7=s/leBG2/$bg2Color/g
exp8=s/leContrast/$contrastColor/g
exp9=s/leSBC/$sbColor/g
exp10=s/leTree/$treeColor/g
exp11=s/leDisabled/$disabledColor/g
exp12=s/leActive/$activeColor/g

exp=( $exp0 $exp1 $exp2 $exp3 $exp4 $exp5 $exp6 $exp7 $exp8 $exp9 $exp10 $exp11 $exp12 )

# Get current OS
OS=$(uname);


if [ ${OS} == 'Darwin' ]; then
  for i in "${exp[@]}"
  do 
    sed -i '' $i $ijCfPath
    sed -i '' $i $ijMPath
  done
else
  for i in "${exp[@]}"
  do
    sed -i $i $ijCfPath
    sed -i $i $ijMPath
  done
fi

exit 0
