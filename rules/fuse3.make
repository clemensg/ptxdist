# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_FUSE3) += fuse3

#
# Paths and names
#
FUSE3_VERSION	:= 3.4.1
FUSE3_MD5	:= 68eac68b19997bea69c4d94f110003f0
FUSE3		:= fuse-$(FUSE3_VERSION)
FUSE3_SUFFIX	:= tar.xz
FUSE3_URL	:= https://github.com/libfuse/libfuse/releases/download/$(FUSE3)/$(FUSE3).$(FUSE3_SUFFIX)
FUSE3_SOURCE	:= $(SRCDIR)/$(FUSE3).$(FUSE3_SUFFIX)
FUSE3_DIR	:= $(BUILDDIR)/$(FUSE3)
FUSE3_LICENSE	:= GPL-2.0-only AND LGPL-2.1-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# meson
#
FUSE_CONF_TOOL	:= meson
FUSE_CONF_OPT	:= \
	$(CROSS_MESON_USR) \
	-Ddisable-mtab=true \
	-Dexamples=false \
	-Dudevrulesdir=/usr/lib/udev/rules.d \
	-Dutils=$(call ptx/truefalse,PTXCONF_FUSE_UTIL)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/fuse3.targetinstall:
	@$(call targetinfo)

	@$(call install_init, fuse3)
	@$(call install_fixup, fuse3,PRIORITY,optional)
	@$(call install_fixup, fuse3,SECTION,base)
	@$(call install_fixup, fuse3,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, fuse3,DESCRIPTION,missing)

	@$(call install_alternative, fuse3, 0, 0, 0644, \
		/usr/lib/udev/rules.d/99-fuse3.rules)

	@$(call install_lib, fuse3, 0, 0, 0644, libfuse3)
	@$(call install_copy, fuse3, 0, 0, 4755, -, /usr/bin/fusermount3)
	@$(call install_copy, fuse3, 0, 0, 0755, -, /usr/sbin/mount.fuse3)

	@$(call install_finish, fuse3)

	@$(call touch)

# vim: syntax=make
