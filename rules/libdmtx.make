# -*-makefile-*-
#
# Copyright (C) 2011 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBDMTX) += libdmtx

#
# Paths and names
#
LIBDMTX_VERSION	:= 0.7.2
LIBDMTX_MD5	:= 8e7544ff8b6ffac66f39edb58cb96167
LIBDMTX		:= libdmtx-$(LIBDMTX_VERSION)
LIBDMTX_SUFFIX	:= tar.gz
LIBDMTX_URL	:= https://github.com/dmtx/libdmtx/archive/v$(LIBDMTX_VERSION).$(LIBDMTX_SUFFIX)
LIBDMTX_SOURCE	:= $(SRCDIR)/$(LIBDMTX).$(LIBDMTX_SUFFIX)
LIBDMTX_DIR	:= $(BUILDDIR)/$(LIBDMTX)
LIBDMTX_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBDMTX_CONF_ENV = \
	$(CROSS_ENV) \
	PYTHON=$(CROSS_PYTHON)

#
# autoconf
#
LIBDMTX_CONF_TOOL	:= autoconf
LIBDMTX_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-cocoa \
	--disable-java \
	--disable-net \
	--disable-php \
	--disable-ruby \
	--disable-vala \
	--$(call ptx/endis, PTXCONF_LIBDMTX_DMTXQUERY)-dmtxquery \
	--$(call ptx/endis, PTXCONF_LIBDMTX_DMTXREAD)-dmtxread \
	--$(call ptx/endis, PTXCONF_LIBDMTX_DMTXWRITE)-dmtxwrite \
	--$(call ptx/endis, PTXCONF_LIBDMTX_PYTHON)-python


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libdmtx.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libdmtx)
	@$(call install_fixup, libdmtx,PRIORITY,optional)
	@$(call install_fixup, libdmtx,SECTION,base)
	@$(call install_fixup, libdmtx,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, libdmtx,DESCRIPTION,missing)

	@$(call install_lib, libdmtx, 0, 0, 0644, libdmtx)

ifdef PTXCONF_LIBDMTX_DMTXQUERY
	@$(call install_copy, libdmtx, 0, 0, 0755, -, /usr/bin/dmtxquery)
endif
ifdef PTXCONF_LIBDMTX_DMTXREAD
	@$(call install_copy, libdmtx, 0, 0, 0755, -, /usr/bin/dmtxread)
endif
ifdef PTXCONF_LIBDMTX_DMTXWRITE
	@$(call install_copy, libdmtx, 0, 0, 0755, -, /usr/bin/dmtxwrite)
endif

ifdef PTXCONF_LIBDMTX_PYTHON
	@$(call install_copy, libdmtx, 0, 0, 0644, -, \
		/usr/lib/python$(PYTHON_MAJORMINOR)/site-packages/pydmtx.pyc)
	@$(call install_copy, libdmtx, 0, 0, 0644, -, \
		/usr/lib/python$(PYTHON_MAJORMINOR)/site-packages/_pydmtx.so)
endif

	@$(call install_finish, libdmtx)

	@$(call touch)

# vim: syntax=make
