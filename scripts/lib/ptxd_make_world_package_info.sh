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
    # use patchin_init for  pkg_patch_dir
    ptxd_make_world_patchin_init || return
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

ptxd_make_bsp_info() {
    ptxd_make_world_init || return
    do_echo() {
	if [ -n "${!#}" ]; then
	    if [ ${#} -gt 1 ]; then
		printf "%-17s %s\n" "${1}" "${2}"
	    else
		echo
	    fi
	fi
    }
    do_echo "vendor:" "$(ptxd_get_ptxconf PTXCONF_PROJECT_VENDOR)"
    do_echo "project:" "$(ptxd_get_ptxconf PTXCONF_PROJECT)"
    do_echo "version:" "$(ptxd_get_ptxconf PTXCONF_PROJECT_VERSION)"
    echo
    do_echo "platform:" "$(ptxd_get_ptxconf PTXCONF_PLATFORM)"
    do_echo "platform version:" "$(ptxd_get_ptxconf PTXCONF_PLATFORM_VERSION)"
    echo

    for layer in "${PTXDIST_LAYERS[@]}"; do
	if [ "${layer}" = "${PTXDIST_WORKSPACE}" ]; then
	    do_echo "BSP:" "${layer}"
	elif [ "${layer}" = "${PTXDIST_TOPDIR}" ]; then
	    do_echo "PTXdist:" "${layer}"
	elif [ -h "${layer}" ]; then
	    do_echo "Layer:" "$(ptxd_print_path "${layer}") -> $(ptxd_print_path "$(readlink "${layer}")")"
	else
	    do_echo "Layer:" "$(ptxd_print_path "${layer}")"
	fi
    done
    echo

    do_echo "ptxconfig:" "$(ptxd_print_path "${PTXDIST_PTXCONFIG}")"
    do_echo "platformconfig:" "$(ptxd_print_path "${PTXDIST_PLATFORMCONFIG}")"
    do_echo "collectionconfig:" "$(ptxd_print_path "${PTXDIST_COLLECTIONCONFIG}")"
    echo

    prefix="images:"
    for image in ${bsp_images}; do
	do_echo "${prefix}" "${image}"
	unset prefix
    done
    echo
}
export -f ptxd_make_bsp_info
