# -*-makefile-*-
#
# Copyright (C) 2013 by Philipp Zabel <p.zabel@pengutronix.de>
#               2014 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_WESTON) += weston

#
# Paths and names
#
WESTON_VERSION	:= 6.0.0
LIBWESTON_MAJOR := 6
WESTON_MD5	:= 7c634e262f8a464a076c97fd50ad36b3
WESTON		:= weston-$(WESTON_VERSION)
WESTON_SUFFIX	:= tar.xz
WESTON_URL	:= http://wayland.freedesktop.org/releases/$(WESTON).$(WESTON_SUFFIX)
WESTON_SOURCE	:= $(SRCDIR)/$(WESTON).$(WESTON_SUFFIX)
WESTON_DIR	:= $(BUILDDIR)/$(WESTON)
WESTON_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ifdef PTXCONF_ARCH_X86
WESTON_SIMPLE_DMABUF_DRM-$(PTXCONF_WESTON_SIMPLE_DMABUF_DRM_INTEL) += intel
endif
WESTON_SIMPLE_DMABUF_DRM-$(PTXCONF_WESTON_SIMPLE_DMABUF_DRM_FREEDRENO) += freedreno
WESTON_SIMPLE_DMABUF_DRM-$(PTXCONF_WESTON_SIMPLE_DMABUF_DRM_ETNAVIV) += etnaviv

WESTON_SIMPLE_CLIENTS-y := damage im shm touch
WESTON_SIMPLE_CLIENTS-$(PTXCONF_WESTON_GL) += egl dmabuf-egl

WESTON_CONF_TOOL	:= meson
WESTON_CONF_OPT		:= \
	$(CROSS_MESON_USR) \
	-Dbackend-default=drm \
	-Dbackend-drm=$(call ptx/truefalse,PTXCONF_WESTON_DRM_COMPOSITOR) \
	-Dbackend-drm-screencast-vaapi=false \
	-Dbackend-fbdev=$(call ptx/truefalse,PTXCONF_WESTON_FBDEV_COMPOSITOR) \
	-Dbackend-headless=$(call ptx/truefalse,PTXCONF_WESTON_HEADLESS_COMPOSITOR) \
	-Dbackend-rdp=false \
	-Dbackend-wayland=$(call ptx/truefalse,PTXCONF_WESTON_GL) \
	-Dbackend-x11=false \
	-Dcolor-management-colord=false \
	-Dcolor-management-lcms=false \
	-Ddemo-clients=$(call ptx/truefalse,PTXCONF_WESTON_IVISHELL_EXAMPLE) \
	-Ddesktop-shell-client-default=weston-desktop-shell \
	-Dimage-jpeg=true \
	-Dimage-webp=false \
	-Dlauncher-logind=$(call ptx/truefalse,PTXCONF_SYSTEMD_LOGIND) \
	-Dremoting=$(call ptx/truefalse,PTXCONF_WESTON_REMOTING) \
	-Drenderer-gl=$(call ptx/truefalse,PTXCONF_WESTON_GL) \
	-Dresize-pool=true \
	-Dscreenshare=false \
	-Dshell-desktop=true \
	-Dshell-fullscreen=true \
	-Dshell-ivi=$(call ptx/truefalse,PTXCONF_WESTON_IVISHELL) \
	-Dsimple-clients=$(subst $(space),$(comma),$(WESTON_SIMPLE_CLIENTS-y)) \
	-Dsimple-dmabuf-drm=$(subst $(space),$(comma),$(WESTON_SIMPLE_DMABUF_DRM-y)) \
	-Dsystemd=$(call ptx/truefalse,PTXCONF_WESTON_SYSTEMD) \
	-Dtest-junit-xml=false \
	-Dtools=calibrator,debug,info,terminal,touch-calibrator \
	-Dwcap-decode=$(call ptx/truefalse,PTXCONF_WESTON_WCAP_TOOLS) \
	-Dweston-launch=$(call ptx/truefalse,PTXCONF_WESTON_LAUNCH) \
	-Dxwayland=$(call ptx/truefalse,PTXCONF_WESTON_XWAYLAND) \
	-Dxwayland-path=/usr/bin/Xwayland

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/weston.install:
	@$(call targetinfo)
	@$(call world/install, WESTON)

	@mkdir -p $(WESTON_PKGDIR)/etc/xdg/weston
