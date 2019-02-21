# -*-makefile-*-
#
# Copyright (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#               2015, 2018 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PCSC_LITE) += pcsc-lite

#
# Paths and names
#
PCSC_LITE_VERSION	:= 1.8.23
PCSC_LITE_MD5		:= 3ba4b45456a500b5f1f22bf56a2dee38
PCSC_LITE_SUFFIX	:= tar.bz2
PCSC_LITE		:= pcsc-lite-$(PCSC_LITE_VERSION)
PCSC_LITE_URL		:= https://pcsclite.apdu.fr/files/$(PCSC_LITE).$(PCSC_LITE_SUFFIX)
PCSC_LITE_SOURCE	:= $(SRCDIR)/$(PCSC_LITE).$(PCSC_LITE_SUFFIX)
PCSC_LITE_DIR		:= $(BUILDDIR)/$(PCSC_LITE)
PCSC_LITE_BUILD_OOT	:= YES
# src/spy LICENSE := GPL-3.0-or-later - but file is not distributed
PCSC_LITE_LICENSE	:= BSD-3-Clause AND BSD-2-Clause AND MIT AND ISC

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
PCSC_LITE_CONF_TOOL := autoconf
PCSC_LITE_CONF_OPT := \
	$(CROSS_AUTOCONF_USR) \
	--$(call ptx/endis, PTXCONF_PCSC_LITE_SYSTEMD_UNIT)-libsystemd \
	--disable-serial \
	--disable-usb \
	--$(call ptx/endis, PTXCONF_PCSC_LITE_LIBUDEV)-libudev \
	--disable-libusb \
	--disable-polkit \
	--disable-embedded \
	--enable-usbdropdir=/usr/lib/pcsc \
	--$(call ptx/endis, PTXCONF_PCSC_LITE_DEBUGATR)-debugatr \
	--disable-filter \
	--with-systemdsystemunitdir=/usr/lib/systemd/system

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/pcsc-lite.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  pcsc-lite)
	@$(call install_fixup, pcsc-lite,PRIORITY,optional)
	@$(call install_fixup, pcsc-lite,SECTION,base)
	@$(call install_fixup, pcsc-lite,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, pcsc-lite,DESCRIPTION,missing)

	@$(call install_alternative, pcsc-lite, 0, 0, 0644, /etc/reader.conf.d/reader.conf)

	@$(call install_lib, pcsc-lite, 0, 0, 0644, libpcsclite)
	@$(call install_copy, pcsc-lite, 0, 0, 0755, -, /usr/sbin/pcscd)

ifdef PTXCONF_PCSC_LITE_SYSTEMD_UNIT
	@$(call install_alternative, pcsc-lite, 0, 0, 0644, /usr/lib/systemd/system/pcscd.service)
	@$(call install_alternative, pcsc-lite, 0, 0, 0644, /usr/lib/systemd/system/pcscd.socket)
	@$(call install_link, pcsc-lite, ../pcscd.socket, \
		/usr/lib/systemd/system/sockets.target.wants/pcscd.socket)
endif

	@$(call install_finish, pcsc-lite)

	@$(call touch)

# vim: syntax=make
