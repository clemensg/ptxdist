# -*-makefile-*-
#
# Copyright (C) 2014 by Michael Grzeschik <mgr@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_LIBFTDI1) += host-libftdi1

HOST_LIBFTDI1_CONF_TOOL	:= cmake
HOST_LIBFTDI1_CONF_OPT	:= \
	$(HOST_CMAKE_USR) \
	-DDOCUMENTATION=OFF \
	-DPYTHON_BINDINGS=OFF \
	-DSTATICLIBS=OFF \
	-DEXAMPLES=OFF \
	-DFTDIPP=OFF \
	-DFTDI_EEPROM=OFF

# vim: syntax=make
