# -*-makefile-*-
#
# Copyright (C) 2013 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_SWIG) += host-swig

#
# Paths and names
#
HOST_SWIG_VERSION	:= 3.0.8
HOST_SWIG_MD5		:= c96a1d5ecb13d38604d7e92148c73c97
HOST_SWIG		:= swig-$(HOST_SWIG_VERSION)
HOST_SWIG_SUFFIX	:= tar.gz
HOST_SWIG_URL		:= $(call ptx/mirror, SF, swig/$(HOST_SWIG).$(HOST_SWIG_SUFFIX))
HOST_SWIG_SOURCE	:= $(SRCDIR)/$(HOST_SWIG).$(HOST_SWIG_SUFFIX)
HOST_SWIG_DIR		:= $(HOST_BUILDDIR)/$(HOST_SWIG)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_SWIG_CONF_TOOL := autoconf
HOST_SWIG_DEVPKG := NO

# no := due to CROSS_PYTHON
HOST_SWIG_CONF_OPT = \
	$(HOST_AUTOCONF_SYSROOT) \
	--without-boost \
	--without-x \
	--without-tcl \
	$(call ptx/ifdef, PTXCONF_HOST_SWIG_PYTHON_SUPPORT, --with-python=$(CROSS_PYTHON), --without-python) \
	$(call ptx/ifdef, PTXCONF_HOST_SWIG_PYTHON3_SUPPORT, --with-python=$(CROSS_PYTHON3), --without-python3) \
	--without-perl5 \
	--without-octave \
	$(call ptx/ifdef, PTXCONF_HOST_SWIG_JAVA_SUPPORT, --with-java=$(PTXCONF_SETUP_JAVA_SDK), --without-java) \
	--without-gcj \
	--without-android \
	--without-guile \
	--without-mzscheme \
	--without-ruby \
	--without-php \
	--without-ocaml \
	--without-pike \
	--without-chicken \
	--without-csharp \
	--without-lua \
	--without-allegrocl \
	--without-clisp \
	--without-r \
	--without-go \
	--without-d

# vim: syntax=make
