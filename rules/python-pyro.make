# -*-makefile-*-
#
# Copyright (C) 2019 by Niklas Reisser <niklas.reisser@de.bosch.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PYTHON_PYRO) += python-pyro

#
# Paths and names
#

PYTHON_PYRO_VERSION	:= 4.76
PYTHON_PYRO		:= Pyro4-$(PYTHON_PYRO_VERSION)
PYTHON_PYRO_MD5		:= 03a09990328c9f2388ac806fa734689c
PYTHON_PYRO_SUFFIX	:= tar.gz
PYTHON_PYRO_URL		:= https://github.com/irmen/Pyro4/archive/$(PYTHON_PYRO_VERSION).$(PYTHON_PYRO_SUFFIX)
PYTHON_PYRO_SOURCE	:= $(SRCDIR)/$(PYTHON_PYRO).$(PYTHON_PYRO_SUFFIX)
PYTHON_PYRO_DIR		:= $(BUILDDIR)/$(PYTHON_PYRO)
PYTHON_PYRO_DEVPKG	:= NO
PYTHON_PYRO_LICENSE	:= MIT
PYTHON_PYRO_LICENSE_FILES	:= file://LICENSE;md5=cd13dafd4eeb0802bb6efea6b4a4bdbc

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

PYTHON_PYRO_CONF_TOOL := python

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/python-pyro.targetinstall:
	@$(call targetinfo)
	@$(call install_init, python-pyro)

	@$(call install_fixup, python-pyro, PRIORITY, optional)
	@$(call install_fixup, python-pyro, VERSION, $(PYTHON_PYRO_VERSION))
	@$(call install_fixup, python-pyro, AUTHOR, "Niklas Reisser <niklas.reisser@de.bosch.com>")
	@$(call install_fixup, python-pyro, DESCRIPTION, missing)
	@$(call install_fixup, python-pyro, DEPENDS, )

	@$(call install_glob, python-pyro, 0, 0, -, \
		/usr/lib/python$(PYTHON_MAJORMINOR)/site-packages/Pyro4,, *.py)

	@$(call install_finish,python-pyro)

	@$(call touch)

# vim: syntax=make
