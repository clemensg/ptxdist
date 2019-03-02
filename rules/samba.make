# -*-makefile-*-
#
# Copyright (C) 2006 by Robert Schwebel
#               2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_SAMBA) += samba

#
# Paths and names
#
SAMBA_VERSION	:= 4.9.4
SAMBA_MD5	:= 5e94705ae741bc6e4c893cea7b5de0d5
SAMBA		:= samba-$(SAMBA_VERSION)
SAMBA_SUFFIX	:= tar.gz
SAMBA_URL	:= https://download.samba.org/pub/samba/stable/$(SAMBA).$(SAMBA_SUFFIX)
SAMBA_SOURCE	:= $(SRCDIR)/$(SAMBA).$(SAMBA_SUFFIX)
SAMBA_DIR	:= $(BUILDDIR)/$(SAMBA)
SAMBA_LICENSE	:= GPL-3.0-or-later AND LGPL-3.0-or-later
# cross-compile runtime checks. Initial file generated with
# --cross-execute=$(PTXDIST_SYSROOT_CROSS)/bin/qemu-cross
SAMBA_CONFIG	:= $(shell ptxd_get_alternative config/samba cross-answers && echo $$ptxd_reply)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
SAMBA_CONF_TOOL	:= NO
SAMBA_CONF_OPT	:= \
	--nocache \
	--without-json-audit \
	--without-gettext \
	--disable-python \
	--without-gpgme \
	--without-winbind \
	--without-ads \
	--without-ldap \
	--$(call ptx/endis,PTXCONF_SAMBA_CUPS)-cups \
	--disable-iprint \
	--without-pam \
	--with-quotas \
	--with-sendfile-support \
	--with-utmp \
	--disable-avahi \
	--$(call ptx/wwo, PTXCONF_ICONV)-iconv \
	--with-acl-support \
	--with-dnsupdate \
	--with-syslog \
	--without-automount \
	--without-dmapi \
	--without-fam \
	--without-profiling-data \
	--without-libarchive \
	--without-cluster-support \
	--without-regedit \
	--without-fake-kaserver \
	--disable-glusterfs \
	--disable-cephfs \
	--disable-spotlight \
	--with-systemd \
	--without-lttng \
	--accel-aes=$(call ptx/ifdef,PTXCONF_ARCH_X86_64,intelaesni,none) \
	--enable-pthreadpool \
	--with-system-mitkrb5 \
	--without-ad-dc \
	--without-ntvfs-fileserver \
	$(CROSS_AUTOCONF_SYSROOT_USR) \
	--bundled-libraries=NONE,cmocka,tdb,talloc,tevent,ldb \
	--disable-rpath \
	--disable-rpath-install \
	--enable-auto-reconfigure \
	--cross-compile \
	--cross-execute=/does/not/exist/and/triggers/exceptions \
	--cross-answers=$(SAMBA_DIR)/cross-answers \
	--hostcc=$(HOSTCC) \
	--enable-fhs \
	--with-piddir=/run/samba \
	--with-lockdir=/var/lib/samba/lock \
	--systemd-install-services \
	--with-systemddir=/usr/lib/systemd/system

$(STATEDIR)/samba.prepare:
	@$(call targetinfo)
	@UNAME_M=$(PTXCONF_ARCH_STRING) \
		UNAME_R=$(KERNEL_VERSION) \
		UNAME_V=$(if $(KERNEL_HEADER_VERSION),$(KERNEL_HEADER_VERSION),$(KERNEL_VERSION)) \
		HAS_64BIT=$(call ptx/ifdef,PTXCONF_ARCH_LP64,OK,NO) \
		ptxd_replace_magic $(SAMBA_CONFIG) > $(SAMBA_DIR)/cross-answers
	@$(call world/execute, SAMBA, $(SYSTEMPYTHON) ./buildtools/bin/waf configure $(SAMBA_CONF_OPT))
	@$(call touch)

SAMBA_COMPILE_ENV := \
	PTXDIST_ICECC=

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

SAMBA_COMMON_LIBS := \
	libdcerpc \
	libdcerpc-binding \
	libndr-krb5pac \
	libndr-nbt \
	libndr-standard \
	libndr \
	libnetapi \
	libsamba-credentials \
	libsamba-errors \
	libsamba-hostconfig \
	libsamba-passdb \
	libsamba-util \
	libsamdb \
	libsmbconf \
	libtevent-util \
	libwbclient \
	samba/libldb \
	samba/libtalloc \
	samba/libtdb \
	samba/libtevent


$(STATEDIR)/samba.targetinstall:
	@$(call targetinfo)

	@$(call install_init, samba)
	@$(call install_fixup, samba,PRIORITY,optional)
	@$(call install_fixup, samba,SECTION,base)
	@$(call install_fixup, samba,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, samba,DESCRIPTION,missing)

	@$(call install_alternative_tree, samba, 0, 0, /etc/samba)

ifdef PTXCONF_SAMBA_COMMON
	@$(call install_glob, samba, 0, 0, -, \
		/usr/lib/samba,*-samba4.so)

	@$(foreach lib, $(SAMBA_COMMON_LIBS), \
		$(call install_lib, samba, 0, 0, 0644, $(lib))$(ptx/nl))

	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/nmblookup)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/net)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/smbpasswd)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/testparm)
endif

ifdef PTXCONF_SAMBA_SERVER
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/sbin/smbd)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/sbin/nmbd)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/pdbedit)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/smbcontrol)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/smbstatus)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/tdbbackup)
	@$(call install_copy, samba, 0, 0, 0755, /var/cache/samba)
	@$(call install_copy, samba, 0, 0, 0755, /var/lib/samba)
	@$(call install_alternative, samba, 0, 0, 0644, \
		/usr/lib/tmpfiles.d/samba.conf)
endif

ifdef PTXCONF_SAMBA_CLIENT
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/smbcacls)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/smbcquotas)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/smbtree)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/smbclient)
	@$(call install_copy, samba, 0, 0, 0755, -, \
		/usr/bin/rpcclient)
endif

ifdef PTXCONF_SAMBA_LIBCLIENT
	@$(call install_lib, samba, 0, 0, 0644, libsmbclient)
endif

#	#
#	# busybox init
#	#
ifdef PTXCONF_INITMETHOD_BBINIT
ifdef PTXCONF_SAMBA_STARTSCRIPT
	@$(call install_alternative, samba, 0, 0, 0755, /etc/init.d/samba)

ifneq ($(call remove_quotes,$(PTXCONF_SAMBA_BBINIT_LINK)),)
	@$(call install_link, samba, \
		../init.d/samba, \
		/etc/rc.d/$(PTXCONF_SAMBA_BBINIT_LINK))
endif
endif
endif

ifdef PTXCONF_SAMBA_SYSTEMD_UNIT
	@$(call install_alternative, samba, 0, 0, 0644, \
		/usr/lib/systemd/system/smb.service)
	@$(call install_link, samba, ../smb.service, \
		/usr/lib/systemd/system/multi-user.target.wants/smb.service)

	@$(call install_alternative, samba, 0, 0, 0644, \
		/usr/lib/systemd/system/nmb.service)
	@$(call install_link, samba, ../nmb.service, \
		/usr/lib/systemd/system/multi-user.target.wants/nmb.service)
endif

	@$(call install_finish, samba)

	@$(call touch)

# vim: syntax=make
