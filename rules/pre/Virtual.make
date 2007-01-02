# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Marc Kleine-Budde <kleine-budde@gmx.de>
# See CREDITS for details about who has contributed to this project. 
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

# ----------------------------------------------------------------------------
# xchain
# ----------------------------------------------------------------------------

virtual-xchain_install: $(STATEDIR)/virtual-xchain.install

ifdef PTXCONF_HOST_FAKEROOT
virtual-xchain_install_deps	+= $(STATEDIR)/host-fakeroot.install
endif

ifdef PTXCONF_HOST_IPKG_UTILS
virtual-xchain_install_deps	+= $(STATEDIR)/host-ipkg-utils.install
endif

ifdef PTXCONF_IMAGE_HOST_DEB
virtual-xchain_install_deps	+= $(STATEDIR)/host-checkinstall.install
endif

ifdef PTXCONF_IMAGE_JFFS2
virtual-xchain_install_deps	+= $(STATEDIR)/host-mtd-utils.install
endif

ifdef PTXCONF_CROSS_PKG_CONFIG_WRAPPER
virtual-xchain_install_deps	+= $(STATEDIR)/cross-pkg-config-wrapper.install
endif

$(STATEDIR)/virtual-xchain.install: $(virtual-xchain_install_deps)
	@$(call targetinfo, $@)
	@$(call touch, $@)
