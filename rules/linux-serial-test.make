# -*-makefile-*-
#
# Copyright (C) 2019 by Jan Luebbe <jlu@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LINUX_SERIAL_TEST) += linux-serial-test

#
# Paths and names
#
LINUX_SERIAL_TEST_VERSION	:= 2018-09-13-gaed2a6e78160
LINUX_SERIAL_TEST_MD5		:= 6aa8351c219b585a8cccecfe74dd964e
LINUX_SERIAL_TEST		:= linux-serial-test-$(LINUX_SERIAL_TEST_VERSION)
LINUX_SERIAL_TEST_SUFFIX	:= tar.gz
LINUX_SERIAL_TEST_URL		:= https://github.com/cbrake/linux-serial-test/archive/$(LINUX_SERIAL_TEST_VERSION).tar.gz
LINUX_SERIAL_TEST_SOURCE	:= $(SRCDIR)/$(LINUX_SERIAL_TEST).$(LINUX_SERIAL_TEST_SUFFIX)
LINUX_SERIAL_TEST_DIR		:= $(BUILDDIR)/$(LINUX_SERIAL_TEST)
LINUX_SERIAL_TEST_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# cmake
#
LINUX_SERIAL_TEST_CONF_TOOL	:= cmake

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/linux-serial-test.targetinstall:
	@$(call targetinfo)

	@$(call install_init, linux-serial-test)
	@$(call install_fixup, linux-serial-test,PRIORITY,optional)
	@$(call install_fixup, linux-serial-test,SECTION,base)
	@$(call install_fixup, linux-serial-test,AUTHOR,"Jan Luebbe <jlu@pengutronix.de>")
	@$(call install_fixup, linux-serial-test,DESCRIPTION,missing)

	@$(call install_copy, linux-serial-test, 0, 0, 0755, -, /usr/bin/linux-serial-test)

	@$(call install_finish, linux-serial-test)

	@$(call touch)

# vim: syntax=make
