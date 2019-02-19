#!/bin/bash
#
# Copyright (C) 2018 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_world_package_info() {
    ptxd_make_world_init || return
    do_echo() {
	if [ -n "${!#}" ]; then
	    if [ ${#} -gt 1 ]; then
		printf "%-13s %s\n" "${1}" "${2}"
	    else
		echo
	    fi
	fi
    }
    if [ -z "${pkg_version}" -a -z "${image_image}" ]; then
	ptxd_bailout "'${pkg_label}' is not a valid package"
    fi
    do_echo "package:" "${pkg_label}"
    do_echo "version:" "${pkg_version}"
    do_echo "image:" "$(ptxd_print_path "${image_image}")"
    echo

    do_echo "config:" "$(ptxd_print_path "${pkg_config}")"
    do_echo "ref config:" "$(ptxd_print_path "${pkg_ref_config}")"
    do_echo "${pkg_config}"

    do_echo "license:" "${pkg_license}"
    do_echo "  files:" "${pkg_license_files}"
    do_echo "${pkg_license}"

    do_echo "source:" "$(ptxd_print_path "${pkg_src}")"
    do_echo "md5:" "${pkg_md5}"
    do_echo "url:" "${pkg_url}"
    do_echo "${pkg_src}${pkg_url}"

    do_echo "src dir:" "$(ptxd_print_path "${pkg_dir}")"
    do_echo "build dir:" "$(ptxd_print_path "${pkg_build_dir}")"
    do_echo "pkg dir:" "$(ptxd_print_path "${pkg_pkg_dir}")"
    do_echo "${pkg_dir}${pkg_pkg_dir}"

    do_echo "rule file:" "$(ptxd_print_path "${pkg_makefile}")"
    do_echo "menu file:" "$(ptxd_print_path "${pkg_infile}")"
    echo

    do_echo "patches:" "$(ptxd_print_path "${pkg_patch_dir}")"
    do_echo "${pkg_patch_dir}"

    do_echo "build deps:" "${pkg_build_deps}"
    do_echo "runtime deps:" "${pkg_run_deps}"
    do_echo "${pkg_build_deps}${pkg_run_deps}"

    do_echo "pkgs:" "${image_pkgs}"
    do_echo "${image_pkgs}"
}
export -f ptxd_make_world_package_info
