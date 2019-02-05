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
PACKAGES-$(PTXCONF_SSHFS) += sshfs

#
# Paths and names
#
SSHFS_VERSION	:= 3.5.1
SSHFS_MD5	:= cae9508b97c938727e354448b40693cc
SSHFS		:= sshfs-$(SSHFS_VERSION)
SSHFS_SUFFIX	:= tar.xz
SSHFS_URL	:= https://github.com/libfuse/sshfs/releases/download/$(SSHFS)/$(SSHFS).$(SSHFS_SUFFIX)
SSHFS_SOURCE	:= $(SRCDIR)/$(SSHFS).$(SSHFS_SUFFIX)
SSHFS_DIR	:= $(BUILDDIR)/$(SSHFS)
SSHFS_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# meson
#
SSHFS_CONF_TOOL	:= meson

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/sshfs.targetinstall:
	@$(call targetinfo)

	@$(call install_init, sshfs)
	@$(call install_fixup, sshfs,PRIORITY,optional)
	@$(call install_fixup, sshfs,SECTION,base)
	@$(call install_fixup, sshfs,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, sshfs,DESCRIPTION,missing)

	@$(call install_copy, sshfs, 0, 0, 0755, -, /usr/bin/sshfs)
	@$(call install_link, sshfs, ../bin/sshfs, /usr/sbin/mount.sshfs)
	@$(call install_link, sshfs, ../bin/sshfs, /usr/sbin/mount.fuse.sshfs)

	@$(call install_finish, sshfs)

	@$(call touch)

# vim: syntax=make
