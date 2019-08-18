# -*-makefile-*-
#
# Copyright (C) 2018 by Artur Wiebe <artur@4wiebe.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_EFIVAR) += efivar

#
# Paths and names
#
EFIVAR_VERSION	:= 37
EFIVAR_MD5	:= 9f067275c5f7aafdd75bfb364280ac9c
EFIVAR		:= efivar-$(EFIVAR_VERSION)
EFIVAR_SUFFIX	:= tar.bz2
EFIVAR_URL	:= https://github.com/rhboot/efivar/releases/download/$(EFIVAR_VERSION)/$(EFIVAR).$(EFIVAR_SUFFIX)
EFIVAR_SOURCE	:= $(SRCDIR)/$(EFIVAR).$(EFIVAR_SUFFIX)
EFIVAR_DIR	:= $(BUILDDIR)/$(EFIVAR)
EFIVAR_LICENSE	:= LGPL-2.1-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

EFIVAR_CONF_TOOL	:= NO
EFIVAR_MAKE_ENV		:= $(CROSS_ENV) PTXDIST_ICECC=
EFIVAR_INSTALL_OPT	:= libdir="/usr/lib/" install

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/efivar.targetinstall:
	@$(call targetinfo)

	@$(call install_init, efivar)
	@$(call install_fixup, efivar,PRIORITY,optional)
	@$(call install_fixup, efivar,SECTION,base)
	@$(call install_fixup, efivar,AUTHOR,"Artur Wiebe <artur@4wiebe.de>")
	@$(call install_fixup, efivar,DESCRIPTION,missing)

	@$(call install_lib, efivar, 0, 0, 0644, libefivar)
	@$(call install_lib, efivar, 0, 0, 0644, libefiboot)

	@$(call install_copy, efivar, 0, 0, 0755, -, /usr/bin/efivar)

	@$(call install_finish, efivar)

	@$(call touch)


# vim: syntax=make
