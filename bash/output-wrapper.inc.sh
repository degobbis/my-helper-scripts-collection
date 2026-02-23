#!/bin/bash

###
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Guido De Gobbis
# License-Text: See LICENSES/MIT.txt
###


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
