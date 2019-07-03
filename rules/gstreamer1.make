# -*-makefile-*-
#
# Copyright (C) 2008 by Robert Schwebel
#               2011 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GSTREAMER1) += gstreamer1

#
# Paths and names
#
GSTREAMER1_VERSION	:= 1.16.0
GSTREAMER1_MD5		:= 862b7e4263d946bc2ef31b3c582e5587
GSTREAMER1		:= gstreamer-$(GSTREAMER1_VERSION)
GSTREAMER1_SUFFIX	:= tar.xz
GSTREAMER1_URL		:= http://gstreamer.freedesktop.org/src/gstreamer/$(GSTREAMER1).$(GSTREAMER1_SUFFIX)
GSTREAMER1_SOURCE	:= $(SRCDIR)/$(GSTREAMER1).$(GSTREAMER1_SUFFIX)
GSTREAMER1_DIR		:= $(BUILDDIR)/$(GSTREAMER1)
GSTREAMER1_LICENSE	:= LGPL-2.1-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# meson
#
GSTREAMER1_GENERIC_CONF_OPT = \
	-Dexamples=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled \
	-Dgobject-cast-checks=disabled \
	-Dnls=disabled \
	-Dpackage-name="$(1) source release" \
	-Dpackage-origin=PTXdist \
	-Dtests=disabled

GSTREAMER1_CONF_TOOL	:= meson
GSTREAMER1_CONF_OPT	:= \
	$(CROSS_MESON_USR) \
	$(call GSTREAMER1_GENERIC_CONF_OPT,GStreamer) \
	-Dbash-completion=disabled \
	-Dbenchmarks=disabled \
	-Dcheck=$(call ptx/endis,PTXCONF_GSTREAMER1_CHECK)d \
	-Ddbghelp=disabled \
	-Dextra-checks=false \
	-Dgst_debug=$(call ptx/truefalse,PTXCONF_GSTREAMER1_DEBUG) \
	-Dgst_parse=true \
	-Dgtk_doc=disabled \
	-Dintrospection=$(call ptx/endis,PTXCONF_GSTREAMER1_INTROSPECTION)d \
	-Dlibdw=disabled \
	-Dlibunwind=enabled \
	-Dmemory-alignment=malloc \
	-Doption-parsing=true \
	-Dpoisoning=false \
	-Dptp-helper-permissions=setuid-root \
	-Dptp-helper-setuid-group=nogroup \
	-Dptp-helper-setuid-user=nobody \
	-Dregistry=true \
	-Dtools=$(call ptx/endis,PTXCONF_GSTREAMER1_INSTALL_TOOLS)d \
	-Dtracer_hooks=$(call ptx/truefalse,PTXCONF_GSTREAMER1_DEBUG)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gstreamer1.targetinstall:
	@$(call targetinfo)

	@$(call install_init, gstreamer1)
	@$(call install_fixup, gstreamer1,PRIORITY,optional)
	@$(call install_fixup, gstreamer1,SECTION,base)
	@$(call install_fixup, gstreamer1,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, gstreamer1,DESCRIPTION,missing)

ifdef PTXCONF_GSTREAMER1_INSTALL_TOOLS
	@$(call install_copy, gstreamer1, 0, 0, 0755, -, \
		/usr/bin/gst-inspect-1.0)
	@$(call install_copy, gstreamer1, 0, 0, 0755, -, \
		/usr/bin/gst-launch-1.0)
	@$(call install_copy, gstreamer1, 0, 0, 0755, -, \
		/usr/bin/gst-typefind-1.0)
	@$(call install_copy, gstreamer1, 0, 0, 0755, -, \
		/usr/bin/gst-stats-1.0)
endif

	@$(call install_lib, gstreamer1, 0, 0, 0644, libgstbase-1.0)
	@$(call install_lib, gstreamer1, 0, 0, 0644, libgstcontroller-1.0)
	@$(call install_lib, gstreamer1, 0, 0, 0644, libgstnet-1.0)
	@$(call install_lib, gstreamer1, 0, 0, 0644, libgstreamer-1.0)
ifdef PTXCONF_GSTREAMER1_CHECK
	@$(call install_lib, gstreamer1, 0, 0, 0644, libgstcheck-1.0)
endif

	@$(call install_lib, gstreamer1, 0, 0, 0644, \
		gstreamer-1.0/libgstcoreelements)
ifdef PTXCONF_GSTREAMER1_DEBUG
	@$(call install_lib, gstreamer1, 0, 0, 0644, \
		gstreamer-1.0/libgstcoretracers)
endif

	@$(call install_copy, gstreamer1, 0, 0, 0755, -, \
		/usr/libexec/gstreamer-1.0/gst-plugin-scanner)
	@$(call install_copy, gstreamer1, 0, 0, 4755, -, \
		/usr/libexec/gstreamer-1.0/gst-ptp-helper)

ifdef PTXCONF_GSTREAMER1_INTROSPECTION
	@$(call install_tree, gstreamer1, 0, 0, -, \
		/usr/lib/girepository-1.0)
endif

ifdef PTXCONF_PRELINK
	@$(call install_alternative, gstreamer1, 0, 0, 0644, \
		/etc/prelink.conf.d/gstreamer1)
endif

	@$(call install_finish, gstreamer1)

	@$(call touch)

# vim: syntax=make
