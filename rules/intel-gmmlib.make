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
PACKAGES-$(PTXCONF_ARCH_X86)-$(PTXCONF_INTEL_GMMLIB) += intel-gmmlib

#
# Paths and names
#
INTEL_GMMLIB_VERSION	:= 19.2.4
INTEL_GMMLIB_MD5	:= c7ac9eacb98a5c3840b0357bcc096640
INTEL_GMMLIB		:= intel-gmmlib-$(INTEL_GMMLIB_VERSION)
INTEL_GMMLIB_SUFFIX	:= tar.gz
INTEL_GMMLIB_URL	:= https://github.com/intel/gmmlib/archive//$(INTEL_GMMLIB).$(INTEL_GMMLIB_SUFFIX)
INTEL_GMMLIB_SOURCE	:= $(SRCDIR)/$(INTEL_GMMLIB).$(INTEL_GMMLIB_SUFFIX)
INTEL_GMMLIB_DIR	:= $(BUILDDIR)/$(INTEL_GMMLIB)
INTEL_GMMLIB_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# cmake
#
INTEL_GMMLIB_CONF_TOOL	:= cmake
INTEL_GMMLIB_CONF_OPT	:= \
	$(CROSS_CMAKE_USR) \
	-DRUN_TEST_SUITE=OFF

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/intel-gmmlib.targetinstall:
	@$(call targetinfo)

	@$(call install_init, intel-gmmlib)
	@$(call install_fixup, intel-gmmlib,PRIORITY,optional)
	@$(call install_fixup, intel-gmmlib,SECTION,base)
	@$(call install_fixup, intel-gmmlib,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, intel-gmmlib,DESCRIPTION,missing)

	@$(call install_lib, intel-gmmlib, 0, 0, 644, libigdgmm)

	@$(call install_finish, intel-gmmlib)

	@$(call touch)

# vim: syntax=make
