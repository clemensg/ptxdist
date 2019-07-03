# -*-makefile-*-
#
# Copyright (C) 2019 by Philipp Zabel <p.zabel@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_USBIP) += usbip

#
# Paths and names
#
USBIP_VERSION	:= 5.0
USBIP		:= usbip-$(USBIP_VERSION)
USBIP_MD5	:= 7381ce8aac80a01448e065ce795c19c0
USBIP_SUFFIX	:= tar.xz
USBIP_URL	:= https://www.kernel.org/pub/linux/kernel/v5.x/linux-$(USBIP_VERSION).$(USBIP_SUFFIX)
USBIP_SOURCE	:= $(SRCDIR)/linux-$(USBIP_VERSION).$(USBIP_SUFFIX)
USBIP_SUBDIR	:= tools/usb/usbip
USBIP_DIR	:= $(BUILDDIR)/$(USBIP)
USBIP_LICENSE	:= GPL-2.0-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

USBIP_CONF_TOOL	:= autoconf
USBIP_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--without-tcp-wrappers \
	--with-usbids-dir=/usr/share/hwdata/ \
	--with-fortify

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/usbip.targetinstall:
	@$(call targetinfo)

	@$(call install_init, usbip)
	@$(call install_fixup, usbip, PRIORITY, optional)
	@$(call install_fixup, usbip, SECTION, base)
	@$(call install_fixup, usbip, AUTHOR, "Philipp Zabel <p.zabel@pengutronix.de>")
	@$(call install_fixup, usbip, DESCRIPTION, USB/IP system for sharing USB devices over the network)

	@$(call install_copy, usbip, 0, 0, 0755, -, /usr/sbin/usbip)
	@$(call install_copy, usbip, 0, 0, 0755, -, /usr/sbin/usbipd)
	@$(call install_lib, usbip, 0, 0, 0644, libusbip)

	@$(call install_finish, usbip)

	@$(call touch)

# vim: syntax=make
