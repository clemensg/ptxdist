# -*-makefile-*-
#
# Copyright (C) 2010 by Bart vdr. Meulen <bartvdrmeulen@gmail.com>
# Copyright (C) 2015 by Lucas Stach <dev@lynxeye.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XFSPROGS) += xfsprogs

#
# Paths and names
#
XFSPROGS_VERSION:= 4.19.0
XFSPROGS_MD5	:= 955b3dad9cbe01d6b21a562cc0100e04
XFSPROGS	:= xfsprogs-$(XFSPROGS_VERSION)
XFSPROGS_SUFFIX	:= tar.gz
XFSPROGS_URL	:= $(call ptx/mirror, KERNEL, utils/fs/xfs/xfsprogs/$(XFSPROGS).$(XFSPROGS_SUFFIX))
XFSPROGS_SOURCE	:= $(SRCDIR)/$(XFSPROGS).$(XFSPROGS_SUFFIX)
XFSPROGS_DIR	:= $(BUILDDIR)/$(XFSPROGS)
XFSPROGS_LICENSE:= GPL-2.0-only AND LGPL-2.1-only

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

XFSPROGS_CONF_ENV	:= \
	$(CROSS_ENV) \
	ac_cv_search_dm_task_create=no

XFSPROGS_CONF_TOOL	:= autoconf
XFSPROGS_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--sbindir=/usr/sbin \
	--libdir=/usr/lib \
	--datarootdir=/usr/share \
	--enable-static \
	--disable-gettext \
	--enable-blkid \
	--disable-readline \
	--disable-editline \
	--disable-termcap \
	--disable-lib64

XFSPROGS_INSTALL_OPT	:= \
	PKG_ROOT_LIB_DIR=/usr/lib \
	PKG_ROOT_SBIN_DIR=/usr/sbin \
	install

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xfsprogs.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xfsprogs)
	@$(call install_fixup, xfsprogs,PRIORITY,optional)
	@$(call install_fixup, xfsprogs,SECTION,base)
	@$(call install_fixup, xfsprogs,AUTHOR,"Bart vdr. Meulen <bartvdrmeulen@gmail.com>")
	@$(call install_fixup, xfsprogs,DESCRIPTION,missing)

ifdef PTXCONF_XFSPROGS_INSTALL_MKXFS
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/mkfs.xfs)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_XFS_REPAIR
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_repair)
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/fsck.xfs)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_GROWFS
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_growfs)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_INFO
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_info)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_DB
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_db)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_METADUMP
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_metadump)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_NCHECK
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_ncheck)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_ADMIN
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_admin)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_IO
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_io)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_FREEZE
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_freeze)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_MKFILE
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_mkfile)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_BMAP
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_bmap)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_LOGPRINT
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_logprint)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_MDRESTORE
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_mdrestore)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_QUOTA
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_quota)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_RTCP
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_rtcp)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_COPY
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_copy)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_ESTIMATE
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_estimate)
endif

ifdef PTXCONF_XFSPROGS_INSTALL_FSR
	@$(call install_copy, xfsprogs, 0, 0, 0755, -, /usr/sbin/xfs_fsr)
	@$(call install_lib, xfsprogs, 0, 0, 0644, libhandle)
endif

	@$(call install_finish, xfsprogs)
	@$(call touch)

# vim: syntax=make
