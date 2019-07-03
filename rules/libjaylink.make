# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Grzeschik <mgr@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

PACKAGES-$(PTXCONF_LIBJAYLINK) += libjaylink

LIBJAYLINK_VERSION	:= 0.1.0-15-g8645845
LIBJAYLINK_MD5		:= 6e71d5c39ae4778bb8d0df79d2524c07
LIBJAYLINK		:= libjaylink-$(LIBJAYLINK_VERSION)
LIBJAYLINK_SUFFIX	:= tar.bz2
LIBJAYLINK_URL		:= git://git.zapb.de/libjaylink;tag=$(LIBJAYLINK_VERSION)
LIBJAYLINK_SOURCE	:= $(SRCDIR)/$(LIBJAYLINK).$(LIBJAYLINK_SUFFIX)
LIBJAYLINK_DIR		:= $(BUILDDIR)/$(LIBJAYLINK)
LIBJAYLINK_LICENSE	:= GPL-2.0+

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libjaylink.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libjaylink)
	@$(call install_fixup, libjaylink,PRIORITY,optional)
	@$(call install_fixup, libjaylink,SECTION,base)
	@$(call install_fixup, libjaylink,AUTHOR,"Michael Grzeschik <mgr@pengutronix.de>")
	@$(call install_fixup, libjaylink,DESCRIPTION,"Library to access J-Link devices")

	@$(call install_lib, libjaylink, 0, 0, 0644, libjaylink)

	@$(call install_finish, libjaylink)

	@$(call touch)

# vim: syntax=make
