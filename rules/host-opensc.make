# -*-makefile-*-
#
# Copyright (C) 2018 by Juergen Borleis <jbe@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_OPENSC) += host-opensc

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_OPENSC_CONF_TOOL	:= autoconf
HOST_OPENSC_CONF_OPT	:= \
	$(HOST_AUTOCONF) \
	--sysconfdir=/etc/opensc \
	--enable-optimization \
	--disable-strict \
	--disable-pedantic \
	--enable-thread-locking \
	--disable-zlib \
	--disable-readline \
	--enable-openssl \
	--disable-openpace \
	--disable-openct \
	--$(call ptx/endis, PTXCONF_HOST_OPENSC_PCSC)-pcsc \
	--disable-cryptotokenkit \
	--$(call ptx/disen, PTXCONF_HOST_OPENSC_PCSC)-ctapi \
	--disable-minidriver \
	--enable-sm \
	--disable-man \
	--disable-doc \
	--disable-dnie-ui \
	--disable-notify \
	--enable-tests=no \
	--disable-static

HOST_OPENSC_CPPFLAGS := -Wno-implicit-fallthrough

# vim: syntax=make
