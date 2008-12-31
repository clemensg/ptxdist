# -*-makefile-*-
# $Id: udev.make,v 1.15 2007/03/07 14:34:52 michl Exp $
#
# Copyright (C) 2005-2008 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_UDEV) += udev

#
# Paths and names
#
UDEV_VERSION	:= 135
UDEV		:= udev-$(UDEV_VERSION)
UDEV_SUFFIX	:= tar.bz2
UDEV_SOURCE	:= $(SRCDIR)/$(UDEV).$(UDEV_SUFFIX)
UDEV_DIR	:= $(BUILDDIR)/$(UDEV)

UDEV_URL := \
	http://www.kernel.org/pub/linux/utils/kernel/hotplug/$(UDEV).$(UDEV_SUFFIX) \
	http://www.eu.kernel.org/pub/linux/utils/kernel/hotplug/$(UDEV).$(UDEV_SUFFIX) \
	http://www.us.kernel.org/pub/linux/utils/kernel/hotplug/$(UDEV).$(UDEV_SUFFIX)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(UDEV_SOURCE):
	@$(call targetinfo)
	@$(call get, UDEV)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

UDEV_PATH	:= PATH=$(CROSS_PATH)
UDEV_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
UDEV_AUTOCONF = \
	$(CROSS_AUTOCONF_ROOT) \
	--enable-shared

ifdef PTXCONF_UDEV__DEBUG
UDEV_AUTOCONF	+= --enable-debug
else
UDEV_AUTOCONF	+= --disable-debug
endif

ifdef PTXCONF_UDEV__SELINUX
UDEV_AUTOCONF	+= --enable-selinux
else
UDEV_AUTOCONF	+= --disable-selinux
endif

ifdef PTXCONF_UDEV__SYSLOG
UDEV_AUTOCONF	+= --enable-logging
else
UDEV_AUTOCONF	+= --disable-logging
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/udev.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  udev)
	@$(call install_fixup, udev,PACKAGE,udev)
	@$(call install_fixup, udev,PRIORITY,optional)
	@$(call install_fixup, udev,VERSION,$(UDEV_VERSION))
	@$(call install_fixup, udev,SECTION,base)
	@$(call install_fixup, udev,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, udev,DEPENDS,)
	@$(call install_fixup, udev,DESCRIPTION,missing)

	#
	# binaries
	#

	@$(call install_copy, udev, 0, 0, 0755, -, /sbin/udevd)
	@$(call install_copy, udev, 0, 0, 0755, -, /sbin/udevadm)
ifdef PTXCONF_UDEV__INSTALL_TEST_UDEV
	@$(call install_copy, udev, 0, 0, 0755, -, /sbin/test-udev)
endif

	#
	# default rules
	#

ifdef PTXCONF_ROOTFS_UDEV__DEFAULT_RULES
	cd $(UDEV_DIR)/rules/rules.d; \
	for file in *; do \
		$(call install_copy, udev, 0, 0, 0644, $(UDEV_DIR)/rules/rules.d/$$file, /lib/udev/rules.d/$$file, n); \
	done
endif

	#
	# startup script
	#
	@$(call install_alternative, udev, 0, 0, 0755, /etc/init.d/udev)

ifneq ($(PTXCONF_UDEV__RC_D_LINK),"")
	@$(call install_copy, udev, 0, 0, 0755, /etc/rc.d)
	@$(call install_link, udev, ../init.d/udev, \
		/etc/rc.d/$(PTXCONF_UDEV__RC_D_LINK))
endif


	#
	# Install a configuration on demand only
	#
	@$(call install_alternative, udev, 0, 0, 0644, /etc/udev/udev.conf)
	@$(call install_alternative, udev, 0, 0, 0644, /etc/udev/permissions.rules)

	#
	# utilities from extra/
	#
ifdef PTXCONF_UDEV__EXTRA_ATA_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/ata_id)
endif

ifdef PTXCONF_UDEV__EXTRA_CDROM_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/cdrom_id)
endif

ifdef PTXCONF_UDEV__EXTRA_COLLECT
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/collect)
endif

ifdef PTXCONF_UDEV__EXTRA_EDD_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/edd_id)
endif

ifdef PTXCONF_UDEV__EXTRA_FIRMWARE
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/firmware.sh)
endif

ifdef PTXCONF_UDEV__EXTRA_FLOPPY
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/create_floppy_devices)
endif

ifdef PTXCONF_UDEV__EXTRA_FSTAB_IMPORT
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/fstab_import)
	@$(call install_copy, udev, 0, 0, 0644, -, /lib/udev/rules.d/79-fstab_import.rules)
endif

ifdef PTXCONF_UDEV__EXTRA_PATH_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/path_id)
endif

ifdef PTXCONF_UDEV__EXTRA_RULE_GENERATOR
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/rule_generator.functions)
endif

ifdef PTXCONF_UDEV__EXTRA_SCSI_ID
	@$(call install_copy, udev, 0, 0, 0644, -, /etc/scsi_id.config)
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/scsi_id)
endif

ifdef PTXCONF_UDEV__EXTRA_USB_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/usb_id)
endif

ifdef PTXCONF_UDEV__EXTRA_VOLUME_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/vol_id)

	@$(call install_copy, udev, 0, 0, 0644, -, /lib/libvolume_id.so.1.0.6)
	@$(call install_link, udev, libvolume_id.so.1.0.6, /lib/libvolume_id.so.1)
	@$(call install_link, udev, libvolume_id.so.1.0.6, /lib/libvolume_id.so)
endif

	@$(call install_finish, udev)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

udev_clean:
	rm -rf $(STATEDIR)/udev.*
	rm -rf $(PKGDIR)/udev_*
	rm -rf $(UDEV_DIR)

# vim: syntax=make
