#!/bin/bash
#
# Copyright (C) 2018 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_validate_collection() {
    local file_dotconfig relative_file_dotconfig
    ptxd_make_world_init || return

    exec 2>&1 >/dev/null
    for file_dotconfig in ${ptx_collections}; do
	ptxd_normalize_config &&
	ptxd_kconfig_setup_config run "${PTXDIST_TEMPDIR}/.collection-config" \
	    "${relative_file_dotconfig}" "${file_dotconfig}"
    done
}
export -f ptxd_make_validate_collection
