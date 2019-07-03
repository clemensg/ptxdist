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
PACKAGES-$(PTXCONF_XCB_UTIL_KEYSYMS) += xcb-util-keysyms

#
# Paths and names
#
XCB_UTIL_KEYSYMS_VERSION	:= 0.4.0
XCB_UTIL_KEYSYMS_MD5		:= 1022293083eec9e62d5659261c29e367
XCB_UTIL_KEYSYMS		:= xcb-util-keysyms-$(XCB_UTIL_KEYSYMS_VERSION)
XCB_UTIL_KEYSYMS_SUFFIX		:= tar.bz2
XCB_UTIL_KEYSYMS_URL		:= https://xcb.freedesktop.org/dist/$(XCB_UTIL_KEYSYMS).$(XCB_UTIL_KEYSYMS_SUFFIX)
XCB_UTIL_KEYSYMS_SOURCE		:= $(SRCDIR)/$(XCB_UTIL_KEYSYMS).$(XCB_UTIL_KEYSYMS_SUFFIX)
XCB_UTIL_KEYSYMS_DIR		:= $(BUILDDIR)/$(XCB_UTIL_KEYSYMS)
XCB_UTIL_KEYSYMS_LICENSE	:= X11

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
XCB_UTIL_KEYSYMS_CONF_TOOL	:= autoconf
XCB_UTIL_KEYSYMS_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-selective-werror \
	--disable-strict-compilation \
	--disable-devel-docs \
	--without-doxygen


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xcb-util-keysyms.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xcb-util-keysyms)
	@$(call install_fixup, xcb-util-keysyms,PRIORITY,optional)
	@$(call install_fixup, xcb-util-keysyms,SECTION,base)
	@$(call install_fixup, xcb-util-keysyms,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, xcb-util-keysyms,DESCRIPTION,missing)

	@$(call install_lib, xcb-util-keysyms, 0, 0, 0644, libxcb-keysyms)

	@$(call install_finish, xcb-util-keysyms)

	@$(call touch)

# vim: syntax=make
