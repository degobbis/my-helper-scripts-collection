#!/bin/bash

###
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Guido De Gobbis
# License-Text: See LICENSES/MIT.txt
###


if [[ "$(dirname $0)" == "." ]]; then
    INC_DIR="../bash"
else
    INC_DIR="./bash"
fi


# Include the output wrapper
source $INC_DIR/output-wrapper.inc.sh

# Use the wrappers
headline "Headline"
headline_e "Headline ERROR"
headline_s "Headline SUCCSESS"
error "An error!"
warn "A warning!"
success "All is OK (success)."
title "A title"
info "A simple information output."
