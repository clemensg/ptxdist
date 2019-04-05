# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Tretter <m.tretter@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_UVC_GADGET) += uvc-gadget

#
# Paths and names
#
UVC_GADGET_VERSION	:= 2019-02-13-g58f5ddeb
UVC_GADGET_MD5		:= aabd91acafd035a85c2151b67e1491ca
UVC_GADGET		:= uvc-gadget-$(UVC_GADGET_VERSION)
UVC_GADGET_SUFFIX	:= tar.xz
UVC_GADGET_URL 		:= git://git.ideasonboard.org/uvc-gadget.git;tag=$(UVC_GADGET_VERSION)
UVC_GADGET_SOURCE	:= $(SRCDIR)/$(UVC_GADGET).$(UVC_GADGET_SUFFIX)
UVC_GADGET_DIR		:= $(BUILDDIR)/$(UVC_GADGET)
UVC_GADGET_LICENSE	:= GPL-2.0-or-later AND LGPL-2.1-or-later AND MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

UVC_GADGET_CONF_TOOL	:= cmake
UVC_GADGET_CONF_OPT	:= \
	$(CROSS_CMAKE_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/uvc-gadget.targetinstall:
	@$(call targetinfo)

	@$(call install_init, uvc-gadget)
	@$(call install_fixup, uvc-gadget,PRIORITY,optional)
	@$(call install_fixup, uvc-gadget,SECTION,base)
	@$(call install_fixup, uvc-gadget,AUTHOR,"Michael Tretter <m.tretter@pengutronix.de>")
	@$(call install_fixup, uvc-gadget,DESCRIPTION,missing)

	@$(call install_copy, uvc-gadget, 0, 0, 0755, -, /usr/bin/uvc-gadget)

	@$(call install_finish, uvc-gadget)

	@$(call touch)

# vim: syntax=make
