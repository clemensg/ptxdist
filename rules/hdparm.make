# -*-makefile-*-
#
# Copyright (C) 2005 by Robert Schwebel
#           (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_HDPARM) += hdparm

#
# Paths and names
#
HDPARM_VERSION	:= 9.58
HDPARM_MD5	:= 4652c49cf096a64683c05f54b4fa4679
HDPARM		:= hdparm-$(HDPARM_VERSION)
HDPARM_SUFFIX	:= tar.gz
HDPARM_URL	:= $(call ptx/mirror, SF, hdparm/$(HDPARM).$(HDPARM_SUFFIX))
HDPARM_SOURCE	:= $(SRCDIR)/$(HDPARM).$(HDPARM_SUFFIX)
HDPARM_DIR	:= $(BUILDDIR)/$(HDPARM)


# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

HDPARM_CONF_TOOL := NO
HDPARM_MAKE_ENV := $(CROSS_ENV)

HDPARM_INSTALL_OPT := \
	binprefix=/usr \
	install

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/hdparm.targetinstall:
	@$(call targetinfo)

	@$(call install_init, hdparm)
	@$(call install_fixup, hdparm,PRIORITY,optional)
	@$(call install_fixup, hdparm,SECTION,base)
	@$(call install_fixup, hdparm,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, hdparm,DESCRIPTION,missing)

	@$(call install_copy, hdparm, 0, 0, 0755, -, /usr/sbin/hdparm)

	@$(call install_finish, hdparm)

	@$(call touch)

# vim: syntax=make
