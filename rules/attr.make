# -*-makefile-*-
#
# Copyright (C) 2008 by Robert Schwebel
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_ATTR) += attr

#
# Paths and names
#
ATTR_VERSION	:= 2.4.48
ATTR_MD5	:= bc1e5cb5c96d99b24886f1f527d3bb3d
ATTR		:= attr-$(ATTR_VERSION)
ATTR_SUFFIX	:= tar.gz
ATTR_SOURCE	:= $(SRCDIR)/$(ATTR).$(ATTR_SUFFIX)
ATTR_DIR	:= $(BUILDDIR)/$(ATTR)
ATTR_LICENSE	:= GPL-2.0-only AND LGPL-2.0-only
ATTR_LICENSE_FILES := \
	file://doc/COPYING;md5=2d0aa14b3fce4694e4f615e30186335f \
	file://doc/COPYING.LGPL;md5=b8d31f339300bc239d73461d68e77b9c

ATTR_URL	:= \
	http://download.savannah.gnu.org/releases/attr/$(ATTR).$(ATTR_SUFFIX) \
	http://mirrors.zerg.biz/nongnu/attr/$(ATTR).$(ATTR_SUFFIX)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
ATTR_CONF_TOOL	:= autoconf
ATTR_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-nls \
	--disable-rpath \
	--disable-debug

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/attr.targetinstall:
	@$(call targetinfo)

	@$(call install_init, attr)
	@$(call install_fixup, attr,PRIORITY,optional)
	@$(call install_fixup, attr,SECTION,base)
	@$(call install_fixup, attr,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, attr,DESCRIPTION,missing)

ifdef PTXCONF_ATTR_TOOLS
	@$(call install_copy, attr, 0, 0, 0755, -, /usr/bin/attr)
	@$(call install_copy, attr, 0, 0, 0755, -, /usr/bin/setfattr)
	@$(call install_copy, attr, 0, 0, 0755, -, /usr/bin/getfattr)
endif
	@$(call install_lib, attr, 0, 0, 0644, libattr)

	@$(call install_finish, attr)

	@$(call touch)

# vim: syntax=make
