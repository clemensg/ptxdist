# -*-makefile-*-
#
# Copyright (C) 2008 by Robert Schwebel
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GST_PLUGINS_BASE1) += gst-plugins-base1

#
# Paths and names
#
GST_PLUGINS_BASE1_VERSION	:= 1.16.0
GST_PLUGINS_BASE1_MD5		:= 41dde92930710c75cdb49169c5cc6dfc
GST_PLUGINS_BASE1		:= gst-plugins-base-$(GST_PLUGINS_BASE1_VERSION)
GST_PLUGINS_BASE1_SUFFIX	:= tar.xz
GST_PLUGINS_BASE1_URL		:= http://gstreamer.freedesktop.org/src/gst-plugins-base/$(GST_PLUGINS_BASE1).$(GST_PLUGINS_BASE1_SUFFIX)
GST_PLUGINS_BASE1_SOURCE	:= $(SRCDIR)/$(GST_PLUGINS_BASE1).$(GST_PLUGINS_BASE1_SUFFIX)
GST_PLUGINS_BASE1_DIR		:= $(BUILDDIR)/$(GST_PLUGINS_BASE1)
GST_PLUGINS_BASE1_LICENSE	:= LGPL-2.0-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_ADDER)		+= adder
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_ALSA)		+= alsa
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_APP)		+= app
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_AUDIOCONVERT)	+= audioconvert
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_AUDIOMIXER)	+= audiomixer
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_AUDIORATE)		+= audiorate
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_AUDIORESAMPLE)	+= audioresample
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_AUDIOTESTSRC)	+= audiotestsrc
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_CDPARANOIA)	+= cdparanoia
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_COMPOSITOR)	+= compositor
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_ENCODING)		+= encoding
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_GIO)		+= gio
GST_PLUGINS_BASE1_ENABLEC-$(PTXCONF_GST_PLUGINS_BASE1_GL)		+= gl
GST_PLUGINS_BASE1_ENABLEP-$(PTXCONF_GST_PLUGINS_BASE1_GL)		+= opengl
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_LIBVISUAL)		+= libvisual
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_OGG)		+= ogg
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_OPUS)		+= opus
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_OVERLAYCOMPOSITION)	+= overlaycomposition
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_PANGO)		+= pango
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_PBTYPES)		+= pbtypes
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_PLAYBACK)		+= playback
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_RAWPARSE)		+= rawparse
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_SUBPARSE)		+= subparse
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_TCP)		+= tcp
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_THEORA)		+= theora
GST_PLUGINS_BASE1_ENABLEC-$(PTXCONF_GST_PLUGINS_BASE1_TREMOR)		+= tremor
GST_PLUGINS_BASE1_ENABLEP-$(PTXCONF_GST_PLUGINS_BASE1_TREMOR)		+= ivorbisdec
GST_PLUGINS_BASE1_ENABLEC-$(PTXCONF_GST_PLUGINS_BASE1_TYPEFIND)		+= typefind
GST_PLUGINS_BASE1_ENABLEP-$(PTXCONF_GST_PLUGINS_BASE1_TYPEFIND)		+= typefindfunctions
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_VIDEOCONVERT)	+= videoconvert
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_VIDEORATE)		+= videorate
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_VIDEOSCALE)	+= videoscale
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_VIDEOTESTSRC)	+= videotestsrc
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_VOLUME)		+= volume
GST_PLUGINS_BASE1_ENABLE-$(PTXCONF_GST_PLUGINS_BASE1_VORBIS)		+= vorbis
GST_PLUGINS_BASE1_ENABLEC-$(PTXCONF_GST_PLUGINS_BASE1_X)		+= x11 xshm xvideo
GST_PLUGINS_BASE1_ENABLEP-$(PTXCONF_GST_PLUGINS_BASE1_X)		+= ximagesink xvimagesink

GST_PLUGINS_BASE1_ENABLEC- += $(GST_PLUGINS_BASE1_ENABLE-)
GST_PLUGINS_BASE1_ENABLEC-y += $(GST_PLUGINS_BASE1_ENABLE-y)
GST_PLUGINS_BASE1_ENABLEP-y += $(GST_PLUGINS_BASE1_ENABLE-y)

GST_PLUGINS_BASE1_GL_API :=
ifdef PTXCONF_GST_PLUGINS_BASE1_GLES2
GST_PLUGINS_BASE1_GL_API += gles2
endif
ifdef PTXCONF_GST_PLUGINS_BASE1_OPENGL
GST_PLUGINS_BASE1_GL_API += opengl
endif
GST_PLUGINS_BASE1_GL_API := $(subst $(space),$(comma),$(strip $(GST_PLUGINS_BASE1_GL_API)))

