#!/bin/bash

###
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Guido De Gobbis
# License-Text: See LICENSES/MIT.txt
###


# Include the output wrapper
source ./bash/output-wrapper.inc.sh

# Use the wrappers
headline "Headline"
headline_e "Headline ERROR"
headline_s "Headline SUCCSESS"
error "An error!"
warn "A warning!"
success "All is OK (success)."
title "A title"
info "A simple information output."
