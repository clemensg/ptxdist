# -*-makefile-*-
#
# Copyright (C) 2007 by Sascha Hauer
#               2009, 2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_U_BOOT) += u-boot

#
# Paths and names
#
U_BOOT_VERSION	:= $(call remove_quotes,$(PTXCONF_U_BOOT_VERSION))
U_BOOT_MD5	:= $(call remove_quotes,$(PTXCONF_U_BOOT_MD5))
U_BOOT		:= u-boot-$(U_BOOT_VERSION)
U_BOOT_SUFFIX	:= tar.bz2
U_BOOT_URL	:= ftp://ftp.denx.de/pub/u-boot/$(U_BOOT).$(U_BOOT_SUFFIX)
U_BOOT_SOURCE	:= $(SRCDIR)/$(U_BOOT).$(U_BOOT_SUFFIX)
U_BOOT_DIR	:= $(BUILDDIR)/$(U_BOOT)

ifdef PTXCONF_U_BOOT_CONFIGSYSTEM_KCONFIG
U_BOOT_CONFIG	:= $(call ptx/in-platformconfigdir, \
		$(call remove_quotes, $(PTXCONF_U_BOOT_CONFIGFILE_KCONFIG)))
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

U_BOOT_WRAPPER_BLACKLIST := \
	TARGET_HARDEN_RELRO \
	TARGET_HARDEN_BINDNOW \
	TARGET_HARDEN_PIE \
	TARGET_DEBUG \
	TARGET_BUILD_ID

U_BOOT_MAKE_ENV		:= \
	CROSS_COMPILE=$(BOOTLOADER_CROSS_COMPILE) \
	HOSTCC=$(HOSTCC)
U_BOOT_MAKE_OPT		:= V=$(PTXDIST_VERBOSE)
U_BOOT_TAGS_OPT		:= ctags cscope etags

ifdef PTXCONF_U_BOOT_CONFIGSYSTEM_KCONFIG
U_BOOT_CONF_TOOL	:= kconfig
U_BOOT_CONF_ENV		:= KCONFIG_NOTIMESTAMP=1 $(U_BOOT_MAKE_ENV)
endif

ifdef PTXCONF_U_BOOT_CONFIGSYSTEM_LEGACY
U_BOOT_CONF_ENV		:= PATH=$(CROSS_PATH) $(U_BOOT_MAKE_ENV)
U_BOOT_CONF_OPT		:= \
	$(U_BOOT_MAKE_OPT) \
	$(call remove_quotes, $(PTXCONF_U_BOOT_CONFIG))
U_BOOT_MAKE_PAR		:= NO
endif


ifdef PTXCONF_U_BOOT
$(U_BOOT_CONFIG):
	@echo
	@echo "****************************************************************************"
	@echo "***** Please generate a u-boot config with 'ptxdist menuconfig u-boot' *****"
	@echo "****************************************************************************"
	@echo
	@echo
	@exit 1
endif


ifdef PTXCONF_U_BOOT_CONFIGSYSTEM_LEGACY
$(STATEDIR)/u-boot.prepare:
	@$(call targetinfo)
	$(U_BOOT_CONF_ENV) $(MAKE) -C $(U_BOOT_DIR) $(U_BOOT_CONF_OPT)
	@$(call touch)
endif

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot.targetinstall:
	@$(call targetinfo)
	@install -v -D -m644 $(U_BOOT_DIR)/u-boot.bin $(IMAGEDIR)/u-boot.bin
ifdef PTXCONF_U_BOOT_INSTALL_SREC
	@install -v -D -m644 $(U_BOOT_DIR)/u-boot.srec $(IMAGEDIR)/u-boot.srec
endif
ifdef PTXCONF_U_BOOT_INSTALL_ELF
	@install -v -D -m644 $(U_BOOT_DIR)/u-boot $(IMAGEDIR)/u-boot.elf
endif
ifdef PTXCONF_U_BOOT_INSTALL_SPL
	@install -v -D -m644 $(U_BOOT_DIR)/SPL $(IMAGEDIR)/SPL
endif
ifdef PTXCONF_U_BOOT_INSTALL_MLO
	@install -v -D -m644 $(U_BOOT_DIR)/MLO $(IMAGEDIR)/MLO
endif
ifdef PTXCONF_U_BOOT_INSTALL_U_BOOT_IMG
	@install -v -D -m644 $(U_BOOT_DIR)/u-boot.img $(IMAGEDIR)/u-boot.img
endif
ifdef PTXCONF_U_BOOT_INSTALL_U_BOOT_IMX
	@install -v -D -m644 $(U_BOOT_DIR)/u-boot.imx $(IMAGEDIR)/u-boot.imx
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot.clean:
	@$(call targetinfo)
	@$(call clean_pkg, U_BOOT)
	@rm -vf $(IMAGEDIR)/u-boot.bin $(IMAGEDIR)/u-boot.srec $(IMAGEDIR)/u-boot.elf
	@rm -vf $(IMAGEDIR)/u-boot.img $(IMAGEDIR)/SPL $(IMAGEDIR)/MLO
	@rm -vf $(IMAGEDIR)/u-boot.imx

# ----------------------------------------------------------------------------
# oldconfig / menuconfig
# ----------------------------------------------------------------------------

u-boot_oldconfig u-boot_menuconfig u-boot_nconfig: $(STATEDIR)/u-boot.extract
	@$(call world/kconfig, U_BOOT, $(subst u-boot_,,$@))

# vim: syntax=make
