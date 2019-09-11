#!/bin/bash
#
# Copyright (C) 2017 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

PTXDIST_MESON_CROSS_FILE="${PTXDIST_GEN_CONFIG_DIR}/cross-file.meson"
export PTXDIST_MESON_CROSS_FILE

#
# generate meson cross file from template
#
# $1:	meson cross file
#
ptxd_make_meson_cross_file() {
    local ptxd_reply
    ptxd_get_alternative config meson/cross-file.meson.in &&
    CPU="$(ptxd_cross_cc_v | sed -n -e "s/.*'-march=\([^']*\).*/\1/p" -e "/-march=/q")" \
	ptxd_replace_magic "${ptxd_reply}" > "${1}"
}
export -f ptxd_make_meson_cross_file
