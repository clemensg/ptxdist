# -*-makefile-*-
#
# Copyright (C) 2009, 2017 by Robert Schwebel <r.schwebel@pengutronix.de>
#           (C) 2012 by Jan Luebbe <j.luebbe@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_NETWORKMANAGER) += networkmanager

#
# Paths and names
#
NETWORKMANAGER_VERSION	:= 1.20.0
NETWORKMANAGER_MD5	:= 109df9b0813755a98735206f5b2d68da
NETWORKMANAGER		:= NetworkManager-$(NETWORKMANAGER_VERSION)
NETWORKMANAGER_SUFFIX	:= tar.xz
NETWORKMANAGER_URL	:= https://ftp.gnome.org/pub/GNOME/sources/NetworkManager/1.20/$(NETWORKMANAGER).$(NETWORKMANAGER_SUFFIX)
NETWORKMANAGER_SOURCE	:= $(SRCDIR)/$(NETWORKMANAGER).$(NETWORKMANAGER_SUFFIX)
NETWORKMANAGER_DIR	:= $(BUILDDIR)/$(NETWORKMANAGER)
NETWORKMANAGER_LICENSE	:= GPL-2.0-or-later AND LGPL-2.0-or-later
NETWORKMANAGER_LICENSE_FILES := file://COPYING;md5=cbbffd568227ada506640fe950a4823b

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# meson
#
NETWORKMANAGER_CONF_TOOL := meson
NETWORKMANAGER_CONF_OPT = \
	$(CROSS_MESON_USR) \
	-Dbluez5_dun=false \
	-Dconcheck=$(call ptx/truefalse,PTXCONF_NETWORKMANAGER_CONCHECK) \
	-Dconfig_dhcp_default=internal \
	-Dconfig_dns_rc_manager_default=file \
	-Dconfig_logging_backend_default=default \
	-Dcrypto=gnutls \
	-Ddbus_conf_dir=/usr/share/dbus-1/system.d \
	-Ddhclient=/usr/sbin/dhclient \
	-Ddhcpcanon=false \
	-Ddhcpcd=false \
	-Ddnsmasq=/usr/sbin/dnsmasq \
	-Ddnssec_trigger=/bin/true \
	-Ddocs=false \
	-Debpf=false \
	-Dhostname_persist=default \
	-Difcfg_rh=false \
	-Difupdown=true \
	-Dintrospection=false \
	-Diptables=/usr/sbin/iptables \
	-Diwd=false \
	-Djson_validation=false \
	-Dkernel_firmware_dir=/lib/firmware \
	-Dld_gc=true \
	-Dlibaudit=no \
	-Dlibpsl=false \
	-Dmodem_manager=$(call ptx/truefalse,PTXCONF_NETWORKMANAGER_WWAN) \
	-Dmodify_system=false \
	-Dmore_asserts=no \
	-Dmore_logging=false \
	-Dnetconfig=false \
	-Dnmcli=$(call ptx/truefalse,PTXCONF_NETWORKMANAGER_NMCLI) \
	-Dnmtui=$(call ptx/truefalse,PTXCONF_NETWORKMANAGER_NMTUI) \
	-Dofono=false \
	-Dovs=false \
	-Dpolkit=$(call ptx/truefalse,PTXCONF_NETWORKMANAGER_POLKIT) \
	-Dpolkit_agent=false \
	-Dppp=$(call ptx/truefalse,PTXCONF_NETWORKMANAGER_PPP) \
	-Dpppd=/usr/sbin/pppd \
	-Dpppd_plugin_dir=$(PPP_SHARED_INST_PATH) \
	-Dqt=false \
	-Dresolvconf=false \
	-Dselinux=false \
	-Dsession_tracking=no \
	-Dsession_tracking_consolekit=false \
	-Dsuspend_resume=$(call ptx/ifdef,PTXCONF_NETWORKMANAGER_SYSTEMD_UNIT,systemd,upower) \
	-Dsystem_ca_path=/etc/ssl/certs \
	-Dsystemd_journal=$(call ptx/truefalse,PTXCONF_NETWORKMANAGER_SYSTEMD_UNIT) \
	-Dsystemdsystemunitdir=/usr/lib/systemd/system \
	-Dteamdctl=false \
	-Dtests=no \
	-Dudev_dir=/usr/lib/udev \
	-Dvalgrind=no \
	-Dvapi=false \
	-Dwext=$(call ptx/truefalse,PTXCONF_NETWORKMANAGER_WIRELESS) \
	-Dwifi=$(call ptx/truefalse,PTXCONF_NETWORKMANAGER_WIRELESS)

