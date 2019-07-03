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
PACKAGES-$(PTXCONF_FFMPEG) += ffmpeg

#
# Paths and names
#
FFMPEG_VERSION	:= 4.1.3
FFMPEG_MD5	:= dcc20dd2682ea01c678b7b8324339d43
FFMPEG		:= ffmpeg-$(FFMPEG_VERSION)
FFMPEG_SUFFIX	:= tar.xz
FFMPEG_URL	:= https://www.ffmpeg.org/releases/$(FFMPEG).$(FFMPEG_SUFFIX)
FFMPEG_SOURCE	:= $(SRCDIR)/$(FFMPEG).$(FFMPEG_SUFFIX)
FFMPEG_DIR	:= $(BUILDDIR)/$(FFMPEG)
# Note: any GPL only code is disabled below with --disable-gpl
FFMPEG_LICENSE	:= LGPL-2.1-or-later AND BSD-3-Clause
FFMPEG_LICENSE_FILES := \
	file://LICENSE.md;md5=e6c05704638b696e6df04470d7fede29 \
	file://COPYING.LGPLv2.1;md5=bd7a443320af8c812e4c18d1b79df004 \
	file://libavcodec/arm/vp8dsp_armv6.S;startline=4;endline=52;md5=24eb31d8cad17de39e517e8d946cdee0 \
	file://libavcodec/mips/ac3dsp_mips.c;startline=2;endline=27;md5=5f25aa1db1ecf13c29efc63800bf6ae8 \

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ifdef PTXCONF_FFMPEG
FFMPEG_CPU := $(strip $(shell ptxd_cross_cc_v | sed -n "s/COLLECT_GCC_OPTIONS=.*'-march=\([^']*\)'.*/\1/p" | tail -n1))
ifeq ($(FFMPEG_CPU),)
FFMPEG_CPU := $(strip $(shell ptxd_cross_cc_v | sed -n "s/COLLECT_GCC_OPTIONS=.*'-mcpu=\([^']*\)'.*/\1/p" | tail -n1))
endif
ifeq ($(FFMPEG_CPU),)
FFMPEG_CPU := generic
endif
endif

