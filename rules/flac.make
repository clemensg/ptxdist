# -*-makefile-*-
#
# Copyright (C) 2010 by Erwin Rol <erwin@erwinrol.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_FLAC) += flac

#
# Paths and names
#
FLAC_VERSION	:= 1.3.2
FLAC_MD5	:= 454f1bfa3f93cc708098d7890d0499bd
FLAC		:= flac-$(FLAC_VERSION)
FLAC_SUFFIX	:= tar.xz
FLAC_URL	:= http://downloads.xiph.org/releases/flac/$(FLAC).$(FLAC_SUFFIX)
FLAC_SOURCE	:= $(SRCDIR)/$(FLAC).$(FLAC_SUFFIX)
FLAC_DIR	:= $(BUILDDIR)/$(FLAC)
FLAC_LICENSE	:= BSD-3-Clause AND GPL-2.0-or-later AND LGPL-2.0-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
FLAC_CONF_TOOL	:= autoconf
FLAC_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	$(GLOBAL_LARGE_FILE_OPTION) \
	--enable-asm-optimizations \
	--disable-debug \
	--$(call ptx/endis, PTXCONF_ARCH_X86)-sse \
	--disable-altivec \
	--$(call ptx/endis, PTXCONF_ARCH_X86_64)-avx \
	--disable-thorough-tests \
	--disable-exhaustive-tests \
	--disable-werror \
	--enable-stack-smash-protection \
	--disable-64-bit-words \
	--disable-valgrind-testing \
	--disable-doxygen-docs \
	--disable-local-xmms-plugin \
	--disable-xmms-plugin \
	--disable-cpplibs \
	--enable-ogg \
	--disable-oggtest \
	--disable-rpath \
	--with-ogg=$(PTXDIST_SYSROOT_TARGET)/usr


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/flac.targetinstall:
	@$(call targetinfo)

	@$(call install_init, flac)
	@$(call install_fixup, flac,PRIORITY,optional)
	@$(call install_fixup, flac,SECTION,base)
	@$(call install_fixup, flac,AUTHOR,"Erwin Rol <erwin@erwinrol.com>")
	@$(call install_fixup, flac,DESCRIPTION,missing)

	@$(call install_lib, flac, 0, 0, 0644, libFLAC)

ifdef PTXCONF_FLAC_INSTALL_FLAC
	@$(call install_copy, flac, 0, 0, 0755, -, /usr/bin/flac)
endif
ifdef PTXCONF_FLAC_INSTALL_METAFLAC
	@$(call install_copy, flac, 0, 0, 0755, -, /usr/bin/metaflac)
endif

	@$(call install_finish, flac)

	@$(call touch)

# vim: syntax=make
