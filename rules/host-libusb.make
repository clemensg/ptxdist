# -*-makefile-*-
#
# Copyright (C) 2012 by Juergen Beisert <jbe@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_LIBUSB) += host-libusb

#
# Paths and names
#

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_LIBUSB_AUTOCONF := \
	$(HOST_AUTOCONF) \
	--disable-static \
	--disable-udev

# vim: syntax=make
