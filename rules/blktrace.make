# -*-makefile-*-
#
# Copyright (C) 2019 by Jan Luebbe <jlu@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_BLKTRACE) += blktrace

#
# Paths and names
#
BLKTRACE_VERSION	:= 1.2.0
BLKTRACE_MD5		:= b9a80b7cc0a50f7a96d34c570ab8224d
BLKTRACE		:= blktrace-$(BLKTRACE_VERSION)
BLKTRACE_SUFFIX		:= tar.bz2
BLKTRACE_URL		:= http://brick.kernel.dk/snaps/$(BLKTRACE).$(BLKTRACE_SUFFIX)
BLKTRACE_SOURCE		:= $(SRCDIR)/$(BLKTRACE).$(BLKTRACE_SUFFIX)
BLKTRACE_DIR		:= $(BUILDDIR)/$(BLKTRACE)
BLKTRACE_LICENSE	:= GPL-2.0-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

BLKTRACE_CONF_TOOL	:= NO
BLKTRACE_MAKE_PAR	:= NO
BLKTRACE_MAKE_OPT	:= \
	$(CROSS_ENV) \
	prefix=/usr \
	ALL="blktrace blkparse"

BLKTRACE_INSTALL_OPT	:= \
	$(BLKTRACE_MAKE_OPT) \
	install

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/blktrace.targetinstall:
	@$(call targetinfo)

	@$(call install_init, blktrace)
	@$(call install_fixup, blktrace,PRIORITY,optional)
	@$(call install_fixup, blktrace,SECTION,base)
	@$(call install_fixup, blktrace,AUTHOR,"Jan Luebbe <jlu@pengutronix.de>")
	@$(call install_fixup, blktrace,DESCRIPTION,missing)

	@$(call install_copy, blktrace, 0, 0, 0755, -, /usr/bin/blkparse)
	@$(call install_copy, blktrace, 0, 0, 0755, -, /usr/bin/blktrace)

	@$(call install_finish, blktrace)

	@$(call touch)

# vim: syntax=make
