# -*-makefile-*-
#
# Copyright (C) 2017, 2019 by Ladislav Michl <ladis@linux-mips.org>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_CRYPTODEV) += cryptodev

#
# Paths and names and versions
#
CRYPTODEV_VERSION	:= 1.10
CRYPTODEV_MD5		:= 53403fbb99cd88a48bc899dbe9158e1c
CRYPTODEV		:= cryptodev-linux-$(CRYPTODEV_VERSION)
CRYPTODEV_SUFFIX	:= tar.gz
CRYPTODEV_URL		:= \
	https://github.com/cryptodev-linux/cryptodev-linux/archive/$(CRYPTODEV).$(CRYPTODEV_SUFFIX)
CRYPTODEV_SOURCE	:= $(SRCDIR)/$(CRYPTODEV).$(CRYPTODEV_SUFFIX)
CRYPTODEV_DIR		:= $(BUILDDIR)/$(CRYPTODEV)
CRYPTODEV_LICENSE	:= GPL-2.0

ifdef PTXCONF_CRYPTODEV
$(STATEDIR)/kernel.targetinstall.post: $(STATEDIR)/cryptodev.targetinstall
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CRYPTODEV_WRAPPER_BLACKLIST = $(KERNEL_WRAPPER_BLACKLIST)

CRYPTODEV_CONF_TOOL := NO

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

CRYPTODEV_MAKE_OPT = \
	$(KERNEL_MAKE_OPT) \
	KERNEL_DIR=$(KERNEL_DIR) \
	DESTDIR=$(CRYPTODEV_PKGDIR) \
	prefix=/usr \
	-C $(CRYPTODEV_DIR)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cryptodev.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cryptodev.targetinstall:
	@$(call targetinfo)
	@$(call compile, CRYPTODEV, $(CRYPTODEV_MAKE_OPT) install)
	@$(call touch)

# vim: syntax=make
