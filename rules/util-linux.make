# -*-makefile-*-
# $Id: util-linux.make,v 1.7 2003/12/08 12:39:19 bsp Exp $
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_UTLNX
PACKAGES += util-linux
endif

#
# Paths and names
#
UTIL-LINUX_VERSION	= 2.12
UTIL-LINUX		= util-linux-$(UTIL-LINUX_VERSION)
UTIL-LINUX_SUFFIX	= tar.gz
UTIL-LINUX_URL		= http://ftp.cwi.nl/aeb/util-linux/$(UTIL-LINUX).$(UTIL-LINUX_SUFFIX)
UTIL-LINUX_SOURCE	= $(SRCDIR)/$(UTIL-LINUX).$(UTIL-LINUX_SUFFIX)
UTIL-LINUX_DIR		= $(BUILDDIR)/$(UTIL-LINUX)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

util-linux_get: $(STATEDIR)/util-linux.get

util-linux_get_deps	=  $(UTIL-LINUX_SOURCE)

$(STATEDIR)/util-linux.get: $(util-linux_get_deps)
	@$(call targetinfo, $@)
	@$(call get_patches, $(UTIL-LINUX))
	touch $@

$(UTIL-LINUX_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(UTIL-LINUX_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

util-linux_extract: $(STATEDIR)/util-linux.extract

util-linux_extract_deps	=  $(STATEDIR)/util-linux.get

$(STATEDIR)/util-linux.extract: $(util-linux_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(UTIL-LINUX_DIR))
	@$(call extract, $(UTIL-LINUX_SOURCE))
	@$(call patchin, $(UTIL-LINUX))
	touch $@
	
# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

util-linux_prepare: $(STATEDIR)/util-linux.prepare

#
# dependencies
#
util-linux_prepare_deps =  \
	$(STATEDIR)/util-linux.extract \
	$(STATEDIR)/virtual-xchain.install

UTIL-LINUX_PATH	=  PATH=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/bin:$(CROSS_PATH)
UTIL-LINUX_ENV 	=  $(CROSS_ENV)

$(STATEDIR)/util-linux.prepare: $(util-linux_prepare_deps)
	@$(call targetinfo, $@)
	cd $(UTIL-LINUX_DIR) && \
		$(UTIL-LINUX_PATH) $(UTIL-LINUX_ENV) \
		./configure
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

util-linux_compile: $(STATEDIR)/util-linux.compile

util-linux_compile_deps =  $(STATEDIR)/util-linux.prepare

$(STATEDIR)/util-linux.compile: $(util-linux_compile_deps)
	@$(call targetinfo, $@)

ifdef PTXCONF_UTLNX_MKSWAP
	$(UTIL-LINUX_PATH) make -C $(UTIL-LINUX_DIR)/disk-utils mkswap
endif
ifdef PTXCONF_UTLNX_SWAPON
	$(UTIL-LINUX_PATH) make -C $(UTIL-LINUX_DIR)/mount swapon
endif	
ifdef PTXCONF_UTLNX_IPCS
	$(UTIL-LINUX_PATH) make -C $(UTIL-LINUX_DIR)/sys-utils ipcs
endif
ifdef PTXCONF_UTLNX_READPROFILE
	$(UTIL-LINUX_PATH) make -C $(UTIL-LINUX_DIR)/sys-utils readprofile
endif
#
# FIXME: implement other utilities
#
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

util-linux_install: $(STATEDIR)/util-linux.install

$(STATEDIR)/util-linux.install: $(STATEDIR)/util-linux.compile
	@$(call targetinfo, $@)
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

util-linux_targetinstall: $(STATEDIR)/util-linux.targetinstall

util-linux_targetinstall_deps	=  $(STATEDIR)/util-linux.compile

$(STATEDIR)/util-linux.targetinstall: $(util-linux_targetinstall_deps)
	@$(call targetinfo, $@)
ifdef PTXCONF_UTLNX_MKSWAP
	install -D $(UTIL-LINUX_DIR)/disk-utils/mkswap $(ROOTDIR)/sbin/mkswap
	$(CROSSSTRIP) -R .note -R comment $(ROOTDIR)/sbin/mkswap
endif
ifdef PTXCONF_UTLNX_SWAPON
	install -D $(UTIL-LINUX_DIR)/mount/swapon $(ROOTDIR)/sbin/swapon
	$(CROSSSTRIP) -R .note -R comment $(ROOTDIR)/sbin/swapon
endif
ifdef PTXCONF_UTLNX_IPCS
	install -D $(UTIL-LINUX_DIR)/sys-utils/ipcs $(ROOTDIR)/usr/bin/ipcs
	$(CROSSSTRIP) -R .note -R comment $(ROOTDIR)/usr/bin/ipcs
endif
ifdef PTXCONF_UTLNX_READPROFILE
	install -D $(UTIL-LINUX_DIR)/sys-utils/readprofile $(ROOTDIR)/usr/sbin/readprofile
	$(CROSSSTRIP) -R .note -R comment $(ROOTDIR)/usr/sbin/readprofile
endif
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

util-linux_clean:
	rm -rf $(STATEDIR)/util-linux.*
	rm -rf $(UTIL-LINUX_DIR)

# vim: syntax=make
