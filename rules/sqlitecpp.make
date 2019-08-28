# -*-makefile-*-
#
# Copyright (C) 2019 by Chetan Dayananda <chetan.dayananda@in.bosch.com>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_SQLITECPP) += sqlitecpp

#
# Paths and names
#
SQLITECPP_VERSION   := 2.4.0
SQLITECPP_MD5       := aa0da9aa79bd76bc09446de418b6be08
SQLITECPP           := sqlitecpp-$(SQLITECPP_VERSION)
SQLITECPP_SUFFIX    := tar.gz
SQLITECPP_URL       := https://github.com/SRombauts/SQLiteCpp/archive/$(SQLITECPP_VERSION).$(SQLITECPP_SUFFIX)
SQLITECPP_SOURCE    := $(SRCDIR)/$(SQLITECPP).tar.gz
SQLITECPP_DIR       := $(BUILDDIR)/$(SQLITECPP)
SQLITECPP_LICENSE   := MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

SQLITECPP_CONF_TOOL := cmake
SQLITECPP_CONF_OPT  := $(CROSS_CMAKE_USR) -DSQLITECPP_INTERNAL_SQLITE=OFF

#
# No Target-Install stage because the package only builds a static lib.
#

# vim: syntax=make
