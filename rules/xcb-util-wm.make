# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XCB_UTIL_WM) += xcb-util-wm

#
# Paths and names
#
XCB_UTIL_WM_VERSION	:= 0.4.1
XCB_UTIL_WM_MD5		:= 87b19a1cd7bfcb65a24e36c300e03129
XCB_UTIL_WM		:= xcb-util-wm-$(XCB_UTIL_WM_VERSION)
XCB_UTIL_WM_SUFFIX	:= tar.bz2
XCB_UTIL_WM_URL		:= https://xcb.freedesktop.org/dist/$(XCB_UTIL_WM).$(XCB_UTIL_WM_SUFFIX)
XCB_UTIL_WM_SOURCE	:= $(SRCDIR)/$(XCB_UTIL_WM).$(XCB_UTIL_WM_SUFFIX)
XCB_UTIL_WM_DIR		:= $(BUILDDIR)/$(XCB_UTIL_WM)
XCB_UTIL_WM_LICENSE	:= X11

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
XCB_UTIL_WM_CONF_TOOL	:= autoconf
XCB_UTIL_WM_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-selective-werror \
	--disable-strict-compilation \
	--disable-devel-docs \
	--without-doxygen

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xcb-util-wm.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xcb-util-wm)
	@$(call install_fixup, xcb-util-wm,PRIORITY,optional)
	@$(call install_fixup, xcb-util-wm,SECTION,base)
	@$(call install_fixup, xcb-util-wm,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, xcb-util-wm,DESCRIPTION,missing)

	@$(call install_lib, xcb-util-wm, 0, 0, 0644, libxcb-ewmh)
	@$(call install_lib, xcb-util-wm, 0, 0, 0644, libxcb-icccm)

	@$(call install_finish, xcb-util-wm)

	@$(call touch)

# vim: syntax=make
