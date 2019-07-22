# -*-makefile-*-
#
# Copyright (C) 2003 by Benedikt Spranger
#               2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DNSMASQ) += dnsmasq

#
# Paths and names
#
DNSMASQ_VERSION		:= 2.80
DNSMASQ_MD5		:= e040e72e6f377a784493c36f9e788502
DNSMASQ			:= dnsmasq-$(DNSMASQ_VERSION)
DNSMASQ_SUFFIX		:= tar.xz
DNSMASQ_URL		:= http://www.thekelleys.org.uk/dnsmasq/$(DNSMASQ).$(DNSMASQ_SUFFIX)
DNSMASQ_SOURCE		:= $(SRCDIR)/$(DNSMASQ).$(DNSMASQ_SUFFIX)
DNSMASQ_DIR		:= $(BUILDDIR)/$(DNSMASQ)
DNSMASQ_LICENSE	:= GPL-2.0-only OR GPL-3.0-only
DNSMASQ_LICENSE_FILES	:= \
	file://COPYING;md5=0636e73ff0215e8d672dc4c32c317bb3 \
	file://COPYING-v3;md5=d32239bcb673463ab874e80d47fae504 \
	file://src/dnsmasq.c;startline=1;endline=15;md5=9142b2fc6c71d7fad3af5ba18b26f0f1


# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

DNSMASQ_PATH := PATH=$(CROSS_PATH)
DNSMASQ_MAKE_ENV := $(CROSS_ENV)

DNSMASQ_COPT :=

ifndef PTXCONF_DNSMASQ_TFTP
DNSMASQ_COPT += -DNO_TFTP
endif

ifndef PTXCONF_GLOBAL_IPV6
DNSMASQ_COPT += -DNO_IPV6
endif

ifndef PTXCONF_DNSMASQ_DHCP
DNSMASQ_COPT += -DNO_DHCP
else
ifndef PTXCONF_DNSMASQ_SCRIPT
DNSMASQ_COPT += -DNO_SCRIPT
else
ifdef PTXCONF_DNSMASQ_SCRIPT_LUA
DNSMASQ_COPT += -DHAVE_LUASCRIPT
endif
endif
endif

ifdef DNSMASQ_DNSSEC
DNSMASQ_COPT += -DHAVE_DNSSEC
endif

DNSMASQ_MAKEVARS := PREFIX=/usr AWK=awk COPTS='$(DNSMASQ_COPT)' "CFLAGS+=-Wall -Wextra -ggdb3 -O2"

$(STATEDIR)/dnsmasq.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/dnsmasq.targetinstall:
	@$(call targetinfo)

	@$(call install_init, dnsmasq)
	@$(call install_fixup, dnsmasq,PRIORITY,optional)
	@$(call install_fixup, dnsmasq,SECTION,base)
	@$(call install_fixup, dnsmasq,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, dnsmasq,DESCRIPTION,"Low Requirements DNS/DHCP daemon")

	@$(call install_copy, dnsmasq, 0, 0, 0755, -, /usr/sbin/dnsmasq)

ifdef PTXCONF_DNSMASQ_INETD
	@$(call install_alternative, dnsmasq, 0, 0, 0644, /etc/inetd.conf.d/dnsmasq)
endif

ifdef PTXCONF_INITMETHOD_BBINIT
ifdef PTXCONF_DNSMASQ_STARTSCRIPT
	@$(call install_alternative, dnsmasq, 0, 0, 0755, /etc/init.d/dnsmasq)

ifneq ($(call remove_quotes,$(PTXCONF_DNSMASQ_BBINIT_LINK)),)
	@$(call install_link, dnsmasq, \
		../init.d/dnsmasq, \
		/etc/rc.d/$(PTXCONF_DNSMASQ_BBINIT_LINK))
endif
endif
endif
ifdef PTXCONF_DNSMASQ_SYSTEMD_UNIT
	@$(call install_alternative, dnsmasq, 0, 0, 0644, \
		/usr/lib/systemd/system/dnsmasq.service)
	@$(call install_link, dnsmasq, ../dnsmasq.service, \
		/usr/lib/systemd/system/network.target.wants/dnsmasq.service)
endif

	@$(call install_alternative, dnsmasq, 0, 0, 0644, /etc/dnsmasq.conf)

ifdef PTXCONF_DNSMASQ_DHCP
#	# for the 'dnsmasq.leases' file
	@$(call install_copy, dnsmasq, 0, 0, 0755, /var/lib/misc)
endif
	@$(call install_finish, dnsmasq)

	@$(call touch)

# vim: syntax=make
