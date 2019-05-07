# -*-makefile-*-
#
# Copyright (C) 2018, 2019 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_PATCHELF) += host-patchelf

#
# Paths and names
#
HOST_PATCHELF_VERSION	:= 0.10
HOST_PATCHELF_MD5	:= 228ade8c1b4033670bcf7f77c0ea1fb7
HOST_PATCHELF		:= patchelf-$(HOST_PATCHELF_VERSION)
HOST_PATCHELF_SUFFIX	:= tar.gz
HOST_PATCHELF_URL	:= https://nixos.org/releases/patchelf/$(HOST_PATCHELF)/$(HOST_PATCHELF).$(HOST_PATCHELF_SUFFIX)
HOST_PATCHELF_SOURCE	:= $(SRCDIR)/$(HOST_PATCHELF).$(HOST_PATCHELF_SUFFIX)
HOST_PATCHELF_DIR	:= $(HOST_BUILDDIR)/$(HOST_PATCHELF)
HOST_PATCHELF_LICENSE	:= GPL-3.0-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_PATCHELF_CONF_TOOL	:= autoconf

# vim: syntax=make
