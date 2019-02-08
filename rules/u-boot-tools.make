# -*-makefile-*-
#
# Copyright (C) 2012 by Andreas Bießmann <andreas@biessmann.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_U_BOOT_TOOLS) += u-boot-tools

#
# Paths and names
#
U_BOOT_TOOLS_VERSION	:= 2019.01
U_BOOT_TOOLS_MD5	:= 0adbc6c755768f0b78a2a0decf0b253a
U_BOOT_TOOLS		:= u-boot-$(U_BOOT_TOOLS_VERSION)
U_BOOT_TOOLS_SUFFIX	:= tar.bz2
U_BOOT_TOOLS_URL	:= ftp://ftp.denx.de/pub/u-boot/$(U_BOOT_TOOLS).$(U_BOOT_TOOLS_SUFFIX)
U_BOOT_TOOLS_SOURCE	:= $(SRCDIR)/$(U_BOOT_TOOLS).$(U_BOOT_TOOLS_SUFFIX)
U_BOOT_TOOLS_DIR	:= $(BUILDDIR)/u-boot-tools-$(U_BOOT_TOOLS_VERSION)
U_BOOT_TOOLS_LICENSE	:= GPL-2.0-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------


# just pick sandbox as a dummy target config
U_BOOT_TOOLS_CONFIG	:= sandbox_config
ifdef PTXCONF_ARCH_PPC
# the sandbox is not supported by PPC so just some random PPC config
U_BOOT_TOOLS_CONFIG	:= MPC8308RDB_defconfig
endif

U_BOOT_TOOLS_CONF_TOOL	:= NO
U_BOOT_TOOLS_MAKE_OPT	:= \
	CROSS_COMPILE=$(BOOTLOADER_CROSS_COMPILE) \
	$(U_BOOT_TOOLS_CONFIG) \
	tools/env/

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot-tools.install:
	@$(call targetinfo)
	install -D $(U_BOOT_TOOLS_DIR)/tools/env/fw_printenv \
		$(U_BOOT_TOOLS_PKGDIR)/usr/sbin/fw_printenv
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot-tools.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  u-boot-tools)
	@$(call install_fixup, u-boot-tools,PRIORITY,optional)
	@$(call install_fixup, u-boot-tools,SECTION,base)
	@$(call install_fixup, u-boot-tools,AUTHOR,\
		"Andreas Bießmann <andreas@biessmann.de>")
	@$(call install_fixup, u-boot-tools,DESCRIPTION,missing)

	@$(call install_copy, u-boot-tools, 0, 0, 0755, -, /usr/sbin/fw_printenv)
	@$(call install_link, u-boot-tools, fw_printenv, /usr/sbin/fw_setenv)
	@$(call install_alternative, u-boot-tools, 0, 0, 0644, /etc/fw_env.config)

	@$(call install_finish, u-boot-tools)

	@$(call touch)

# vim: syntax=make
