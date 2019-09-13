#!/bin/bash
#
# Copyright (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_world_clean_sysroot() {
    local link source
    link="${ptx_pkg_dir}/.${pkg_label}"
    if [ -d "${link}" ]; then
	path="${link}"
    else
	path="${pkg_pkg_dir}"
    fi
    if [ -d "${path}" ]; then
	echo "Removing files from sysroot..."
	echo
	find "${path}/" ! -type d -printf "${pkg_sysroot_dir}/%P\0" | \
	    xargs -0 rm -f
	find "${path}/" -mindepth 1 -depth -type d -printf "${pkg_sysroot_dir}/%P\0" | \
	    xargs -0 rmdir --ignore-fail-on-non-empty 2> /dev/null
    fi
    if [ -h "${link}" ]; then
	rm "${link}"
    fi
}
export -f ptxd_make_world_clean_sysroot

#
# clean
#
ptxd_make_world_clean() {
    ptxd_make_world_init &&

    if [ -f "${pkg_xpkg_map}" ]; then
	echo "Deleting ipks:"
	for name in $(< "${pkg_xpkg_map}"); do
	    ls "${ptx_pkg_dir}/${name}"{,-dbgsym}_*.ipk 2>/dev/null
	    rm -f "${ptx_pkg_dir}/${name}"{,-dbgsym}_*.ipk
	done
	echo
    fi
    if [ -n "$(ls "${ptx_state_dir}/${pkg_label}".* 2> /dev/null)" ]; then
	echo "Deleting stage files:"
	if [ -e "${pkg_xpkg_map}" ]; then
	    for name in $(< "${pkg_xpkg_map}"); do
		ls "${ptx_state_dir}/${name}".*
		rm -f "${ptx_state_dir}/${name}".*
	    done
	fi
	ls "${ptx_state_dir}/${pkg_label}".* 2>/dev/null
	rm -f "${ptx_state_dir}/${pkg_label}".*
	echo
    fi
    if [ -d "${pkg_dir}" -o -L "${pkg_dir}" ]; then
	echo "Deleting src dir:"
	echo "${pkg_dir}"
	rm -rf "${pkg_dir}"
	echo
    fi
    if [ -d "${pkg_build_dir}" ]; then
	echo "Deleting build dir:"
	echo "${pkg_build_dir}"
	rm -rf "${pkg_build_dir}"
	echo
    fi
    ptxd_make_world_clean_sysroot
    if [ -d "${pkg_pkg_dir}" ]; then
	echo "Deleting pkg dir:"
	echo "${pkg_pkg_dir}"
	rm -rf "${pkg_pkg_dir}"
	echo
    fi
    local pkgs="${pkg_pkg_dev%-*-dev.tar.gz}-*-dev.tar.gz"
    if [ -n "$(ls "${ptx_pkg_dir}/"${pkgs} 2> /dev/null)" ]; then
	echo "Deleting dev packages:"
	ls "${ptx_pkg_dir}/"${pkgs}
	rm "${ptx_pkg_dir}/"${pkgs}
    fi
}
export -f ptxd_make_world_clean

