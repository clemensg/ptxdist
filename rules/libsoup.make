# -*-makefile-*-
#
# Copyright (C) 2012 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBSOUP) += libsoup

#
# Paths and names
#
LIBSOUP_VERSION	:= 2.66.2
LIBSOUP_MD5	:= 66c2ae89d6031b01337d78a2c57c75d5
LIBSOUP		:= libsoup-$(LIBSOUP_VERSION)
LIBSOUP_SUFFIX	:= tar.xz
LIBSOUP_URL	:= http://ftp.gnome.org/pub/GNOME/sources/libsoup/$(basename $(LIBSOUP_VERSION))/$(LIBSOUP).$(LIBSOUP_SUFFIX)
LIBSOUP_SOURCE	:= $(SRCDIR)/$(LIBSOUP).$(LIBSOUP_SUFFIX)
LIBSOUP_DIR	:= $(BUILDDIR)/$(LIBSOUP)
LIBSOUP_LICENSE	:= LGPL-2.1-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# meson
#
LIBSOUP_CONF_TOOL := meson
LIBSOUP_CONF_OPT := \
	$(CROSS_MESON_USR) \
	-Dgssapi=false \
	-Ddoc=false \
	-Dgnome=true \
	-Dvapi=false \
	-Dintrospection=$(call ptx/truefalse, PTXCONF_LIBSOUP_INTROSPECTION) \
	-Dkrb5_config= \
	-Dntlm=false \
	-Dntlm_auth=ntlm_auth \
	-Dtests=false \
	-Dtls_check=false

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libsoup.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libsoup)
	@$(call install_fixup, libsoup,PRIORITY,optional)
	@$(call install_fixup, libsoup,SECTION,base)
	@$(call install_fixup, libsoup,AUTHOR,"Marc Kleine-Budde <mkl@pengutronix.de>")
	@$(call install_fixup, libsoup,DESCRIPTION,missing)

	@$(call install_lib, libsoup, 0, 0, 0644, libsoup-2.4)
ifdef PTXCONF_LIBSOUP_INTROSPECTION
	@$(call install_copy, libsoup, 0, 0, 0644, -, \
		/usr/lib/girepository-1.0/Soup-2.4.typelib)
endif

	@$(call install_finish, libsoup)

	@$(call touch)

# vim: syntax=make
