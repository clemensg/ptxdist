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
PACKAGES-$(PTXCONF_LIBPSL) += libpsl

#
# Paths and names
#
LIBPSL_VERSION	:= 0.21.0
LIBPSL_MD5	:= 171e96d887709e36a57f4ee627bf82d2
LIBPSL		:= libpsl-$(LIBPSL_VERSION)
LIBPSL_SUFFIX	:= tar.gz
LIBPSL_URL	:= https://github.com/rockdaboot/libpsl/releases/download/$(LIBPSL)/$(LIBPSL).$(LIBPSL_SUFFIX)
LIBPSL_SOURCE	:= $(SRCDIR)/$(LIBPSL).$(LIBPSL_SUFFIX)
LIBPSL_DIR	:= $(BUILDDIR)/$(LIBPSL)
LIBPSL_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
LIBPSL_CONF_TOOL	:= autoconf
LIBPSL_CONF_OPT		:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-nls \
	--disable-rpath \
	--disable-gtk-doc \
	--disable-gtk-doc-html \
	--disable-gtk-doc-pdf \
	--disable-man \
	--disable-cfi \
	--disable-ubsan \
	--disable-asan \
	--disable-valgrind-tests

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libpsl.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libpsl)
	@$(call install_fixup, libpsl,PRIORITY,optional)
	@$(call install_fixup, libpsl,SECTION,base)
	@$(call install_fixup, libpsl,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, libpsl,DESCRIPTION,missing)

	@$(call install_lib, libpsl, 0, 0, 0644, libpsl)

	@$(call install_finish, libpsl)

	@$(call touch)

# vim: syntax=make
