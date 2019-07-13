# -*-makefile-*-
#
# Copyright (C) 2019 by Lucas Stach <l.stach@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_BLUEZ_QT) += bluez-qt

#
# Paths and names
#
BLUEZ_QT_VERSION	:= 5.56.0
BLUEZ_QT_MD5		:= 2e2a7b4b5a2efbb2acc9c48f9111291f
BLUEZ_QT		:= bluez-qt-$(BLUEZ_QT_VERSION)
BLUEZ_QT_SUFFIX		:= tar.xz
BLUEZ_QT_URL		:= https://download.kde.org/stable/frameworks/$(basename $(BLUEZ_QT_VERSION))/$(BLUEZ_QT).$(BLUEZ_QT_SUFFIX)
BLUEZ_QT_SOURCE		:= $(SRCDIR)/$(BLUEZ_QT).$(BLUEZ_QT_SUFFIX)
BLUEZ_QT_DIR		:= $(BUILDDIR)/$(BLUEZ_QT)
BLUEZ_QT_LICENSE	:= LGPL-2.1-or-later
BLUEZ_QT_LICENSE_FILES	:= file://COPYING.LIB;md5=4fbd65380cdd255951079008b364516c

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

BLUEZ_QT_CONF_TOOL	:= cmake
BLUEZ_QT_CONF_OPT	:= \
		$(CROSS_CMAKE_USR) \
		-DBUILD_QCH=OFF \
		-DBUILD_TESTING=OFF \
		-DECM_DIR=$(PTXDIST_SYSROOT_HOST)/share/ECM/cmake/

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/bluez-qt.targetinstall:
	@$(call targetinfo)

	@$(call install_init, bluez-qt)
	@$(call install_fixup, bluez-qt,PRIORITY,optional)
	@$(call install_fixup, bluez-qt,SECTION,base)
	@$(call install_fixup, bluez-qt,AUTHOR,"Lucas Stach <l.stach@pengutronix.de>")
	@$(call install_fixup, bluez-qt,DESCRIPTION,missing)

	@$(call install_lib, bluez-qt, 0, 0, 0644, libKF5BluezQt)
	@$(call install_tree, bluez-qt, 0, 0, -, /usr/lib/qt5/qml)

	@$(call install_finish, bluez-qt)

	@$(call touch)

# vim: syntax=make
