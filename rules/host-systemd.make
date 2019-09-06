# -*-makefile-*-
#
# Copyright (C) 2013 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEMD) += host-systemd

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_SYSTEMD_CONF_TOOL	:= meson
HOST_SYSTEMD_CONF_OPT	:= \
	$(HOST_MESON_OPT) \
	-Dacl=false \
	-Dadm-group=true \
	-Dapparmor=false \
	-Daudit=false \
	-Dbacklight=false \
	-Dbinfmt=false \
	-Dblkid=false \
	-Dbzip2=false \
	-Dcompat-gateway-hostname=false \
	-Dcoredump=false \
	-Dcreate-log-dirs=false \
	-Ddbus=false \
	-Ddbuspolicydir=/usr/share/dbus-1/system.d \
	-Ddbussessionservicedir=/usr/share/dbus-1/services \
	-Ddbussystemservicedir=/usr/share/dbus-1/system-services \
	-Ddefault-dns-over-tls=no \
	-Ddefault-dnssec=no \
	-Ddefault-hierarchy=unified \
	-Ddefault-kill-user-processes=true \
	-Ddev-kvm-mode=0660 \
	-Ddns-over-tls=false \
	-Ddns-servers= \
	-Defi=false \
	-Delfutils=false \
	-Denvironment-d=false \
	-Dfirstboot=false \
	-Dfuzzbuzz=false \
	-Dgcrypt=false \
	-Dglib=false \
	-Dgnutls=false \
	-Dgroup-render-mode=0666 \
	-Dgshadow=false \
	-Dhibernate=false \
	-Dhostnamed=false \
	-Dhtml=false \
	-Dhwdb=true \
	-Didn=false \
	-Dima=false \
	-Dimportd=false \
	-Dinstall-tests=false \
	-Dkmod=false \
	-Dldconfig=false \
	-Dlibcryptsetup=false \
	-Dlibcurl=false \
	-Dlibidn=false \
	-Dlibidn2=false \
	-Dlibiptc=false \
	-Dlink-systemctl-shared=true \
	-Dlink-udev-shared=true \
	-Dllvm-fuzz=false \
	-Dlocaled=false \
	-Dlog-trace=false \
	-Dlogind=false \
	-Dlz4=false \
	-Dmachined=false \
	-Dman=false \
	-Dmemory-accounting-default=false \
	-Dmicrohttpd=false \
	-Dnetworkd=false \
	-Dnobody-group=nobody \
	-Dnobody-user=nobody \
	-Dnss-myhostname=false \
	-Dnss-mymachines=false \
	-Dnss-resolve=false \
	-Dnss-systemd=false \
	-Dntp-servers= \
	-Dok-color=green \
	-Dopenssl=false \
	-Doss-fuzz=false \
	-Dpam=false \
	-Dpcre2=false \
	-Dpolkit=false \
	-Dportabled=false \
	-Dpstore=false \
	-Dqrencode=false \
	-Dquotacheck=false \
	-Drandomseed=false \
	-Dremote=false \
	-Dresolve=false \
	-Drfkill=false \
	-Dseccomp=false \
	-Dselinux=false \
	-Dslow-tests=false \
	-Dsmack=false \
	-Dsplit-bin=true \
	-Dsplit-usr=false \
	-Dstatic-libsystemd=false \
	-Dstatic-libudev=false \
	-Dstatus-unit-format-default=name \
	-Dsystem-gid-max=999 \
	-Dsystem-uid-max=999 \
	-Dsysusers=false \
	-Dsysvinit-path= \
	-Dsysvrcnd-path= \
	-Dtests=false \
	-Dtime-epoch=$(SOURCE_DATE_EPOCH) \
	-Dtimedated=false \
	-Dtimesyncd=false \
	-Dtmpfiles=false \
	-Dtpm=false \
	-Dutmp=false \
	-Dvalgrind=false \
	-Dvconsole=false \
	-Dversion-tag=$(HOST_SYSTEMD_VERSION) \
	-Dwheel-group=false \
	-Dxkbcommon=false \
	-Dxz=false \
	-Dzlib=false

HOST_SYSTEMD_MAKE_OPT := systemd-hwdb

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/host-systemd.install:
	@$(call targetinfo)
	@rm -rf $(HOST_SYSTEMD_PKGDIR)
	@install -vD -m755 $(HOST_SYSTEMD_DIR)-build/systemd-hwdb \
		$(HOST_SYSTEMD_PKGDIR)/bin/systemd-hwdb
	@install -vD -m755 $(HOST_SYSTEMD_DIR)-build/src/shared/libsystemd-shared-$(firstword $(subst -, ,$(SYSTEMD_VERSION))).so \
		$(HOST_SYSTEMD_PKGDIR)/lib/libsystemd-shared-$(firstword $(subst -, ,$(SYSTEMD_VERSION))).so
	@$(call touch)

# vim: syntax=make
