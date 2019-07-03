#!/bin/bash
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_execute_impl() {
    local -a cmd
    if [ "${pkg_stage}" != "install" -o \
	    ! -e "${ptx_state_dir}/host-fakeroot.install.post" ]; then
	local echo="eval"
	local fakeroot="cat"
    fi

    if [ -z "${pkg_execute_cmd}" ]; then
	ptxd_bailout "execute: missing command"
    fi

    cmd=( \
	    cd "${pkg_build_dir}" '&&' \
	    "${pkg_path}" \
	    "${pkg_env}" \
    )
    case "${pkg_stage}" in
	prepare)
	    cmd[${#cmd[@]}]="${pkg_conf_env}"
	    ;;
	compile)
	    cmd[${#cmd[@]}]="${pkg_make_env}"
	    ;;
	install)
	    cmd[${#cmd[@]}]="${pkg_make_env}"
	    cmd[${#cmd[@]}]="${pkg_install_env}"
	    ;;
    esac
    cmd[${#cmd[@]}]="${pkg_execute_cmd}"


    ptxd_verbose "executing:" "${cmd[@]}
" &&
    "${echo:-echo}" \
	"${cmd[@]}" \
	| "${fakeroot:-fakeroot}" "${fakeargs[@]}" --
    check_pipe_status
}
export -f ptxd_make_execute_impl

ptxd_make_execute() {
    ptxd_make_world_init &&
    ptxd_make_execute_impl
}
export -f ptxd_make_execute


ptxd_make_world_execute() {
    ptxd_make_world_init &&

    case "${pkg_stage}" in
	prepare)
	    ptxd_make_world_prepare_init
	    ;;
	install)
	    ptxd_make_world_install_prepare
	    ;;
    esac &&

    ptxd_make_execute_impl
}
export -f ptxd_make_world_execute
