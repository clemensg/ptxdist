# -*-makefile-*-
#
# Copyright (C) 2019 by Ladislav Michl <ladis@linux-mips.org>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_SDBUS_CPP) += sdbus-cpp

#
# Paths and names
#
SDBUS_CPP_VERSION	:= 0.7.2
SDBUS_CPP_MD5		:= b8bbaf9002ba989778967fc4f9e31e2f
SDBUS_CPP		:= sdbus-cpp-$(SDBUS_CPP_VERSION)
SDBUS_CPP_SUFFIX	:= tar.gz
SDBUS_CPP_URL		:= https://github.com/Kistler-Group/sdbus-cpp/archive/v$(SDBUS_CPP_VERSION).$(SDBUS_CPP_SUFFIX)
SDBUS_CPP_SOURCE	:= $(SRCDIR)/$(SDBUS_CPP).$(SDBUS_CPP_SUFFIX)
SDBUS_CPP_DIR		:= $(BUILDDIR)/$(SDBUS_CPP)
SDBUS_CPP_LICENSE	:= LGPL-2.1-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

SDBUS_CPP_CONF_TOOL	:= cmake
SDBUS_CPP_CONF_OPT	:= \
	$(CROSS_CMAKE_USR) \
	-DBUILD_TESTS=OFF \
	-DBUILD_CODE_GEN=OFF \
	-DBUILD_DOC=OFF

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/sdbus-cpp.targetinstall:
	@$(call targetinfo)

	@$(call install_init, sdbus-cpp)
	@$(call install_fixup, sdbus-cpp, PRIORITY, optional)
	@$(call install_fixup, sdbus-cpp, SECTION, base)
	@$(call install_fixup, sdbus-cpp, AUTHOR, "Ladislav Michl <ladis@linux-mips.org>")
	@$(call install_fixup, sdbus-cpp, DESCRIPTION, \
		"D-Bus IPC C++ binding library built on top of sd-bus")

	@$(call install_lib, sdbus-cpp, 0, 0, 0644, libsdbus-c++)

	@$(call install_finish, sdbus-cpp)

	@$(call touch)

# vim: syntax=make
