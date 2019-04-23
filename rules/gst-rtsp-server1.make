# -*-makefile-*-
#
# Copyright (C) 2014 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GST_RTSP_SERVER1) += gst-rtsp-server1

#
# Paths and names
#
GST_RTSP_SERVER1_VERSION	:= 1.16.0
GST_RTSP_SERVER1_MD5		:= adc4460239ec2eccf58ad9752ce53bfd
GST_RTSP_SERVER1		:= gst-rtsp-server-$(GST_RTSP_SERVER1_VERSION)
GST_RTSP_SERVER1_SUFFIX		:= tar.xz
GST_RTSP_SERVER1_URL		:= http://gstreamer.freedesktop.org/src/gst-rtsp/$(GST_RTSP_SERVER1).$(GST_RTSP_SERVER1_SUFFIX)
GST_RTSP_SERVER1_SOURCE		:= $(SRCDIR)/$(GST_RTSP_SERVER1).$(GST_RTSP_SERVER1_SUFFIX)
GST_RTSP_SERVER1_DIR		:= $(BUILDDIR)/$(GST_RTSP_SERVER1)
GST_RTSP_SERVER1_LICENSE	:= LGPL-2.0-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# meson
#
GST_RTSP_SERVER1_CONF_TOOL	= meson
GST_RTSP_SERVER1_CONF_OPT	= \
	$(CROSS_MESON_USR) \
	$(call GSTREAMER1_GENERIC_CONF_OPT,GStreamer RTSP Server Library) \
	-Dintrospection=$(call ptx/endis,PTXCONF_GSTREAMER1_INTROSPECTION)d \
	-Drtspclientsink=auto

foo = \
	\
	--disable-valgrind \
	--disable-gcov \
	--disable-examples \
	--disable-tests \
	--$(call ptx/endis, PTXCONF_GSTREAMER1_INTROSPECTION)-introspection \
	--disable-docbook \
	\
	--enable-Bsymbolic \
	--with-package-origin="PTXdist"

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gst-rtsp-server1.targetinstall:
	@$(call targetinfo)

	@$(call install_init, gst-rtsp-server1)
	@$(call install_fixup, gst-rtsp-server1,PRIORITY,optional)
	@$(call install_fixup, gst-rtsp-server1,SECTION,base)
	@$(call install_fixup, gst-rtsp-server1,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, gst-rtsp-server1,DESCRIPTION,missing)

	@$(call install_lib, gst-rtsp-server1, 0, 0, 0644, libgstrtspserver-1.0)
	@$(call install_lib, gst-rtsp-server1, 0, 0, 0644, gstreamer-1.0/libgstrtspclientsink)
ifdef PTXCONF_GSTREAMER1_INTROSPECTION
	@$(call install_copy, gst-rtsp-server1, 0, 0, 644, -, \
		/usr/lib/girepository-1.0/GstRtspServer-1.0.typelib)
endif

	@$(call install_finish, gst-rtsp-server1)

	@$(call touch)

# vim: syntax=make