ifdef PTXCONF_NETWORKMANAGER_WWAN
NETWORKMANAGER_LDFLAGS	:= \
	-Wl,-rpath,/usr/lib/NetworkManager/$(NETWORKMANAGER_VERSION)
endif

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/networkmanager.install:
	@$(call targetinfo)
	@$(call world/install, NETWORKMANAGER)

ifdef PTXCONF_NETWORKMANAGER_EXAMPLES
	@cd $(NETWORKMANAGER_DIR)/examples/C/glib/ \
		&& for FILE in `find -type f -executable -printf '%f\n'`; do \
		install -vD -m 755 "$${FILE}" "$(NETWORKMANAGER_PKGDIR)/usr/bin/nm-$${FILE}"; \
	done
	@cd $(NETWORKMANAGER_DIR)/examples/python/dbus \
		&& for FILE in `find -name "*.py" -printf '%f\n'`; do \
		install -vD -m 755 "$${FILE}" "$(NETWORKMANAGER_PKGDIR)/usr/bin/nm-$${FILE}"; \
	done
	@cd $(NETWORKMANAGER_DIR)/examples/shell/ \
		&& for FILE in `find -name "*.sh" -printf '%f\n'`; do \
		install -vD -m 755 "$${FILE}" "$(NETWORKMANAGER_PKGDIR)/usr/bin/nm-$${FILE}"; \
	done
endif

	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/networkmanager.targetinstall:
	@$(call targetinfo)

	@$(call install_init, networkmanager)
	@$(call install_fixup, networkmanager,PRIORITY,optional)
	@$(call install_fixup, networkmanager,SECTION,base)
	@$(call install_fixup, networkmanager,AUTHOR,"Jan Luebbe <j.luebbe@pengutronix.de>")
	@$(call install_fixup, networkmanager,DESCRIPTION, "networkmanager")

	@$(call install_alternative, networkmanager, 0, 0, 0644, /etc/NetworkManager/NetworkManager.conf)
	@$(call install_copy, networkmanager, 0, 0, 0755, /etc/NetworkManager/dispatcher.d/)
	@$(call install_copy, networkmanager, 0, 0, 0755, /etc/NetworkManager/system-connections/)

#	# unmanage NFS root devices
	@$(call install_alternative, networkmanager, 0, 0, 0755, /usr/lib/init/nm-unmanage.sh)

	@$(call install_copy, networkmanager, 0, 0, 0755, /var/lib/NetworkManager)

ifdef PTXCONF_INITMETHOD_BBINIT
ifdef PTXCONF_NETWORKMANAGER_STARTSCRIPT
	@$(call install_alternative, networkmanager, 0, 0, 0755, /etc/init.d/NetworkManager)

ifneq ($(call remove_quotes, $(PTXCONF_NETWORKMANAGER_BBINIT_LINK)),)
	@$(call install_link, networkmanager, \
		../init.d/NetworkManager, \
		/etc/rc.d/$(PTXCONF_NETWORKMANAGER_BBINIT_LINK))
