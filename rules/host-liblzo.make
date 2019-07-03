# -*-makefile-*-
#
# Copyright (C) 2007 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_LIBLZO) += host-liblzo

#
# Paths and names
#
HOST_LIBLZO_DIR	= $(HOST_BUILDDIR)/$(LIBLZO)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_LIBLZO_CONF_TOOL	:= autoconf
HOST_LIBLZO_CONF_OPT	:= \
	$(HOST_AUTOCONF) \
	--enable-shared \
	--disable-static

# vim: syntax=make
