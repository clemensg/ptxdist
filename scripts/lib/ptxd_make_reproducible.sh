#!/bin/bash
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_timestamp_ptxdist() {
    ptxd_reply="${PTXDIST_VERSION_YEAR}-${PTXDIST_VERSION_MONTH}-01 UTC"
}

ptxd_timestamp_toolchain() {
    local oselas_ptxconfig="$(readlink -f "${PTXDIST_TOOLCHAIN}/ptxconfig")"

    if [ -e "${oselas_ptxconfig}" ]; then
	local oselas_version="$(ptxd_get_kconfig "${oselas_ptxconfig}" PTXCONF_CONFIGFILE_VERSION)"
	local orig_IFS="${IFS}"
	local IFS="."
	set -- ${oselas_version}
	IFS="${orig_IFS}"
	ptxd_reply="${1}-${2}-01 UTC"
    else
	ptxd_bailout "Cannot deduce timestamp from the toolchain version." \
	    "REPRODUCIBLE_TIMESTAMP_TOOLCHAIN cannot be used."
    fi
}

ptxd_timestamp_custom() {
    local ts="$(ptxd_get_ptxconf PTXCONF_REPRODUCIBLE_TIMESTAMP_STRING)"

    if [ -z "${ts}" ] || ! date --date "${ts}" &> /dev/null; then
	ptxd_bailout "'${ts}' is not a valid timestamp," \
	    'REPRODUCIBLE_TIMESTAMP_STRING must be a valid argument for `date --date`'
    else
	ptxd_reply="${ts}"
    fi
}

ptxd_make_reproducible() {
    local reproducible="$(ptxd_get_ptxconf PTXCONF_REPRODUCIBLE_TIMESTAMP)"
    reproducible="${reproducible:-ptxdist}"

    ptxd_timestamp_${reproducible}

    if [ -z "${ptxd_reply}" ]; then
	# don't set SOURCE_DATE_EPOCH continue to allow
	# 'ptxdist menuconfig'. ptxd_make_reproducible() will abort later
	# if necessary
	return
    fi

    if [ "${PTXCONF_SETUP_DISABLE_REPRODUCIBLE}" = "y" ]; then
	SOURCE_DATE_EPOCH="$(echo $(date "+%s"))"
    else
	SOURCE_DATE_EPOCH="$(echo $(date --date="${ptxd_reply}" "+%s"))"
    fi
    export SOURCE_DATE_EPOCH

    PTXDIST_BUILD_TIMESTAMP="$(echo $(date --utc --date @${SOURCE_DATE_EPOCH} +%Y-%m-%dT%H:%M+0000))"
    export PTXDIST_BUILD_TIMESTAMP
}
export -f ptxd_make_reproducible

ptxd_make_reproducible
