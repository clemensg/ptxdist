#!/bin/bash
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_clean() {
    local directory="${1}"

    if [ -e "${directory}" ]; then
	if [ -h "${directory}" ! -d "${directory}" ]; then
	    rm -f "${directory}"
	elif [ -n "${PTXDIST_FORCE}" ]; then
	    : # always delete with --force
	elif [ -d "${directory}/.git" ]; then
	    ptxd_bailout "Refusing to delete git repository" \
		"$(ptxd_print_path "${directory}")" \
		"Delete anyways with --force."
	fi
	rm -rf "${directory}"
    fi
}
export -f ptxd_make_clean
