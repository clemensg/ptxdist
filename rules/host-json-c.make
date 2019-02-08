# -*-makefile-*-
#
# Copyright (C) 2019 by Bastian Krause <bst@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_JSON_C) += host-json-c

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_JSON_C_CONF_TOOL	:= autoconf
HOST_JSON_C_CONF_OPT	:= \
	$(HOST_AUTOCONF) \
	--disable-threading \
	--disable-rdrand \
	--disable-static

# vim: syntax=make