endif
endif
endif
ifdef PTXCONF_NETWORKMANAGER_SYSTEMD_UNIT
	@$(call install_alternative, networkmanager, 0, 0, 0644, \
		/usr/lib/systemd/system/NetworkManager.service)
	@$(call install_link, networkmanager, ../NetworkManager.service, \
		/usr/lib/systemd/system/multi-user.target.wants/NetworkManager.service)
	@$(call install_link, networkmanager, NetworkManager.service, \
		/usr/lib/systemd/system/dbus-org.freedesktop.NetworkManager.service)
	@$(call install_alternative, networkmanager, 0, 0, 0644, \
		/usr/lib/systemd/system/NetworkManager-unmanage.service)
	@$(call install_link, networkmanager, ../NetworkManager-unmanage.service, \
		/usr/lib/systemd/system/NetworkManager.service.wants/NetworkManager-unmanage.service)
ifdef PTXCONF_NETWORKMANAGER_NM_ONLINE
	@$(call install_alternative, networkmanager, 0, 0, 0644, \
		/usr/lib/systemd/system/NetworkManager-wait-online.service)
endif
	@$(call install_alternative, networkmanager, 0, 0, 0644, \
		/usr/lib/systemd/system/NetworkManager-dispatcher.service)
	@$(call install_link, networkmanager, NetworkManager-dispatcher.service, \
		/usr/lib/systemd/system/dbus-org.freedesktop.nm-dispatcher.service)
endif

	@$(call install_copy, networkmanager, 0, 0, 0755, -, /usr/sbin/NetworkManager)
ifdef PTXCONF_NETWORKMANAGER_NM_ONLINE
	@$(call install_copy, networkmanager, 0, 0, 0755, -, /usr/bin/nm-online)
endif
ifdef PTXCONF_NETWORKMANAGER_NMCLI
	@$(call install_copy, networkmanager, 0, 0, 0755, -, /usr/bin/nmcli)
endif
ifdef PTXCONF_NETWORKMANAGER_NMTUI
	@$(call install_copy, networkmanager, 0, 0, 0755, -, /usr/bin/nmtui)
endif

	@$(call install_tree, networkmanager, 0, 0, -, /usr/libexec/)

	@$(call install_lib, networkmanager, 0, 0, 0644, \
		NetworkManager/$(NETWORKMANAGER_VERSION)/libnm-settings-plugin-ifupdown)
ifdef PTXCONF_NETWORKMANAGER_WIRELESS
	@$(call install_lib, networkmanager, 0, 0, 0644, \
		NetworkManager/$(NETWORKMANAGER_VERSION)/libnm-device-plugin-wifi)
endif
ifdef PTXCONF_NETWORKMANAGER_WWAN
	@$(call install_lib, networkmanager, 0, 0, 0644, \
		NetworkManager/$(NETWORKMANAGER_VERSION)/libnm-device-plugin-wwan)
	@$(call install_lib, networkmanager, 0, 0, 0644, \
		NetworkManager/$(NETWORKMANAGER_VERSION)/libnm-wwan)
endif
ifdef PTXCONF_NETWORKMANAGER_PPP
	@$(call install_lib, networkmanager, 0, 0, 0644, \
		NetworkManager/$(NETWORKMANAGER_VERSION)/libnm-ppp-plugin)
	@$(call install_copy, networkmanager, 0, 0, 0644, -, $(PPP_SHARED_INST_PATH)/nm-pppd-plugin.so)
endif
	@$(call install_lib, networkmanager, 0, 0, 0644, libnm)

	@$(call install_tree, networkmanager, 0, 0, -, /usr/share/dbus-1/system.d/)
	@$(call install_tree, networkmanager, 0, 0, -, /usr/share/dbus-1/system-services/)

ifdef PTXCONF_NETWORKMANAGER_POLKIT
	@$(call install_tree, networkmanager, 0, 0, -, /usr/share/polkit-1/actions)
endif

ifdef PTXCONF_NETWORKMANAGER_EXAMPLES
	@$(call install_glob, networkmanager, 0, 0, -, /usr/bin, */nm-*-*)
endif

	@$(call install_finish, networkmanager)

	@$(call touch)

# vim: syntax=make
