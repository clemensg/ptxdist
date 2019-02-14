# -*-makefile-*-
#
# Copyright (C) 2016 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_WAYLAND_PROTOCOLS) += wayland-protocols

#
# Paths and names
#
WAYLAND_PROTOCOLS_VERSION	:= 1.17
WAYLAND_PROTOCOLS_MD5		:= 55ddd5fdb02b73b9de9559aaec267315
WAYLAND_PROTOCOLS		:= wayland-protocols-$(WAYLAND_PROTOCOLS_VERSION)
WAYLAND_PROTOCOLS_SUFFIX	:= tar.xz
WAYLAND_PROTOCOLS_URL		:= https://wayland.freedesktop.org/releases/$(WAYLAND_PROTOCOLS).$(WAYLAND_PROTOCOLS_SUFFIX)
WAYLAND_PROTOCOLS_SOURCE	:= $(SRCDIR)/$(WAYLAND_PROTOCOLS).$(WAYLAND_PROTOCOLS_SUFFIX)
WAYLAND_PROTOCOLS_DIR		:= $(BUILDDIR)/$(WAYLAND_PROTOCOLS)
WAYLAND_PROTOCOLS_LICENSE	:= MIT

#
# autoconf
#
WAYLAND_PROTOCOLS_CONF_TOOL	:= autoconf

# vim: syntax=make
