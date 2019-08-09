# -*-makefile-*-
#
# Copyright (C) 2017 by Alexander Dahl <ada@thorsis.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_MOSQUITTO) += mosquitto

#
# Paths and names
#
MOSQUITTO_VERSION	:= 1.6.4
MOSQUITTO_MD5		:= c89df444afb121d795f8af5b4fd97d78
MOSQUITTO		:= mosquitto-$(MOSQUITTO_VERSION)
MOSQUITTO_SUFFIX	:= tar.gz
MOSQUITTO_URL		:= https://mosquitto.org/files/source/$(MOSQUITTO).$(MOSQUITTO_SUFFIX)
MOSQUITTO_SOURCE	:= $(SRCDIR)/$(MOSQUITTO).$(MOSQUITTO_SUFFIX)
MOSQUITTO_DIR		:= $(BUILDDIR)/$(MOSQUITTO)
# "Eclipse Distribution License - v 1.0" is in fact BSD-3-Clause
MOSQUITTO_LICENSE	:= EPL-1.0 AND BSD-3-Clause
MOSQUITTO_LICENSE_FILES	:= file://epl-v10;md5=8d383c379e91d20ba18a52c3e7d3a979 \
	file://edl-v10;md5=c09f121939f063aeb5235972be8c722c

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

MOSQUITTO_CONF_TOOL	:= NO
MOSQUITTO_MAKE_ENV	:= $(CROSS_ENV)
MOSQUITTO_MAKE_OPT	:= \
	UNAME=Linux \
	prefix=/usr \
	WITH_WRAP=no \
	WITH_TLS=$(call ptx/yesno, PTXCONF_MOSQUITTO_TLS) \
	WITH_TLS_PSK=$(call ptx/yesno, PTXCONF_MOSQUITTO_TLS) \
	WITH_THREADING=yes \
	WITH_BRIDGE=yes \
	WITH_PERSISTENCE=yes \
	WITH_MEMORY_TRACKING=yes \
	WITH_SYS_TREE=yes \
	WITH_SYSTEMD=$(call ptx/yesno, PTXCONF_MOSQUITTO_SYSTEMD_UNIT) \
	WITH_SRV=$(call ptx/yesno, PTXCONF_MOSQUITTO_SRV) \
	WITH_WEBSOCKETS=no \
	WITH_EC=yes \
	WITH_DOCS=no \
	WITH_SOCKS=yes \
	WITH_STRIP=yes \
	WITH_STATIC_LIBRARIES=no \
	WITH_SHARED_LIBRARIES=yes \
	WITH_ADNS=no \
	WITH_EPOLL=yes \
	WITH_BUNDLED_DEPS=yes \
	WITH_COVERAGE=no
MOSQUITTO_INSTALL_OPT	:= \
	$(MOSQUITTO_MAKE_OPT) \
	install

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------
$(STATEDIR)/mosquitto.install:
	@$(call targetinfo)
	@$(call world/install, MOSQUITTO)
	@install -v -D -m644 $(MOSQUITTO_DIR)/mosquitto.conf \
		$(MOSQUITTO_PKGDIR)/etc/mosquitto/mosquitto.conf
	@install -v -D -m644 $(MOSQUITTO_DIR)/service/systemd/mosquitto.service.notify \
		$(MOSQUITTO_PKGDIR)/usr/lib/systemd/system/mosquitto.service
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/mosquitto.targetinstall:
	@$(call targetinfo)

	@$(call install_init, mosquitto)
	@$(call install_fixup, mosquitto,PRIORITY,optional)
	@$(call install_fixup, mosquitto,SECTION,base)
	@$(call install_fixup, mosquitto,AUTHOR,"Alexander Dahl <ada@thorsis.com>")
	@$(call install_fixup, mosquitto,DESCRIPTION,missing)

	@$(call install_lib, mosquitto, 0, 0, 0644, libmosquitto)
	@$(call install_lib, mosquitto, 0, 0, 0644, libmosquittopp)

ifdef PTXCONF_MOSQUITTO_CLIENTS
	@$(call install_copy, mosquitto, 0, 0, 0755, -, /usr/bin/mosquitto_pub)
	@$(call install_copy, mosquitto, 0, 0, 0755, -, /usr/bin/mosquitto_sub)
endif

ifdef PTXCONF_MOSQUITTO_BROKER
	@$(call install_copy, mosquitto, 0, 0, 0755, -, /usr/sbin/mosquitto)
	@$(call install_alternative, mosquitto, 0, 0, 0644, \
		/etc/mosquitto/mosquitto.conf)

ifdef PTXCONF_MOSQUITTO_SYSTEMD_UNIT
	@$(call install_copy, mosquitto, 0, 0, 0644, -, \
		/usr/lib/systemd/system/mosquitto.service)
	@$(call install_link, mosquitto, ../mosquitto.service, \
		/usr/lib/systemd/system/multi-user.target.wants/mosquitto.service)
endif
endif

	@$(call install_finish, mosquitto)

	@$(call touch)

# vim: ft=make noet ts=8 sw=8
