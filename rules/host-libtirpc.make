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
HOST_PACKAGES-$(PTXCONF_HOST_LIBTIRPC) += host-libtirpc

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_LIBTIRPC_CONF_TOOL	:= autoconf
HOST_LIBTIRPC_CONF_OPT	:= \
	$(HOST_AUTOCONF) \
	--disable-gssapi \
	--disable-shared \
	--enable-static

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

HOST_LIBTIRPC_PC := $(HOST_LIBTIRPC_PKGDIR)/lib/pkgconfig/libtirpc.pc

$(STATEDIR)/host-libtirpc.install:
	@$(call targetinfo)
	@$(call world/install, HOST_LIBTIRPC)
#	# add Libs.private to Libs to fix linking static libtirpc
	@sed -i "s/Libs:.*/\0`sed -n 's/Libs.private:\(.*\)/\1/p' $(HOST_LIBTIRPC_PC)`/" $(HOST_LIBTIRPC_PC)
	@$(call touch)

# vim: syntax=make
