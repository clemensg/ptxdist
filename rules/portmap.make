# -*-makefile-*-
#
# Copyright (C) 2002 by Pengutronix e.K., Hildesheim, Germany
#               2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#               2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PORTMAP) += portmap

#
# Paths and names
#
PORTMAP_VERSION := 6.0
PORTMAP_MD5	:= ac108ab68bf0f34477f8317791aaf1ff
PORTMAP		:= portmap_$(PORTMAP_VERSION)
PORTMAP_SUFFIX	:= tgz
PORTMAP_URL	:= http://fossies.org/linux/misc/old/portmap-$(PORTMAP_VERSION).$(PORTMAP_SUFFIX)
PORTMAP_SOURCE	:= $(SRCDIR)/portmap-$(PORTMAP_VERSION).$(PORTMAP_SUFFIX)
PORTMAP_DIR	:= $(BUILDDIR)/$(PORTMAP)
PORTMAP_LICENSE := BSD-4-Clause-UC AND unknown
PORTMAP_LICENSE_FILES := \
	file://portmap.c;startline=1;endline=32;md5=eab9bc1a44f8936c130f91f7a079ff54 \
	file://portmap.c;startline=45;endline=77;md5=031846750f4058d98079ec93d1a46d8b

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

PORTMAP_ENV		:= $(CROSS_ENV)
PORTMAP_PATH		:= PATH=$(CROSS_PATH)
PORTMAP_MAKE_OPT	:= CC=$(CROSS_CC) NO_TCP_WRAPPER=yes

PORTMAP_INSTALL_OPT	:= BASEDIR=$(PORTMAP_PKGDIR) install

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/portmap.targetinstall:
	@$(call targetinfo)

	@$(call install_init, portmap)
	@$(call install_fixup, portmap,PRIORITY,optional)
	@$(call install_fixup, portmap,SECTION,base)
	@$(call install_fixup, portmap,AUTHOR,"Juergen Beisert <jbeisert@netscape.net>")
	@$(call install_fixup, portmap,DESCRIPTION,missing)

	@$(call install_copy, portmap, 0, 0, 0755, -, /sbin/portmap)

	#
	# busybox init
	#
ifdef PTXCONF_INITMETHOD_BBINIT
ifdef PTXCONF_PORTMAP_STARTSCRIPT
	@$(call install_alternative, portmap, 0, 0, 0755, /etc/init.d/portmapd, n)

ifneq ($(call remove_quotes,$(PTXCONF_PORTMAP_BBINIT_LINK)),)
	@$(call install_link, portmap, \
		../init.d/portmapd, \
		/etc/rc.d/$(PTXCONF_PORTMAP_BBINIT_LINK))
endif
endif
endif
	@$(call install_finish, portmap)
	@$(call touch)

# vim: syntax=make