ifndef PTXCONF_WESTON_IVISHELL_EXAMPLE
	@bindir="/usr/bin" \
		abs_top_builddir="/usr/bin" \
		libexecdir="/usr/libexec" \
		ptxd_replace_magic "$(WESTON_DIR)/weston.ini.in" > \
		"$(WESTON_PKGDIR)/etc/xdg/weston/weston.ini"
else
	@bindir="/usr/bin" \
		westondatadir="/usr/share/weston" \
		ptxd_replace_magic "$(WESTON_DIR)/ivi-shell/weston.ini.in" > \
		"$(WESTON_PKGDIR)/etc/xdg/weston/weston.ini"
endif

	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/weston.targetinstall:
	@$(call targetinfo)

	@$(call install_init, weston)
	@$(call install_fixup, weston,PRIORITY,optional)
	@$(call install_fixup, weston,SECTION,base)
	@$(call install_fixup, weston,AUTHOR,"Philipp Zabel <p.zabel@pengutronix.de>")
	@$(call install_fixup, weston,DESCRIPTION,"wayland reference compositor implementation")

	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-info)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-debug)
ifdef PTXCONF_WESTON_LAUNCH
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-launch)
endif
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-screenshooter)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-terminal)

ifdef PTXCONF_WESTON_WCAP_TOOLS
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/wcap-decode)
endif

	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR))
	@$(call install_lib, weston, 0, 0, 0644, libweston-desktop-$(LIBWESTON_MAJOR))
ifdef PTXCONF_WESTON_XWAYLAND
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/xwayland)
endif
ifdef PTXCONF_WESTON_DRM_COMPOSITOR
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/drm-backend)
endif
ifdef PTXCONF_WESTON_HEADLESS_COMPOSITOR
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/headless-backend)
endif
ifdef PTXCONF_WESTON_FBDEV_COMPOSITOR
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/fbdev-backend)
endif
ifdef PTXCONF_WESTON_GL
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/wayland-backend)
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/gl-renderer)
endif
ifdef PTXCONF_WESTON_REMOTING
	@$(call install_lib, weston, 0, 0, 0644, libweston-$(LIBWESTON_MAJOR)/remoting-plugin)
endif
	@$(call install_lib, weston, 0, 0, 0644, weston/desktop-shell)
	@$(call install_lib, weston, 0, 0, 0644, weston/fullscreen-shell)
ifdef PTXCONF_WESTON_IVISHELL
	@$(call install_lib, weston, 0, 0, 0644, weston/ivi-shell)
endif
ifdef PTXCONF_WESTON_SYSTEMD
	@$(call install_lib, weston, 0, 0, 0644, weston/systemd-notify)
endif

	@$(call install_copy, weston, 0, 0, 0755, -, /usr/libexec/weston-simple-im)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/libexec/weston-desktop-shell)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/libexec/weston-keyboard)


	@$(foreach image, \
		border.png \
		icon_window.png \
		pattern.png \
		sign_close.png \
		sign_maximize.png \
		sign_minimize.png \
		terminal.png \
		wayland.png \
		wayland.svg, \
		$(call install_copy, weston, 0, 0, 0644, -, /usr/share/weston/$(image))$(ptx/nl))

ifdef PTXCONF_WESTON_INSTALL_CONFIG
	@$(call install_alternative, weston, 0, 0, 0644, /etc/xdg/weston/weston.ini)
endif

ifdef PTXCONF_WESTON_IVISHELL_EXAMPLE
	@$(call install_lib, weston, 0, 0, 0644, weston/hmi-controller)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/libexec/weston-ivi-shell-user-interface)

	@$(foreach image, \
		background.png \
		fullscreen.png \
		home.png \
		icon_ivi_clickdot.png \
		icon_ivi_flower.png \
		icon_ivi_simple-egl.png \
		icon_ivi_simple-shm.png \
		icon_ivi_smoke.png \
		panel.png \
		random.png \
		sidebyside.png \
		tiling.png, \
		$(call install_copy, weston, 0, 0, 0644, -, /usr/share/weston/$(image))$(ptx/nl))

	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-clickdot)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-flower)
ifdef PTXCONF_WESTON_GL
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-simple-egl)
endif
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-simple-shm)
	@$(call install_copy, weston, 0, 0, 0755, -, /usr/bin/weston-smoke)
endif

	@$(call install_finish, weston)

	@$(call touch)

# vim: syntax=make
