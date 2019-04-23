# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBNICE) += libnice

#
# Paths and names
#
LIBNICE_VERSION	:= 0.1.15
LIBNICE_MD5	:= 5f58f305d23158651ab509b25420d353
LIBNICE		:= libnice-$(LIBNICE_VERSION)
LIBNICE_SUFFIX	:= tar.gz
LIBNICE_URL	:= https://nice.freedesktop.org/releases/$(LIBNICE).$(LIBNICE_SUFFIX)
LIBNICE_SOURCE	:= $(SRCDIR)/$(LIBNICE).$(LIBNICE_SUFFIX)
LIBNICE_DIR	:= $(BUILDDIR)/$(LIBNICE)
LIBNICE_LICENSE	:= MPL-1.1 OR LGPL-2.1-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
LIBNICE_CONF_TOOL	:= autoconf
LIBNICE_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--enable-assert \
	--enable-compile-warnings=yes \
	--disable-gupnp \
	--disable-coverage \
	--disable-static-plugins \
	--disable-gtk-doc \
	--disable-gtk-doc-html \
	--disable-gtk-doc-pdf \
	--disable-introspection \
	--with-crypto-library=openssl \
	--with-gstreamer \
	--without-gstreamer-0.10

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libnice.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libnice)
	@$(call install_fixup, libnice,PRIORITY,optional)
	@$(call install_fixup, libnice,SECTION,base)
	@$(call install_fixup, libnice,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, libnice,DESCRIPTION,missing)

	@$(call install_lib, libnice, 0, 0, 0644, libnice)
	@$(call install_lib, libnice, 0, 0, 0644, gstreamer-1.0/libgstnice)

	@$(call install_finish, libnice)

	@$(call touch)

# vim: syntax=make
