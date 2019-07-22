# -*-makefile-*-
#
# Copyright (C) 2012 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DDRESCUE) += ddrescue

#
# Paths and names
#
DDRESCUE_VERSION	:= 1.23
DDRESCUE_MD5		:= cd85a82d510d9abf790132fb0da1bf3c
DDRESCUE		:= ddrescue-$(DDRESCUE_VERSION)
DDRESCUE_SUFFIX		:= tar.lz
DDRESCUE_URL		:= $(call ptx/mirror, GNU, ddrescue/$(DDRESCUE).$(DDRESCUE_SUFFIX))
DDRESCUE_SOURCE		:= $(SRCDIR)/$(DDRESCUE).$(DDRESCUE_SUFFIX)
DDRESCUE_DIR		:= $(BUILDDIR)/$(DDRESCUE)
DDRESCUE_LICENSE	:= GPL-2.0-or-later AND BSD-2-Clause
DDRESCUE_LICENSE_FILES	:= \
	file://COPYING;md5=76d6e300ffd8fb9d18bd9b136a9bba13 \
	file://main.cc;startline=1;endline=16;md5=a01d61d3293ce28b883d8ba0c497e968 \
	file://arg_parser.cc;startline=1;endline=18;md5=41d1341d0d733a5d24b26dc3cbc1ac42


# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
DDRESCUE_CONF_TOOL	:= autoconf
DDRESCUE_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	$(CROSS_ENV)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ddrescue.targetinstall:
	@$(call targetinfo)

	@$(call install_init, ddrescue)
	@$(call install_fixup, ddrescue,PRIORITY,optional)
	@$(call install_fixup, ddrescue,SECTION,base)
	@$(call install_fixup, ddrescue,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, ddrescue,DESCRIPTION,missing)

	@$(call install_copy, ddrescue, 0, 0, 0755, -, /usr/bin/ddrescue)

	@$(call install_finish, ddrescue)

	@$(call touch)

# vim: syntax=make
