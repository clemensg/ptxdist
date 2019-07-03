# -*-makefile-*-
#
# Copyright (C) 2011 by Wolfram Sang <w.sang@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_FIGLET) += host-figlet

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

HOST_FIGLET_MAKE_OPT	:= prefix=/
HOST_FIGLET_INSTALL_OPT	:= prefix=/ install

# vim: syntax=make
