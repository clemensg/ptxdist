# -*-makefile-*-
#
# Copyright (C) 2018 by Alexander Dahl <ada@thorsis.com>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_JQ) += jq

#
# Paths and names
#
JQ_VERSION	:= 1.6
JQ_MD5		:= e68fbd6a992e36f1ac48c99bbf825d6b
JQ		:= jq-$(JQ_VERSION)
JQ_SUFFIX	:= tar.gz
JQ_URL		:= https://github.com/stedolan/jq/releases/download/$(JQ)/$(JQ).$(JQ_SUFFIX)
JQ_SOURCE	:= $(SRCDIR)/$(JQ).$(JQ_SUFFIX)
JQ_DIR		:= $(BUILDDIR)/$(JQ)
JQ_LICENSE	:= MIT AND CC-BY-3.0
JQ_LICENSE_FILES := file://COPYING;md5=15d03e360fa7399f76d5a4359fc72cbf

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
JQ_CONF_TOOL	:= autoconf
JQ_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-maintainer-mode \
	--disable-valgrind \
	--disable-gcov \
	--disable-docs \
	--disable-error-injection \
	--disable-all-static \
	--enable-pthread-tls \
	--without-oniguruma

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/jq.targetinstall:
	@$(call targetinfo)

	@$(call install_init, jq)
	@$(call install_fixup, jq,PRIORITY,optional)
	@$(call install_fixup, jq,SECTION,base)
	@$(call install_fixup, jq,AUTHOR,"Alexander Dahl <ada@thorsis.com>")
	@$(call install_fixup, jq,DESCRIPTION,missing)

	@$(call install_lib, jq, 0, 0, 0644, libjq)
	@$(call install_copy, jq, 0, 0, 0755, -, /usr/bin/jq)

	@$(call install_finish, jq)

	@$(call touch)

# vim: ft=make noet ts=8 sw=8
