# -*-makefile-*-
#
# Copyright (C) 2019 by Lucas Stach <l.stach@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_CMAKE_ECM) += host-cmake-ecm

#
# Paths and names
#
HOST_CMAKE_ECM_VERSION		:= 5.56.0
HOST_CMAKE_ECM_MD5		:= 89be75b53098e1e6cd9b2e30b0bb9e44
HOST_CMAKE_ECM			:= extra-cmake-modules-$(HOST_CMAKE_ECM_VERSION)
HOST_CMAKE_ECM_SUFFIX		:= tar.xz
HOST_CMAKE_ECM_URL		:= https://download.kde.org/stable/frameworks/$(basename $(HOST_CMAKE_ECM_VERSION))/$(HOST_CMAKE_ECM).$(HOST_CMAKE_ECM_SUFFIX)
HOST_CMAKE_ECM_SOURCE		:= $(SRCDIR)/$(HOST_CMAKE_ECM).$(HOST_CMAKE_ECM_SUFFIX)
HOST_CMAKE_ECM_DIR		:= $(HOST_BUILDDIR)/$(HOST_CMAKE_ECM)
HOST_CMAKE_ECM_LICENSE		:= BSD-3-Clause

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_CMAKE_ECM_CONF_TOOL	:= cmake

# vim: syntax=make
