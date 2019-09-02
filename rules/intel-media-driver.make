# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_ARCH_X86)-$(PTXCONF_INTEL_MEDIA_DRIVER) += intel-media-driver

#
# Paths and names
#
INTEL_MEDIA_DRIVER_VERSION	:= 19.2.1
INTEL_MEDIA_DRIVER_MD5		:= 0f68f480cd49e49516148a9c4909308c
INTEL_MEDIA_DRIVER		:= intel-media-$(INTEL_MEDIA_DRIVER_VERSION)
INTEL_MEDIA_DRIVER_SUFFIX	:= tar.gz
INTEL_MEDIA_DRIVER_URL		:= https://github.com/intel/media-driver/archive/$(INTEL_MEDIA_DRIVER).$(INTEL_MEDIA_DRIVER_SUFFIX)
INTEL_MEDIA_DRIVER_SOURCE	:= $(SRCDIR)/$(INTEL_MEDIA_DRIVER).$(INTEL_MEDIA_DRIVER_SUFFIX)
INTEL_MEDIA_DRIVER_DIR		:= $(BUILDDIR)/$(INTEL_MEDIA_DRIVER)
INTEL_MEDIA_DRIVER_LICENSE	:= MIT AND BSD-3-Clause

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# cmake
#
INTEL_MEDIA_DRIVER_CONF_TOOL	:= cmake
INTEL_MEDIA_DRIVER_CONF_OPT	:= \
	$(CROSS_CMAKE_USR) \
	-DENABLE_KERNELS=ON \
	-DENABLE_NONFREE_KERNELS=ON \
	-DBUILD_KERNELS=OFF \
	-DBUILD_CMRTLIB=OFF \
	-DBYPASS_MEDIA_ULT=yes

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/intel-media-driver.targetinstall:
	@$(call targetinfo)

	@$(call install_init, intel-media-driver)
	@$(call install_fixup, intel-media-driver,PRIORITY,optional)
	@$(call install_fixup, intel-media-driver,SECTION,base)
	@$(call install_fixup, intel-media-driver,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, intel-media-driver,DESCRIPTION,missing)

	@$(call install_lib, intel-media-driver, 0, 0, 0644, dri/iHD_drv_video)

	@$(call install_finish, intel-media-driver)

	@$(call touch)

# vim: syntax=make
