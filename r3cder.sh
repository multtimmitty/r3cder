#!/bin/bash

export IFS='
'
# COLORS #
red="\e[01;31m"; green="\e[01;32m"; yellow="\e[01;33m";
blue="\e[01;34m"; purple="\e[01;35m"; cyan="\e[01;36m";
end="\e[00m";
# CUSTOM VARIABLES #
NBOX="${blue}[${cyan}*${blue}]${end}"
GBOX="${blue}[${green}+${blue}]${end}"
RBOX="${blue}[${red}-${blue}]${end}"

# FUNCTION TERMINANTE AND CANCEL
CTRL_C(){
  echo -e "\n${cyan}>>> ${red}Process Canceled ${cyan}<<<${end}\n"
  tput cnorm
  exit 0
}
FINISHED(){
  echo -e "\n${cyan}>>> ${red}finished Process ${cyan}<<<${end}\n"
  tput cnorm
  exit 0
}
trap CTRL_C INT
trap FINISHED SIGTERM

# HELP MENU #
HELP_MENU(){
  clear
  echo -e "${blue}Parameters:${end}"
  echo -e "${purple} -d \tSpecify a directory.${end}"
  echo -e "${purple} -h \tShow the help menu.${end}"
  echo -e "${purple}--help ${end}"
  echo -e "${blue}Use: ${cyan}./recderr.sh -d <Specific Directory>${end}"
}

# ANIMATION FUNCCTION #
ANIMATION(){
  declare -i local count=0
  while [[ ${count} -le 11 ]]; do
       sleep 0.2; echo -e "${end}.${end}\c"
       count=$[${count}+1]
  done
  echo
}

# RECDER FUNCTION #
RECDER(){
  local path="${1}"
  listFiles=$(ls -A ${path} 2>/dev/null)
  for file in ${listFiles}; do
     sleep 0.1
     if [[ -f ${path}/${file} ]]; then
       echo -e "${cyan}:> ${red}Corroding ${cyan}-> ${green}${file}${end}\c"
       `shred -fzun2 ${path}/${file} 2>/dev/null`
       if [[ $? -eq 0 ]]; then
         echo -e "${end} done ${end}"
       else
         echo -e "${red} failed ${end}"
         FINISHED
       fi
     else
       echo -e "${blue}:> ${cyan}${path}/${file}${end}"
       newPath="${path}/${file}"
       RECDER $newPath
     fi
  done
}

# MAIN FUNCTION #
if [[ $# -eq 2 ]]; then
  declare -i count=0
  while getopts ":d:h:" args; do
       case $args in
           d) pathDirectory=$OPTARG; let count+=1;;
           h) HELP_MENU
       esac
  done
  if [[ ${count} -ne 0 ]]; then
    clear; tput civis
    echo -e "${GBOX} ${yellow}Starting Process${end}\c";ANIMATION
    echo -e "${NBOX} ${yellow}Checking Directory \c";sleep 1.4
    if [[ -d ${pathDirectory} ]]; then
      echo -e "${green} done${end}";sleep 1
      echo -e "${NBOX} ${yellow}Checking Files in Directory${end}\c";sleep 1
      countFiles=$(ls ${pathDirectory}/* 2>/dev/null | wc -l)
      if [[ ${countFiles} -ne 0 ]]; then
        echo -e "${green} done ${end}";sleep 2
        clear
        RECDER $pathDirectory
      else
        echo -e "\n${red} There are no Files in the Directory${end}"
        FINISHED
      fi
    else
      echo -e "${red} ✘ ${end}";sleep 1
      echo -e "${red}Error Occurred, Check Directory${end}"
      FINISHED
    fi
    tput cnorm
  else
    HELP_MENU
  fi
else
  HELP_MENU
fi
