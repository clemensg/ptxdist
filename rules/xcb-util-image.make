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
PACKAGES-$(PTXCONF_XCB_UTIL_IMAGE) += xcb-util-image

#
# Paths and names
#
XCB_UTIL_IMAGE_VERSION	:= 0.4.0
XCB_UTIL_IMAGE_MD5	:= 08fe8ffecc8d4e37c0ade7906b3f4c87
XCB_UTIL_IMAGE		:= xcb-util-image-$(XCB_UTIL_IMAGE_VERSION)
XCB_UTIL_IMAGE_SUFFIX	:= tar.bz2
XCB_UTIL_IMAGE_URL	:= https://xcb.freedesktop.org/dist/$(XCB_UTIL_IMAGE).$(XCB_UTIL_IMAGE_SUFFIX)
XCB_UTIL_IMAGE_SOURCE	:= $(SRCDIR)/$(XCB_UTIL_IMAGE).$(XCB_UTIL_IMAGE_SUFFIX)
XCB_UTIL_IMAGE_DIR	:= $(BUILDDIR)/$(XCB_UTIL_IMAGE)
XCB_UTIL_IMAGE_LICENSE	:= X11

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
XCB_UTIL_IMAGE_CONF_TOOL	:= autoconf
XCB_UTIL_IMAGE_CONF_OPT		:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-selective-werror \
	--disable-strict-compilation \
	--disable-devel-docs \
	--without-doxygen

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xcb-util-image.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xcb-util-image)
	@$(call install_fixup, xcb-util-image,PRIORITY,optional)
	@$(call install_fixup, xcb-util-image,SECTION,base)
	@$(call install_fixup, xcb-util-image,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, xcb-util-image,DESCRIPTION,missing)

	@$(call install_lib, xcb-util-image, 0, 0, 0644, libxcb-image)

	@$(call install_finish, xcb-util-image)

	@$(call touch)

# vim: syntax=make
