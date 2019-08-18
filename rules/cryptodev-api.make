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
PACKAGES-$(PTXCONF_CRYPTODEV_API) += cryptodev-api

#
# Paths and names
#
CRYPTODEV_API_VERSION	= $(CRYPTODEV_VERSION)
CRYPTODEV_API_MD5	= $(CRYPTODEV_MD5)
CRYPTODEV_API		= cryptodev-api-$(CRYPTODEV_API_VERSION)
CRYPTODEV_API_SUFFIX	= tar.gz
CRYPTODEV_API_URL	= $(CRYPTODEV_URL)
CRYPTODEV_API_SOURCE	= $(CRYPTODEV_SOURCE)
CRYPTODEV_API_DIR	= $(BUILDDIR)/$(CRYPTODEV_API)
CRYPTODEV_API_LICENSE	= $(CRYPTODEV_LICENSE)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CRYPTODEV_API_CONF_TOOL	:= NO

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/cryptodev-api.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cryptodev-api.install:
	@$(call targetinfo)
	@install -m644 -D $(CRYPTODEV_API_DIR)/crypto/cryptodev.h \
		$(CRYPTODEV_API_PKGDIR)/usr/include/crypto/cryptodev.h
	@$(call touch)

# vim: syntax=make
