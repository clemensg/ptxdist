# -*-makefile-*-
#
# Copyright (C) 2019 by Denis Osterland <Denis.Osterland@diehl.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_PYTHON_SCONS) += host-python-scons

#
# Paths and names
#
HOST_PYTHON_SCONS_VERSION	:= 3.0.1
HOST_PYTHON_SCONS_MD5		:= b6a292e251b34b82c203b56cfa3968b3
HOST_PYTHON_SCONS		:= python-scons-$(HOST_PYTHON_SCONS_VERSION)
HOST_PYTHON_SCONS_SUFFIX	:= tar.gz
HOST_PYTHON_SCONS_URL		:= $(call ptx/mirror, SF, scons/scons-$(HOST_PYTHON_SCONS_VERSION).$(HOST_PYTHON_SCONS_SUFFIX))
HOST_PYTHON_SCONS_SOURCE	:= $(SRCDIR)/$(HOST_PYTHON_SCONS).$(HOST_PYTHON_SCONS_SUFFIX)
HOST_PYTHON_SCONS_DIR		:= $(HOST_BUILDDIR)/$(HOST_PYTHON_SCONS)
HOST_PYTHON_SCONS_LICENSE	:= MIT
HOST_PYTHON_SCONS_LICENSE_FILES	:= file://LICENSE.txt;md5=46ddf66004e5be5566367cb525a66fc6

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_PYTHON_SCONS_CONF_TOOL	:= python

# vim: syntax=make
