# -*-makefile-*-
#
# Copyright (C) 2008 by Luotao Fu <l.fu@pengutronix.de>
#               2010 Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_BC) += bc

#
# Paths and names
#
BC_VERSION	:= 1.06
BC_MD5		:= d44b5dddebd8a7a7309aea6c36fda117
BC		:= bc-$(BC_VERSION)
BC_SUFFIX	:= tar.gz
BC_URL		:= $(call ptx/mirror, GNU, bc/$(BC).$(BC_SUFFIX))
BC_SOURCE	:= $(SRCDIR)/$(BC).$(BC_SUFFIX)
BC_DIR		:= $(BUILDDIR)/$(BC)
BC_LICENSE	:= GPL-2.0-or-later
BC_LICENSE_FILES	:= \
	file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f \
	file://bc/bc.c;startline=47;endline=73;md5=944528275142ba90c112735cf0cbc7d1

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

BC_PATH	:= PATH=$(CROSS_PATH)
BC_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
BC_AUTOCONF := $(CROSS_AUTOCONF_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/bc.targetinstall:
	@$(call targetinfo)

	@$(call install_init, bc)
	@$(call install_fixup, bc,PRIORITY,optional)
	@$(call install_fixup, bc,SECTION,base)
	@$(call install_fixup, bc,AUTHOR,"Luotao Fu <l.fu@pengutronix.de>")
	@$(call install_fixup, bc,DESCRIPTION,missing)

	@$(call install_copy, bc, 0, 0, 0755, -, /usr/bin/bc)

	@$(call install_finish, bc)

	@$(call touch)

# vim: syntax=make
