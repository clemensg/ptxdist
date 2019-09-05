# -*-makefile-*-
#
# Copyright (C) 2018 by Sergey Zhuravlevich
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_SDL2) += sdl2

#
# Paths and names
#
SDL2_VERSION	:= 2.0.10
SDL2_MD5	:= 5a2114f2a6f348bdab5bf52b994811db
SDL2		:= SDL2-$(SDL2_VERSION)
SDL2_SUFFIX	:= tar.gz
SDL2_URL	:= https://www.libsdl.org/release/$(SDL2).$(SDL2_SUFFIX)
SDL2_SOURCE	:= $(SRCDIR)/$(SDL2).$(SDL2_SUFFIX)
SDL2_DIR	:= $(BUILDDIR)/$(SDL2)
SDL2_LICENSE	:= zlib

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
SDL2_CONF_TOOL	:= autoconf
SDL2_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--enable-shared \
	--disable-static \
	--enable-libtool-lock \
	--enable-assertions=auto \
	--enable-dependency-tracking \
	--enable-libc \
	--enable-gcc-atomics \
	--enable-atomic \
	--$(call ptx/endis,PTXCONF_SDL2_AUDIO)-audio \
	--$(call ptx/endis,PTXCONF_SDL2_VIDEO)-video \
	--enable-render \
	--enable-events \
	--enable-joystick \
	--enable-haptic \
	--enable-sensor \
	--disable-power \
	--disable-filesystem \
	--enable-threads \
	--enable-timers \
	--enable-file \
	--enable-loadso \
	--enable-cpuinfo \
	--enable-assembly \
	--disable-ssemath \
	--disable-mmx \
	--disable-3dnow \
	--disable-sse \
	--disable-sse2 \
	--disable-sse3 \
	--disable-altivec \
	--$(call ptx/endis,PTXCONF_SDL2_OSS)-oss \
	--$(call ptx/endis,PTXCONF_SDL2_ALSA)-alsa \
	--disable-alsatest \
	--disable-alsa-shared \
	--disable-jack \
	--disable-jack-shared \
	--disable-esd \
	--disable-esdtest \
	--disable-esd-shared \
	--$(call ptx/endis,PTXCONF_SDL2_PULSEAUDIO)-pulseaudio \
	--$(call ptx/endis,PTXCONF_SDL2_PULSEAUDIO)-pulseaudio-shared \
	--disable-arts \
	--disable-arts-shared \
	--disable-nas \
	--disable-nas-shared \
	--disable-sndio \
	--disable-sndio-shared \
	--disable-fusionsound \
	--disable-fusionsound-shared \
	--disable-diskaudio \
	--disable-dummyaudio \
	--disable-libsamplerate \
	--disable-libsamplerate-shared \
	--$(call ptx/endis,PTXCONF_SDL2_WAYLAND)-video-wayland \
	--disable-video-wayland-qt-touch \
	--$(call ptx/endis,PTXCONF_SDL2_WAYLAND)-wayland-shared \
	--disable-video-rpi \
	--$(call ptx/endis,PTXCONF_SDL2_XORG)-video-x11 \
	--disable-x11-shared \
	--$(call ptx/endis,PTXCONF_SDL2_XORG)-video-x11-xcursor \
	--disable-video-x11-xdbe \
	--disable-video-x11-xinerama \
	--$(call ptx/endis,PTXCONF_SDL2_XORG)-video-x11-xinput \
	--$(call ptx/endis,PTXCONF_SDL2_XORG)-video-x11-xrandr \
	--disable-video-x11-scrnsaver \
	--disable-video-x11-xshape \
	--$(call ptx/endis,PTXCONF_SDL2_XORG)-video-x11-vm \
	--disable-video-vivante \
	--disable-video-cocoa \
	--disable-render-metal \
	--disable-video-directfb \
	--disable-directfb-shared \
	--$(call ptx/endis,PTXCONF_SDL2_KMS)-video-kmsdrm \
	--$(call ptx/endis,PTXCONF_SDL2_KMS)-kmsdrm-shared \
	--enable-video-dummy \
	--$(call ptx/endis,PTXCONF_SDL2_OPENGL)-video-opengl \
	--$(call ptx/endis,PTXCONF_SDL2_OPENGLES)-video-opengles \
	--$(call ptx/endis,PTXCONF_SDL2_OPENGLES1)-video-opengles1 \
	--$(call ptx/endis,PTXCONF_SDL2_OPENGLES2)-video-opengles2 \
	--disable-video-vulkan \
	--$(call ptx/endis,PTXCONF_SDL2_UDEV)-libudev \
	--$(call ptx/endis,PTXCONF_SDL2_DBUS)-dbus \
	--disable-ime \
	--disable-ibus \
	--disable-fcitx \
	--$(call ptx/endis,PTXCONF_SDL2_TSLIB)-input-tslib \
	--enable-pthreads \
	--enable-pthread-sem \
	--disable-directx \
	--disable-wasapi \
	--enable-sdl-dlopen \
	--enable-hidapi \
	--enable-clock_gettime \
	--disable-rpath \
	--disable-backgrounding-signal \
	--disable-foregrounding-signal \
	--disable-render-d3d \
	--disable-sdl2-config \
	--$(call ptx/wwo,PTXCONF_SDL2_XORG)-x

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/sdl2.targetinstall:
	@$(call targetinfo)

	@$(call install_init, sdl2)
	@$(call install_fixup, sdl2,PRIORITY,optional)
	@$(call install_fixup, sdl2,SECTION,base)
	@$(call install_fixup, sdl2,AUTHOR,"Sergey Zhuravlevich <zhurxx@gmail.com>")
	@$(call install_fixup, sdl2,DESCRIPTION,missing)

	@$(call install_lib, sdl2, 0, 0, 0644, libSDL2-2.0)

	@$(call install_finish, sdl2)

	@$(call touch)

# vim: syntax=make
