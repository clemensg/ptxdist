# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XCB_UTIL_RENDERUTIL) += xcb-util-renderutil

#
# Paths and names
#
XCB_UTIL_RENDERUTIL_VERSION	:= 0.3.9
XCB_UTIL_RENDERUTIL_MD5		:= 468b119c94da910e1291f3ffab91019a
XCB_UTIL_RENDERUTIL		:= xcb-util-renderutil-$(XCB_UTIL_RENDERUTIL_VERSION)
XCB_UTIL_RENDERUTIL_SUFFIX	:= tar.bz2
XCB_UTIL_RENDERUTIL_URL		:= https://xcb.freedesktop.org/dist/$(XCB_UTIL_RENDERUTIL).$(XCB_UTIL_RENDERUTIL_SUFFIX)
XCB_UTIL_RENDERUTIL_SOURCE	:= $(SRCDIR)/$(XCB_UTIL_RENDERUTIL).$(XCB_UTIL_RENDERUTIL_SUFFIX)
XCB_UTIL_RENDERUTIL_DIR		:= $(BUILDDIR)/$(XCB_UTIL_RENDERUTIL)
XCB_UTIL_RENDERUTIL_LICENSE	:= X11

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
XCB_UTIL_RENDERUTIL_CONF_TOOL	:= autoconf
XCB_UTIL_RENDERUTIL_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-selective-werror \
	--disable-strict-compilation \
	--disable-devel-docs \
	--without-doxygen

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xcb-util-renderutil.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xcb-util-renderutil)
	@$(call install_fixup, xcb-util-renderutil,PRIORITY,optional)
	@$(call install_fixup, xcb-util-renderutil,SECTION,base)
	@$(call install_fixup, xcb-util-renderutil,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, xcb-util-renderutil,DESCRIPTION,missing)

	@$(call install_lib, xcb-util-renderutil, 0, 0, 0644, libxcb-render-util)

	@$(call install_finish, xcb-util-renderutil)

	@$(call touch)

# vim: syntax=make
