# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Pengutronix e.K., Hildesheim, Germany
# See CREDITS for details about who has contributed to this project. 
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_WIRELESS
PACKAGES += wireless
endif

#
# Paths and names 
#
WIRELESS_VERSION	= 27
WIRELESS		= wireless_tools.$(WIRELESS_VERSION)
WIRELESS_SUFFIX		= tar.gz
WIRELESS_URL		= http://pcmcia-cs.sourceforge.net/ftp/contrib/$(WIRELESS).$(WIRELESS_SUFFIX)
WIRELESS_SOURCE		= $(SRCDIR)/$(WIRELESS).$(WIRELESS_SUFFIX)
WIRELESS_DIR 		= $(BUILDDIR)/$(WIRELESS)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

wireless_get: $(STATEDIR)/wireless.get

wireless_get_deps	= $(WIRELESS_SOURCE)

$(STATEDIR)/wireless.get: $(wireless_get_deps)
	@$(call targetinfo, $@)
	touch $@

$(WIRELESS_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(WIRELESS_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

wireless_extract: $(STATEDIR)/wireless.extract

wireless_extract_deps	= $(STATEDIR)/wireless.get

$(STATEDIR)/wireless.extract: $(wireless_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(WIRELESS_DIR))
	@$(call extract, $(WIRELESS_SOURCE))
	@$(call patchin, $(WIRELESS))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

wireless_prepare: $(STATEDIR)/wireless.prepare

wireless_prepare_deps	= $(STATEDIR)/wireless.extract

$(STATEDIR)/wireless.prepare: $(wireless_prepare_deps)
	@$(call targetinfo, $@)
ifdef PTXCONF_WIRELESS_SHARED
	@$(call disable_sh,$(WIRELESS_DIR)/Makefile,BUILD_STATIC)
else
	@$(call enable_sh, $(WIRELESS_DIR)/Makefile,BUILD_STATIC)
endif
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------
WIRELESS_PATH	=  PATH=$(CROSS_PATH)
WIRELESS_ENV 	=  $(CROSS_ENV)

wireless_compile: $(STATEDIR)/wireless.compile

wireless_compile_deps	= $(STATEDIR)/wireless.prepare

$(STATEDIR)/wireless.compile: $(wireless_compile_deps) 
	@$(call targetinfo, $@)
	cd $(WIRELESS_DIR) && $(WIRELESS_PATH) $(WIRELESS_ENV) make CC=${CROSS_CC}
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

wireless_install: $(STATEDIR)/wireless.install

wireless_compile_deps	= $(STATEDIR)/wireless.compile

$(STATEDIR)/wireless.install: $(wireless_compile_deps)
	@$(call targetinfo, $@)
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

wireless_targetinstall: $(STATEDIR)/wireless.targetinstall

$(STATEDIR)/wireless.targetinstall: $(STATEDIR)/wireless.install
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,wireless)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(WIRELESS_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,DEPENDS,libc)
	@$(call install_fixup,DESCRIPTION,missing)

	@$(call install_copy, 0, 0, 0755, $(WIRELESS_DIR)/iwconfig, /usr/sbin/iwconfig)
	@$(call install_copy, 0, 0, 0755, $(WIRELESS_DIR)/iwlist, /usr/sbin/iwlist)
	@$(call install_copy, 0, 0, 0755, $(WIRELESS_DIR)/iwpriv, /usr/sbin/iwpriv)
	@$(call install_copy, 0, 0, 0755, $(WIRELESS_DIR)/iwspy, /usr/sbin/iwspy)
	@$(call install_copy, 0, 0, 0755, $(WIRELESS_DIR)/iwgetid, /usr/sbin/iwgetid)
	@$(call install_copy, 0, 0, 0755, $(WIRELESS_DIR)/iwevent, /usr/sbin/iwevent)

ifdef PTXCONF_WIRELESS_SHARED
	@$(call install_copy, 0, 0, 0644, $(WIRELESS_DIR)/libiw.so.$(WIRELESS_VERSION), \
		/usr/lib/libiw.so.$(WIRELESS_VERSION))
endif

	@$(call install_finish)
	
	touch $@
# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

wireless_clean: 
	rm -rf $(STATEDIR)/wireless.* 
	rm -rf $(IMAGEDIR)/wireless_* 
	rm -rf $(WIRELESS_DIR)

# vim: syntax=make
