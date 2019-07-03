# -*-makefile-*-
#
# Copyright (C) 2013 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_LIBCAP_NG) += host-libcap-ng

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_LIBCAP_NG_CONF_TOOL := autoconf
HOST_LIBCAP_NG_CONF_OPT := \
	$(HOST_AUTOCONF) \
	--without-python

# vim: syntax=make
