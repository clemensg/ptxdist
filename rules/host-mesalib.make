# -*-makefile-*-
#
# Copyright (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_MESALIB) += host-mesalib

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_MESALIB_CONF_TOOL	:= meson
HOST_MESALIB_CONF_OPT	:= \
	$(HOST_MESON_OPT) \
	-Dasm=false \
	-Dbuild-tests=false \
	-Dd3d-drivers-path=/usr/lib/d3d \
	-Ddri-drivers= \
	-Ddri-drivers-path=/usr/lib/dri \
	-Ddri-search-path=/usr/lib/dri \
	-Ddri3=false \
	-Degl=false \
	-Dgallium-drivers= \
	-Dgallium-extra-hud=false \
	-Dgallium-nine=false \
	-Dgallium-omx=disabled \
	-Dgallium-opencl=disabled \
	-Dgallium-va=false \
	-Dgallium-vdpau=false \
	-Dgallium-xa=false \
	-Dgallium-xvmc=false \
	-Dgbm=false \
	-Dgles1=false \
	-Dgles2=false \
	-Dglvnd=false \
	-Dglx=disabled \
	-Dglx-direct=false \
	-Dglx-read-only-text=false \
	-Dlibunwind=false \
	-Dllvm=false \
	-Dlmsensors=false \
	-Domx-libs-path=/usr/lib/dri \
	-Dopengl=true \
	-Dosmesa=none \
	-Dosmesa-bits=8 \
	-Dplatforms= \
	-Dpower8=false \
	-Dselinux=false \
	-Dshader-cache=false \
	-Dshared-glapi=true \
	-Dshared-llvm=false \
	-Dswr-arches=[] \
	-Dtools=glsl \
	-Dva-libs-path=/usr/lib/dri \
	-Dvalgrind=false \
	-Dvdpau-libs-path=/usr/lib/vdpau \
	-Dvulkan-drivers=[] \
	-Dvulkan-icd-dir=/etc/vulkan/icd.d \
	-Dxlib-lease=false \
	-Dxvmc-libs-path=/usr/lib

HOST_MESALIB_MAKE_OPT	:= \
	src/compiler/glsl/glsl_compiler

$(STATEDIR)/host-mesalib.install:
	@$(call targetinfo)
	install -D -m755 $(HOST_MESALIB_DIR)-build/src/compiler/glsl/glsl_compiler $(HOST_MESALIB_PKGDIR)/bin/mesa/glsl_compiler
	@$(call touch)

# vim: syntax=make
