# -*-makefile-*-
#
# Copyright (C) 2018 by Steffen Trumtrar <s.trumtrar@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBWEBP) += libwebp

#
# Paths and names
#
LIBWEBP_VERSION		:= 1.0.2
LIBWEBP_MD5		:= 02c0c55f1dd8612cd4d462e3409ad35d
LIBWEBP			:= libwebp-$(LIBWEBP_VERSION)
LIBWEBP_SUFFIX		:= tar.gz
LIBWEBP_URL		:= http://downloads.webmproject.org/releases/webp/$(LIBWEBP).$(LIBWEBP_SUFFIX)
LIBWEBP_SOURCE		:= $(SRCDIR)/$(LIBWEBP).$(LIBWEBP_SUFFIX)
LIBWEBP_DIR		:= $(BUILDDIR)/$(LIBWEBP)
LIBWEBP_LICENSE		:= BSD-3-Clause
LIBWEBP_LICENSE_FILES	:= file://COPYING;md5=6e8dee932c26f2dab503abf70c96d8bb

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
LIBWEBP_CONF_TOOL	:= autoconf
LIBWEBP_CONF_OPT 	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-asserts \
	--$(call ptx/endis, PTXCONF_ARCH_X86)-sse4.1 \
	--$(call ptx/endis, PTXCONF_ARCH_X86)-sse2 \
	--$(call ptx/endis, PTXCONF_ARCH_ARM_NEON)-neon \
	--$(call ptx/endis, PTXCONF_ARCH_ARM_NEON)-neon-rtcd \
	--enable-threading \
	--disable-gl \
	--disable-sdl \
	--disable-png \
	--disable-jpeg \
	--disable-tiff \
	--disable-gif \
	--disable-wic \
	--enable-swap-16bit-csp \
	--enable-near-lossless \
	--$(call ptx/endis, PTXCONF_LIBWEBP_MUX)-libwebpmux \
	--$(call ptx/endis, PTXCONF_LIBWEBP_DEMUX)-libwebpdemux \
	--$(call ptx/endis, PTXCONF_LIBWEBP_DECODER)-libwebpdecoder \
	--disable-libwebpextras

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

LIBWEBP_INSTALL_FILES-y =
LIBWEBP_INSTALL_FILES-$(PTXCONF_LIBWEBP_CWEBP) += cwebp
LIBWEBP_INSTALL_FILES-$(PTXCONF_LIBWEBP_DWEBP) += dwebp

$(STATEDIR)/libwebp.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libwebp)
	@$(call install_fixup, libwebp,PRIORITY,optional)
	@$(call install_fixup, libwebp,SECTION,base)
	@$(call install_fixup, libwebp,AUTHOR,"Steffen Trumtrar <s.trumtrar@pengutronix.de>")
	@$(call install_fixup, libwebp,DESCRIPTION,missing)

	@$(call install_lib, libwebp, 0, 0, 0644, libwebp)
ifdef PTXCONF_LIBWEBP_DEMUX
	@$(call install_lib, libwebp, 0, 0, 0644, libwebpdemux)
endif
ifdef PTXCONF_LIBWEBP_MUX
	@$(call install_lib, libwebp, 0, 0, 0644, libwebpmux)
endif
ifdef PTXCONF_LIBWEBP_DECODER
	@$(call install_lib, libwebp, 0, 0, 0644, libwebpdecoder)
endif

	@for i in $(LIBWEBP_INSTALL_FILES-y); do \
		$(call install_copy, libwebp, 0, 0, 0755, -, /usr/bin/$$i) \
	done

	@$(call install_finish, libwebp)

	@$(call touch)
