# -*-makefile-*-
#
# Copyright (C) 2019 by Bastian Krause <bst@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_LVM2) += host-lvm2

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_LVM2_CONF_TOOL	:= autoconf
# --disable-o_direct leads to compilation error ("device/dev-io.c:537:5: error: label 'opened' used but not defined")
HOST_LVM2_CONF_OPT	:= \
	$(HOST_AUTOCONF) \
	--disable-static_link \
	--disable-lvm1_fallback \
	--disable-thin_check_needs_check \
	--disable-cache_check_needs_check \
	--disable-readline \
	--enable-realtime \
	--disable-ocf \
	--disable-cmirrord \
	--disable-debug \
	--disable-profiling \
	--disable-testing \
	--disable-valgrind-pool \
	--enable-devmapper \
	--disable-lvmetad \
	--disable-lvmpolld \
	--disable-lvmlockd-sanlock \
	--disable-lvmlockd-dlm \
	--disable-use-lvmlockd \
	--disable-use-lvmetad \
	--disable-use-lvmpolld \
	--disable-dmfilemapd \
	--disable-notify-dbus \
	--disable-blkid_wiping \
	--disable-compat \
	--disable-units-compat \
	--disable-ioctl \
	--enable-o_direct \
	--disable-applib \
	--disable-cmdlib \
	--disable-python_bindings \
	--disable-python2_bindings \
	--disable-python3_bindings \
	--disable-pkgconfig \
	--disable-write_install \
	--disable-fsadm \
	--disable-blkdeactivate \
	--disable-dmeventd \
	--disable-selinux \
	--disable-nls

# vim: syntax=make
