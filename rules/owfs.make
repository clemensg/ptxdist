# -*-makefile-*-
#
# Copyright (C) 2008 by Robert Schwebel <r.schwebel@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_OWFS) += owfs

#
# Paths and names
#
OWFS_VERSION	:= 3.2p3
OWFS_MD5	:= ea0c96fdc3e0bb386a135fa90aeb97f8
OWFS		:= owfs-$(OWFS_VERSION)
OWFS_SUFFIX	:= tar.gz
OWFS_URL	:= https://github.com/owfs/owfs/releases/download/v$(OWFS_VERSION)/$(OWFS).$(OWFS_SUFFIX)
OWFS_SOURCE	:= $(SRCDIR)/$(OWFS).$(OWFS_SUFFIX)
OWFS_DIR	:= $(BUILDDIR)/$(OWFS)
OWFS_LICENSE	:= GPL-2.0-or-later AND LGPL-2.0-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
OWFS_CONF_TOOL	:= autoconf
OWFS_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-debian \
	--disable-debug \
	--disable-mutexdebug \
	--$(call ptx/endis,PTXCONF_OWFS_OWSHELL)-owshell \
	--enable-owlib \
	--$(call ptx/endis,PTXCONF_OWFS_OWNETLIB)-ownetlib \
	--enable-i2c \
	--disable-w1 \
	--disable-owhttpd \
	--disable-owftpd \
	--disable-owserver \
	--disable-owexternal \
	--disable-ownet \
	--disable-owtap \
	--disable-owmalloc \
	--disable-owmon \
	--$(call ptx/endis,PTXCONF_OWFS_OWCAPI)-owcapi \
	--disable-swig \
	--disable-owperl \
	--disable-owphp \
	--disable-owpython \
	--disable-owtcl \
	--disable-profiling \
	--$(call ptx/endis,PTXCONF_OWFS_OWFS)-owfs \
	--disable-zero \
	--disable-usb \
	--disable-avahi \
	--disable-parport \
	--disable-ftdi \
	--without-perl5 \
	--without-php \
	--without-phpconfig \
	--without-python \
	--without-pythonconfig \
	--without-tcl


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/owfs.targetinstall:
	@$(call targetinfo)

	@$(call install_init, owfs)
	@$(call install_fixup, owfs,PRIORITY,optional)
	@$(call install_fixup, owfs,SECTION,base)
	@$(call install_fixup, owfs,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, owfs,DESCRIPTION,missing)

	@$(call install_lib, owfs, 0, 0, 0644, libow-3.2)
ifdef PTXCONF_OWFS_OWCAPI
	@$(call install_lib, owfs, 0, 0, 0644, libowcapi-3.2)
endif

ifdef PTXCONF_OWFS_OWFS
	@$(call install_copy, owfs, 0, 0, 0755, -, /usr/bin/owfs)
endif
	@$(call install_finish, owfs)

	@$(call touch)

# vim: syntax=make
