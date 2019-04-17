# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Tretter <m.tretter@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_WLROOTS) += wlroots

#
# Paths and names
#
WLROOTS_VERSION	:= 0.5.0
WLROOTS_MD5	:= d186d57cd7aeca3d8af10e2d88575875
WLROOTS		:= wlroots-$(WLROOTS_VERSION)
WLROOTS_SUFFIX	:= tar.gz
WLROOTS_URL	:= https://github.com/swaywm/wlroots/archive/$(WLROOTS_VERSION).$(WLROOTS_SUFFIX)
WLROOTS_SOURCE	:= $(SRCDIR)/$(WLROOTS).$(WLROOTS_SUFFIX)
WLROOTS_DIR	:= $(BUILDDIR)/$(WLROOTS)
WLROOTS_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

WLROOTS_CONF_TOOL := meson
WLROOTS_CONF_OPT := \
	$(CROSS_MESON_USR) \
	-Denable-enable-examples=false \
	-Denable-enable-rootston=$(call ptx/truefalse,PTXCONF_WLROOTS_ROOTSTON) \
	-Denable-x11_backend=false \
	-Denable-xwayland=false \
	-Dwerror=false

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/wlroots.targetinstall:
	@$(call targetinfo)

	@$(call install_init, wlroots)
	@$(call install_fixup, wlroots,PRIORITY,optional)
	@$(call install_fixup, wlroots,SECTION,base)
	@$(call install_fixup, wlroots,AUTHOR,"Michael Tretter <m.tretter@pengutronix.de>")
	@$(call install_fixup, wlroots,DESCRIPTION,missing)

	@$(call install_lib, wlroots, 0, 0, 0644, libwlroots)

ifdef PTXCONF_WLROOTS_ROOTSTON
	@$(call install_copy, wlroots, 0, 0, 0755, \
		$(WLROOTS_DIR)-build/rootston/rootston, /usr/bin/rootston)
endif

	@$(call install_finish, wlroots)

	@$(call touch)

# vim: syntax=make
