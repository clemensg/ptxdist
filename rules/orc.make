# -*-makefile-*-
#
# Copyright (C) 2011 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_ORC) += orc

#
# Paths and names
#
ORC_VERSION	:= 0.4.30
ORC_MD5		:= 75461700db04870a7cd1d0509a7a56b1
ORC		:= orc-$(ORC_VERSION)
ORC_SUFFIX	:= tar.xz
ORC_URL		:= http://gstreamer.freedesktop.org/data/src/orc/$(ORC).$(ORC_SUFFIX)
ORC_SOURCE	:= $(SRCDIR)/$(ORC).$(ORC_SUFFIX)
ORC_DIR		:= $(BUILDDIR)/$(ORC)
ORC_LICENSE	:= BSD-2-Clause AND BSD-3-Clause

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ORC_BACKEND := all
ifdef PTXCONF_ARCH_ARM_NEON
ORC_BACKEND := neon
endif

#
# autoconf
#
ORC_CONF_TOOL	:= meson
ORC_CONF_OPT	:= \
	$(CROSS_MESON_USR) \
	-Dbenchmarks=disabled \
	-Dexamples=disabled \
	-Dgtk_doc=disabled \
	-Dorc-backend=$(ORC_BACKEND) \
	-Dorc-test=$(call ptx/endis,PTXCONF_ORC_TEST)d
	-Dtests=disabled \
	-Dtools=disabled

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

# don't install orcc it's for the target and should not be used
$(STATEDIR)/orc.install:
	@$(call targetinfo)
	@$(call world/install, ORC)
	@rm $(ORC_PKGDIR)/usr/bin/orcc
	@$(call touch)
# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/orc.targetinstall:
	@$(call targetinfo)

	@$(call install_init, orc)
	@$(call install_fixup, orc,PRIORITY,optional)
	@$(call install_fixup, orc,SECTION,base)
	@$(call install_fixup, orc,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, orc,DESCRIPTION,missing)

	@$(call install_lib, orc, 0, 0, 0644, liborc-0.4)
ifdef PTXCONF_ORC_TEST
	@$(call install_lib, orc, 0, 0, 0644, liborc-test-0.4)
endif

	@$(call install_finish, orc)

	@$(call touch)

# vim: syntax=make
