# -*-makefile-*-
#
# Copyright (C) 2015 by Michael Grzeschik <mgr@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_RAUC) += host-rauc

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_RAUC_CONF_TOOL	:= autoconf
HOST_RAUC_CONF_OPT	:= \
	$(HOST_AUTOCONF) \
	--disable-code-coverage \
	--disable-valgrind \
	--disable-service \
	--disable-network \
	--disable-json

# vim: syntax=make
