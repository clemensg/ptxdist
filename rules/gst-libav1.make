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
PACKAGES-$(PTXCONF_GST_LIBAV1) += gst-libav1

#
# Paths and names
#
GST_LIBAV1_VERSION	:= 1.16.0
GST_LIBAV1_MD5		:= e3a201a45985ddc1327cd496046ca818
GST_LIBAV1		:= gst-libav-$(GST_LIBAV1_VERSION)
GST_LIBAV1_SUFFIX	:= tar.xz
GST_LIBAV1_URL		:= http://gstreamer.freedesktop.org/src/gst-libav/$(GST_LIBAV1).$(GST_LIBAV1_SUFFIX)
GST_LIBAV1_SOURCE	:= $(SRCDIR)/$(GST_LIBAV1).$(GST_LIBAV1_SUFFIX)
GST_LIBAV1_DIR		:= $(BUILDDIR)/$(GST_LIBAV1)
GST_LIBAV1_LICENSE	:= GPL-2.0-or-later AND LGPL-2.0-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# meson
#
GST_LIBAV1_CONF_TOOL	:= meson
GST_LIBAV1_CONF_OPT	:= \
	$(CROSS_MESON_USR) \
	-Dpackage-name="GStreamer FFMPEG Plug-ins source release" \
	-Dpackage-origin=PTXdist

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gst-libav1.targetinstall:
	@$(call targetinfo)

	@$(call install_init, gst-libav1)
	@$(call install_fixup, gst-libav1,PRIORITY,optional)
	@$(call install_fixup, gst-libav1,SECTION,base)
	@$(call install_fixup, gst-libav1,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, gst-libav1,DESCRIPTION,missing)

	@$(call install_lib, gst-libav1, 0, 0, 0644, gstreamer-1.0/libgstlibav)

	@$(call install_finish, gst-libav1)

	@$(call touch)

# vim: syntax=make
