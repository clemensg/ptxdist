# -*-makefile-*-
#
# Copyright (C) 2015 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GST_PYTHON1) += gst-python1

#
# Paths and names
#
GST_PYTHON1_VERSION	:= 1.16.0
GST_PYTHON1_MD5		:= 877b2ed2aaffdb62e63f38ea9469b70f
GST_PYTHON1		:= gst-python-$(GST_PYTHON1_VERSION)
GST_PYTHON1_SUFFIX	:= tar.xz
GST_PYTHON1_URL		:= http://gstreamer.freedesktop.org/src/gst-python/$(GST_PYTHON1).$(GST_PYTHON1_SUFFIX)
GST_PYTHON1_SOURCE	:= $(SRCDIR)/$(GST_PYTHON1).$(GST_PYTHON1_SUFFIX)
GST_PYTHON1_DIR		:= $(BUILDDIR)/$(GST_PYTHON1)
GST_PYTHON1_BUILD_OOT	:= YES
GST_PYTHON1_LICENSE	:= LGPL-2.1-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# meson
#
GST_PYTHON1_CONF_TOOL	:= meson
GST_PYTHON1_CONF_OPT	:= \
	$(CROSS_MESON_USR) \
	-Dlibpython-dir=/usr/lib \
	-Dpython=$(CROSS_PYTHON3)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gst-python1.install:
	@$(call targetinfo)
	@$(call world/install, GST_PYTHON1)
	@$(call world/env, GST_PYTHON1) ptxd_make_world_install_python_cleanup
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gst-python1.targetinstall:
	@$(call targetinfo)

	@$(call install_init, gst-python1)
	@$(call install_fixup, gst-python1,PRIORITY,optional)
	@$(call install_fixup, gst-python1,SECTION,base)
	@$(call install_fixup, gst-python1,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, gst-python1,DESCRIPTION,missing)

	@$(call install_glob, gst-python1, 0, 0, -, \
		/usr/lib/python$(PYTHON3_MAJORMINOR)/site-packages/gi,, *.py *.la)

	@$(call install_lib, gst-python1, 0, 0, 0644, gstreamer-1.0/libgstpython*)

	@$(call install_finish, gst-python1)

	@$(call touch)

# vim: syntax=make
