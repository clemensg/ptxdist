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
HOST_PACKAGES-$(PTXCONF_HOST_LIBCGROUP) += host-libcgroup

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_LIBCGROUP_CONF_TOOL := autoconf
HOST_LIBCGROUP_CONF_OPT := \
	$(HOST_AUTOCONF) \
	--disable-bindings \
	--disable-tools \
	--disable-pam \
	--disable-daemon

# vim: syntax=make
