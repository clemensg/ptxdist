# -*-makefile-*-
#
# Copyright (C) 2007 by Luotao Fu <lfu@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_GLIB) += host-glib

#
# Paths and names
#
HOST_GLIB_DIR	= $(HOST_BUILDDIR)/$(GLIB)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# meson
#
HOST_GLIB_CONF_TOOL	:= meson
HOST_GLIB_CONF_OPT	:= \
	$(HOST_MESON_OPT) \
	-Dbsymbolic_functions=true \
	-Ddtrace=false \
	-Dfam=false \
	-Dforce_posix_threads=true \
	-Dgtk_doc=false \
	-Diconv=libc \
	-Dinstalled_tests=false \
	-Dinternal_pcre=false \
	-Dlibmount=false \
	-Dman=false \
	-Dnls=disabled \
	-Dselinux=disabled \
	-Dsystemtap=false \
	-Dxattr=false

$(STATEDIR)/host-glib.install.post:
	@$(call targetinfo)
	@$(call world/install.post, HOST_GLIB)
	@sed -i "s:'/share':'$(PTXCONF_SYSROOT_HOST)/share':" "$(PTXCONF_SYSROOT_HOST)/bin/gdbus-codegen"
	@sed -i "s:^prefix=.*:prefix=$(PTXCONF_SYSROOT_HOST):" "$(PTXCONF_SYSROOT_HOST)/bin/glib-gettextize"
	@$(call touch)

# vim: syntax=make
