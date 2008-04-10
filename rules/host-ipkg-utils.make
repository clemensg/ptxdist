# -*-makefile-*-
# $Id$
#
# Copyright (C) 2005 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_IPKG_UTILS) += host-ipkg-utils

#
# Paths and names
#
HOST_IPKG_UTILS_VERSION	:= 050831
HOST_IPKG_UTILS		:= ipkg-utils-$(HOST_IPKG_UTILS_VERSION)
HOST_IPKG_UTILS_SUFFIX	:= tar.gz
HOST_IPKG_UTILS_URL	:= http://www.handhelds.org/download/packages/ipkg-utils/$(HOST_IPKG_UTILS).$(HOST_IPKG_UTILS_SUFFIX)
HOST_IPKG_UTILS_SOURCE	:= $(SRCDIR)/$(HOST_IPKG_UTILS).$(HOST_IPKG_UTILS_SUFFIX)
HOST_IPKG_UTILS_DIR	:= $(HOST_BUILDDIR)/$(HOST_IPKG_UTILS)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

host-ipkg-utils_get: $(STATEDIR)/host-ipkg-utils.get

$(STATEDIR)/host-ipkg-utils.get: $(host-ipkg-utils_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(HOST_IPKG_UTILS_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, HOST_IPKG_UTILS)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

host-ipkg-utils_extract: $(STATEDIR)/host-ipkg-utils.extract

$(STATEDIR)/host-ipkg-utils.extract: $(host-ipkg-utils_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(HOST_IPKG_UTILS_DIR))
	@$(call extract, HOST_IPKG_UTILS, $(HOST_BUILDDIR))
	@$(call patchin, HOST_IPKG_UTILS, $(HOST_IPKG_UTILS_DIR))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

host-ipkg-utils_prepare: $(STATEDIR)/host-ipkg-utils.prepare

HOST_IPKG_UTILS_PATH	:= PATH=$(HOST_PATH)
HOST_IPKG_UTILS_ENV 	:= $(HOST_ENV)
HOST_IPKG_UTILS_MAKEVARS := PREFIX=$(PTXCONF_SYSROOT_HOST)

$(STATEDIR)/host-ipkg-utils.prepare: $(host-ipkg-utils_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

host-ipkg-utils_compile: $(STATEDIR)/host-ipkg-utils.compile

$(STATEDIR)/host-ipkg-utils.compile: $(host-ipkg-utils_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(HOST_IPKG_UTILS_DIR) && $(HOST_IPKG_UTILS_PATH) $(MAKE) $(PARALLELMFLAGS)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

host-ipkg-utils_install: $(STATEDIR)/host-ipkg-utils.install

$(STATEDIR)/host-ipkg-utils.install: $(host-ipkg-utils_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, HOST_IPKG_UTILS,,h)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

host-ipkg-utils_clean:
	rm -rf $(STATEDIR)/host-ipkg-utils.*
	rm -rf $(HOST_IPKG_UTILS_DIR)

# vim: syntax=make