GST_PLUGINS_BASE1_GL_PLATFORM :=
ifdef PTXCONF_GST_PLUGINS_BASE1_EGL
GST_PLUGINS_BASE1_GL_PLATFORM += egl
endif
ifdef PTXCONF_GST_PLUGINS_BASE1_GLX
GST_PLUGINS_BASE1_GL_PLATFORM += glx
endif
GST_PLUGINS_BASE1_GL_PLATFORM := $(subst $(space),$(comma),$(strip $(GST_PLUGINS_BASE1_GL_PLATFORM)))

GST_PLUGINS_BASE1_GL_WINSYS := gbm
ifdef PTXCONF_GST_PLUGINS_BASE1_EGL_WAYLAND
GST_PLUGINS_BASE1_GL_WINSYS += wayland
endif
ifdef PTXCONF_GST_PLUGINS_BASE1_X11
GST_PLUGINS_BASE1_GL_WINSYS += x11
endif
GST_PLUGINS_BASE1_GL_WINSYS := $(subst $(space),$(comma),$(strip $(GST_PLUGINS_BASE1_GL_WINSYS)))

#
# meson
#
GST_PLUGINS_BASE1_CONF_TOOL	= meson
GST_PLUGINS_BASE1_CONF_OPT	= \
	$(CROSS_MESON_USR) \
	$(call GSTREAMER1_GENERIC_CONF_OPT,GStreamer Base Plug-ins) \
	-Daudioresample_format=auto \
	-Degl_module_name=libEGL \
	-Dgl-graphene=disabled \
	-Dgl-jpeg=$(call ptx/endis, PTXCONF_GST_PLUGINS_BASE1_OPENGL)d \
	-Dgl-png=$(call ptx/endis, PTXCONF_GST_PLUGINS_BASE1_OPENGL)d \
	-Dgl_api=$(GST_PLUGINS_BASE1_GL_API) \
	-Dgl_platform=$(GST_PLUGINS_BASE1_GL_PLATFORM) \
	-Dgl_winsys=$(GST_PLUGINS_BASE1_GL_WINSYS) \
	-Dgtk_doc=disabled \
	-Dintrospection=$(call ptx/endis,PTXCONF_GSTREAMER1_INTROSPECTION)d \
	-Diso-codes=disabled \
	-Dorc=enabled \
	-Dtools=$(call ptx/endis, PTXCONF_GST_PLUGINS_BASE1_INSTALL_TOOLS)d

ifneq ($(call remove_quotes,$(GST_PLUGINS_BASE1_ENABLEC-y)),)
GST_PLUGINS_BASE1_CONF_OPT +=  $(addsuffix =enabled, $(addprefix -D, $(GST_PLUGINS_BASE1_ENABLEC-y)))
endif

ifneq ($(call remove_quotes,$(GST_PLUGINS_BASE1_ENABLEC-)),)
GST_PLUGINS_BASE1_CONF_OPT +=  $(addsuffix =disabled, $(addprefix -D, $(GST_PLUGINS_BASE1_ENABLEC-)))
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gst-plugins-base1.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  gst-plugins-base1)
	@$(call install_fixup, gst-plugins-base1,PRIORITY,optional)
	@$(call install_fixup, gst-plugins-base1,SECTION,base)
	@$(call install_fixup, gst-plugins-base1,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, gst-plugins-base1,DESCRIPTION,missing)

ifdef PTXCONF_GST_PLUGINS_BASE1_INSTALL_TOOLS
	@$(call install_copy, gst-plugins-base1, 0, 0, 0755, -, \
		/usr/bin/gst-device-monitor-1.0)

	@$(call install_copy, gst-plugins-base1, 0, 0, 0755, -, \
		/usr/bin/gst-discoverer-1.0)

	@$(call install_copy, gst-plugins-base1, 0, 0, 0755, -, \
		/usr/bin/gst-play-1.0)
endif

	# install all activated libs
	@$(foreach lib,$(basename $(notdir $(wildcard $(GST_PLUGINS_BASE1_PKGDIR)/usr/lib/*-1.0.so))), \
		$(call install_lib, gst-plugins-base1, 0, 0, 0644, $(lib))$(ptx/nl))

	@$(foreach plugin, $(GST_PLUGINS_BASE1_ENABLEP-y), \
		$(call install_copy, gst-plugins-base1, 0, 0, 0644, -, \
			/usr/lib/gstreamer-1.0/libgst$(plugin).so)$(ptx/nl))

ifdef PTXCONF_GSTREAMER1_INTROSPECTION
	@$(call install_tree, gst-plugins-base1, 0, 0, -, \
		/usr/lib/girepository-1.0)
endif

	@$(call install_finish, gst-plugins-base1)

	@$(call touch)

# vim: syntax=make