#
# autoconf
#
FFMPEG_CONF_TOOL	:= autoconf
FFMPEG_CONF_OPT		:= \
	--prefix=/usr \
	--libdir=/usr/$(CROSS_LIB_DIR) \
	--disable-rpath \
	--disable-gpl \
	--disable-version3 \
	--disable-nonfree \
	--disable-static \
	--enable-shared \
	--disable-small \
	--enable-runtime-cpudetect \
	--disable-gray \
	--enable-swscale-alpha \
	\
	--disable-autodetect \
	--disable-programs \
	--disable-ffmpeg \
	--disable-ffplay \
	--disable-ffprobe \
	--disable-doc \
	--disable-htmlpages \
	--disable-manpages \
	--disable-podpages \
	--disable-txtpages \
	\
	--disable-avdevice \
	--enable-avcodec \
	--enable-avformat \
	--enable-swresample \
	--disable-swscale \
	--disable-postproc \
	--enable-avfilter \
	--disable-avresample \
	\
	--enable-pthreads \
	--disable-network \
	--enable-dct \
	--enable-dwt \
	--enable-error-resilience \
	--enable-lsp \
	--enable-lzo \
	--enable-mdct \
	--enable-rdft \
	--enable-fft \
	--enable-faan \
	--enable-pixelutils \
	\
	--enable-encoders \
	--enable-decoders \
	--disable-hwaccels \
	--enable-muxers \
	--enable-demuxers \
	--enable-parsers \
	--enable-bsfs \
	--disable-protocols \
	--disable-indevs \
	--disable-outdevs \
	--disable-devices \
	--disable-filters \
	\
	--disable-alsa \
	--disable-appkit \
	--disable-avfoundation \
	--disable-avisynth \
	--disable-bzlib \
	--disable-coreimage \
	--disable-chromaprint \
	--disable-frei0r \
	--disable-gcrypt \
	--disable-gmp \
	--disable-gnutls \
	--disable-iconv \
	--disable-jni \
	--disable-ladspa \
	--disable-libaom \
	--disable-libass \
	--disable-libbluray \
	--disable-libbs2b \
	--disable-libcaca \
	--disable-libcelt \
	--disable-libcdio \
	--disable-libcodec2 \
	--disable-libdavs2 \
	--disable-libdc1394 \
	--disable-libfdk-aac \
	--disable-libflite \
	--disable-libfontconfig \
	--disable-libfreetype \
	--disable-libfribidi \
	--disable-libgme \
	--disable-libgsm \
	--disable-libiec61883 \
	--disable-libilbc \
	--disable-libjack \
	--disable-libklvanc \
	--disable-libkvazaar \
	--disable-liblensfun \
	--disable-libmodplug \
	--disable-libmp3lame \
	--disable-libopencore-amrnb \
	--disable-libopencore-amrwb \
	--disable-libopencv \
	--disable-libopenh264 \
	--disable-libopenjpeg \
	--disable-libopenmpt \
	--disable-libopus \
	--disable-libpulse \
	--disable-librsvg \
	--disable-librubberband \
	--disable-librtmp \
	--disable-libshine \
	--disable-libsmbclient \
	--disable-libsnappy \
	--disable-libsoxr \
	--disable-libspeex \
	--disable-libsrt \
	--disable-libssh \
	--disable-libtensorflow \
	--disable-libtesseract \
	--disable-libtheora \
	--disable-libtls \
	--disable-libtwolame \
	--disable-libv4l2 \
	--disable-libvidstab \
	--disable-libvmaf \
	--disable-libvo-amrwbenc \
	--disable-libvorbis \
	--disable-libvpx \
	--disable-libwavpack \
	--disable-libwebp \
	--disable-libx264 \
	--disable-libx265 \
	--disable-libxavs \
	--disable-libxavs2 \
	--disable-libxcb \
	--disable-libxcb-shm \
	--disable-libxcb-xfixes \
	--disable-libxcb-shape \
	--disable-libxvid \
	--disable-libxml2 \
	--disable-libzimg \
	--disable-libzmq \
	--disable-libzvbi \
	--disable-lv2 \
	--disable-lzma \
	--disable-decklink \
	--disable-libndi_newtek \
	--disable-mbedtls \
	--disable-mediacodec \
	--disable-libmysofa \
	--disable-openal \
	--disable-opencl \
	--disable-opengl \
	--disable-openssl \
	--disable-sndio \
	--disable-schannel \
	--disable-sdl2 \
	--disable-securetransport \
	--disable-vapoursynth \
	--disable-xlib \
	--disable-zlib \
	--disable-amf \
	--disable-audiotoolbox \
	--disable-cuda-sdk \
	--disable-cuvid \
	--disable-d3d11va \
	--disable-dxva2 \
	--disable-ffnvcodec \
	--disable-libdrm \
	--disable-libmfx \
	--disable-libnpp \
	--disable-mmal \
	--disable-nvdec \
	--disable-nvenc \
	--disable-omx \
	--disable-omx-rpi \
	--disable-rkmpp \
	--disable-v4l2_m2m \
	--disable-vaapi \
	--disable-vdpau \
	--disable-videotoolbox \
	\
	--arch=$(PTXCONF_ARCH_STRING) \
	--cpu=$(FFMPEG_CPU) \
	--cross-prefix=$(PTXCONF_COMPILER_PREFIX) \
	--enable-cross-compile \
	--target-os=linux \
	--target-exec=false \
	--doxygen=false \
	--enable-pic \
	--disable-lto \
	\
	--enable-optimizations \
	--disable-stripping

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ffmpeg.targetinstall:
	@$(call targetinfo)

	@$(call install_init, ffmpeg)
	@$(call install_fixup, ffmpeg,PRIORITY,optional)
	@$(call install_fixup, ffmpeg,SECTION,base)
	@$(call install_fixup, ffmpeg,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, ffmpeg,DESCRIPTION,missing)

	@$(call install_lib, ffmpeg, 0, 0, 0644, libavcodec)
	@$(call install_lib, ffmpeg, 0, 0, 0644, libavfilter)
	@$(call install_lib, ffmpeg, 0, 0, 0644, libavformat)
	@$(call install_lib, ffmpeg, 0, 0, 0644, libavutil)
	@$(call install_lib, ffmpeg, 0, 0, 0644, libswresample)

	@$(call install_finish, ffmpeg)

	@$(call touch)

# vim: syntax=make
