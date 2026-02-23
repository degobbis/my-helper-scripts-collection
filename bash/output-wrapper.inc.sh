#!/usr/bin/env bash
###
# Include this script to get wrapper functions for the output on a terminal
#
# @created by Guido De Gobbis
# @license GNU GPL v3
###

DEBUG=1

# Usage of tput
#
# tput bold # Select bold mode
# tput dim  # Select dim (half-bright) mode
# tput smul # Enable underline mode
# tput rmul # Disable underline mode
# tput rev  # Turn on reverse video mode
# tput smso # Enter standout (bold) mode
# tput rmso # Exit standout mode
#
# tput setab [1-7] # Set the background colour using ANSI escape
# tput setaf [1-7] # Set the foreground colour using ANSI escape
# tput sgr0        # Reset text format to the terminal's default
# tput bel         # Play a bell
#
# Num  Colour
# 0    black
# 1    red
# 2    green
# 3    yellow
# 4    blue
# 5    magenta
# 6    cyan
# 7    white

error() { tput setaf 1; tput bold; echo "[X]" "$@"; tput sgr 0; tput bel; }
headline_e() { tput setaf 1; figlet -p "$@"; tput sgr 0; }
warn() { tput setaf 3; tput bold; echo "[!]" "$@"; tput sgr 0; }
headline() { tput setaf 6; figlet -p "$@"; tput sgr 0; }
success() { tput setaf 2; tput bold; echo "[✓]" "$@"; tput sgr 0; }
headline_s() { tput setaf 2; figlet -p "$@"; tput sgr 0; }
title() { tput setaf 6; tput bold; echo "::" "$@" "::"; tput sgr 0; }
info() { tput setaf 7; echo "->" "$@"; tput sgr 0; }


_checkCommandExists() {
    command -v "$1" >/dev/null
    return $?
}


# Expected values to pass:
# The download URL to the file.
#   --download-url='https://url.to/file.zip'
#
# The name to the target directory the file should be saved.
# The file name is kept, the directory is created if it does not exist.
#   --target-dir='myDirName'
#               Results in the target '/tmp/myDirName/file.zip'.
#
# Optional:
# The sha256sum checksum of the file.
#   --checksum='1496d7505f192bd98691135f364ffe3b4d4541b27c1391ac41e8694f83dda20d'
#
# If there is a signature file to download, add the option '--download-sig'

_downloadFileToTmp(){
  local downloadURL savePath filename file checksum sumcheck downloadSize localSize

  while [[ $# -gt 0 ]]; do
    case $1 in
      --download-url=*)
        downloadURL="$(echo $1 | cut -d '=' -f 2)"
        shift
        ;;
      --target-dir=*)
        savePath="$(echo $1 | cut -d '=' -f 2)"
        shift
        ;;
      --checksum=*)
        checksum="$(echo $1 | cut -d '=' -f 2)"
        shift
        ;;
      --download-sig)
          downloadSig=1
          shift
          ;;
      *)
        shift
        ;;
    esac
  done

  [[ -z $downloadURL ]] && { error "Missing URL to download the file!"; return 1; }

  savePath="/tmp/${savePath#/}"
  savePath="${savePath%/}"
  filename="$(basename $downloadURL)"
  file="$savePath/$filename"

  info "downloadURL: $downloadURL"
  info "savePath: $savePath"
  info "filename: $filename"
  info "file: $file"

  [[ ! -d $savePath ]] && mkdir -p $savePath


  title "Start download for: $downloadURL"
  if ! curl --progress-bar=dot --retry 3 --connect-timeout 15 -fLOC - $downloadURL --output-dir $savePath; then
      error "Download!"
      return 1
  fi

  success "Download."

  if [[ ! -z "$checksum" ]]; then
    sumcheck="$(echo "$checksum" "$file" | sha256sum -c 2>/dev/null | head -n 1 | awk '{printf $2}')"
    if [[ ! $? -eq 0 ]]; then
      error "Checksum validation!"
      return 1
    fi

    success "Checksum validation."
    sumcheck=1
  fi

  if [[ -z "$sumcheck" ]]; then
    downloadSize="$(curl --retry 3 --connect-timeout 15 -sL $downloadURL --output /dev/null --write-out '%{size_download}\n')"
    localSize="$(stat -c %s $file)"
    info "Filesize ONLINE: $downloadSize"
    info "Filesize LOCAL: $localSize"

    if [[ ! "$localSize" -eq "$downloadSize" ]]; then
      error "Filesize validation!"
      return 1
    else
      success "Filesize validation."
    fi
  fi

  if [[ "$downloadSig" -eq 1 ]]; then
    title "Start download from signature file: ${downloadURL}.sig"
    if ! curl --progress-bar=dot --retry 3 --connect-timeout 15 -fLOC - ${downloadURL}.sig --output-dir $savePath; then
      error "Download!"
    else
      success "Download."
    fi
  fi

  downloadedFileToTmp="$file"
  return 0
}

echo
#headline "Start script"

if ! _checkCommandExists _downloadFileToTmp; then
  error "Command _downloadFileToTmp not exists!"
  exit 1
fi

#_downloadFileToTmp \
#  --download-url='https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' \
#  --target-dir='/chaotic-aur' \
#  --download-sig \
#  --checksum='8d7af813b3ac75e7a037b941dc5d2ea2c3abb89a52aab73a6626acc596345311'

#info "Err-Stat: $?"
#info "downloadedFileToTmp: $downloadedFileToTmp"
#echo

#_downloadFileToTmp \
#  --download-url='https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
#  --download-sig \
#  --target-dir='chaotic-aur'

#info "Err-Stat: $?"
#info "downloadedFileToTmp: $downloadedFileToTmp"
#echo


headline "Headline"
headline "RE - Installation"
headline_e "Headline ERROR"
headline_s "Headline SUCCSESS"
error "Ein Fehler"
warn "Eine Warnung"
success "Alle OK"
title "Ein Titel"
info "Einfache information"


headline_e "Errors"
warn "Installation finished with errors"
info "The following packages had errors during installation"
echo
