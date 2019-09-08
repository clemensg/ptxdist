# -*-makefile-*-
#
# Copyright (C) 2016 by Clemens Gruber <clemens.gruber@pqgruber.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBSECCOMP) += libseccomp

#
# Paths and names
#
LIBSECCOMP_VERSION	:= 2.4.1
LIBSECCOMP_MD5		:= 4fa6b0f39b48b8644415d7a9a9dfe9f4
LIBSECCOMP		:= libseccomp-$(LIBSECCOMP_VERSION)
LIBSECCOMP_SUFFIX	:= tar.gz
LIBSECCOMP_URL		:= https://github.com/seccomp/libseccomp/releases/download/v$(LIBSECCOMP_VERSION)/$(LIBSECCOMP).$(LIBSECCOMP_SUFFIX)
LIBSECCOMP_SOURCE	:= $(SRCDIR)/$(LIBSECCOMP).$(LIBSECCOMP_SUFFIX)
LIBSECCOMP_DIR		:= $(BUILDDIR)/$(LIBSECCOMP)
LIBSECCOMP_LICENSE	:= LGPL-2.1-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
LIBSECCOMP_CONF_TOOL	:= autoconf
LIBSECCOMP_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-python \
	--disable-code-coverage

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libseccomp.install:
	@$(call targetinfo)
	@$(call world/install, LIBSECCOMP)
	@install -D -m 755 $(LIBSECCOMP_DIR)/tools/scmp_app_inspector \
		$(LIBSECCOMP_PKGDIR)/usr/bin/scmp_app_inspector
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libseccomp.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libseccomp)
	@$(call install_fixup, libseccomp, PRIORITY, optional)
	@$(call install_fixup, libseccomp, SECTION, base)
	@$(call install_fixup, libseccomp, AUTHOR, "Clemens Gruber <clemens.gruber@pqgruber.com>")
	@$(call install_fixup, libseccomp, DESCRIPTION, missing)

	@$(call install_lib, libseccomp, 0, 0, 0644, libseccomp)

ifdef PTXCONF_LIBSECCOMP_UTILS
	@$(call install_copy, libseccomp, 0, 0, 0755, -, /usr/bin/scmp_sys_resolver)
	@$(call install_copy, libseccomp, 0, 0, 0755, -, /usr/bin/scmp_app_inspector)
endif
	@$(call install_finish, libseccomp)

	@$(call touch)

# vim: syntax=make
