#!/bin/bash
set -e

BLUE='\033[0;34m'
NC='\033[0m'
WORKING_DIR=$(pwd)
YOUTUBE_FOLDER="${WORKING_DIR}/storage/shared/Youtube-DL"
YDL_CONFIG_DIR="${WORKING_DIR}/.config/youtube-dl"
YDL_CONFIG_FILE="${WORKING_DIR}/.config/youtube-dl/config"
BIN_FOLDER="${WORKING_DIR}/bin"
URL_OPENER="${WORKING_DIR}/bin/termux-url-opener"


echo "This script sets up an environment to download subtitles from Youtube videos"
sleep 1
echo ""
echo ""
echo -e "${BLUE}Requirements:"
echo -e "${NC}	1. Allow storage access to Termux"
echo -e "${NC}	2. A working internet connection."
echo ""
echo ""
echo -e "${BLUE}Process:"
echo -e "${NC}	1. Create folder for Youtube videos: ${YOUTUBE_FOLDER}"
echo -e "${NC}	2. Create youtube-dl configuration to save to above folder"
echo -e "${NC}	3. Create ${URL_OPENER} with script for downloading subtitles"
echo ""
echo ""
read -p "  When you are ready press enter"


termux-setup-storage
sleep 2
apt-get -y update
apt-get -y upgrade
apt autoremove
apt-get -y install python
pip install youtube-dl


mkdir "${YOUTUBE_FOLDER}"
mkdir -p "${YDL_CONFIG_DIR}"

touch "${YDL_CONFIG_FILE}"
echo -e "--no-mtime\n-o /data/data/com.termux/files/home/storage/shared/Youtube-DL/%(title)s.%(ext)s" >> "${YDL_CONFIG_FILE}"

mkdir "${BIN_FOLDER}"
touch "${URL_OPENER}"
cat > "${URL_OPENER}" <<'EOF'
#!/bin/bash
downloadSubtitle(){
  echo -e "youtube-dl:\\n>Getting sub list for ${1}\\n"
  cmd_result=$(youtube-dl --list-subs "${1}")

  if [[ $(echo "${cmd_result}" | wc -l) -eq 2 ]]; then
    echo "seems video has no subtitles sorry :("
    read -p "press enter to exit"
    return
  else
    if [[ "${cmd_result}" =~ ^.*Available\ automatic\ captions\ for.*$ && \
      "${cmd_result}" =~ ^.*Available\ subtitles\ for.*$ ]]; then
      echo "${cmd_result}"
      echo
      echo "both manual subs and auto captions exist, please specify which list the language is in." 
      read -p "is the language in the auto captions list? [y/N] " choice
      read -p "language?: " lang
      if [[ "${choice}" == "y" ]]; then
        youtube-dl --write-auto-sub --sub-lang "${lang}" --skip-download "${1}"
      else
        youtube-dl --write-sub --sub-lang "${lang}" --skip-download "${1}"
      fi
    elif [[ "${cmd_result}" =~ ^.*Available\ automatic\ captions\ for.*$ && \
      "${cmd_result}" =~ ^.*has\ no\ subtitles.*$ ]]; then
      echo "${cmd_result}" | grep ,
      read -p "language?: " lang
      youtube-dl --write-auto-sub --sub-lang "${lang}" --skip-download "${1}"
    elif [[ "${cmd_result}" =~ ^.*Available\ subtitles\ for.*$ ]]; then
      echo "${cmd_result}" | grep ,
      read -p "language?: " lang
      youtube-dl --write-sub --sub-lang "${lang}" --skip-download "${1}"
    else
      echo "error: subtitle retrieval error :("
    fi
  fi
}

if [[ $1 =~ ^.*youtu.*$ ]] || [[ $1 =~ ^.*youtube.*$ ]]; then
  downloadSubtitle "${1}"
elif [[ $1 =~ ^.*nourlselected.*$ ]]; then
  echo "error: nourlselected"
else
  echo "error: <shrugs>"
fi
EOF

echo -e "${BLUE}Congratulations!!! Your setup is complete."
echo ""
echo ""
read -p "When you are ready press enter"
