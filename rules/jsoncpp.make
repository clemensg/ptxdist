# -*-makefile-*-
#
# Copyright (C) 2019 by Florian Baeuerle <florian.baeuerle@allegion.com>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_JSONCPP) += jsoncpp

#
# Paths and names
#
JSONCPP_VERSION		:= 1.8.4
JSONCPP_MD5		:= fa47a3ab6b381869b6a5f20811198662
JSONCPP			:= jsoncpp-$(JSONCPP_VERSION)
JSONCPP_SUFFIX		:= tar.gz
JSONCPP_URL		:= https://github.com/open-source-parsers/jsoncpp/archive/$(JSONCPP_VERSION).tar.gz
JSONCPP_SOURCE		:= $(SRCDIR)/jsoncpp-src-$(JSONCPP_VERSION).$(JSONCPP_SUFFIX)
JSONCPP_DIR		:= $(BUILDDIR)/$(JSONCPP)
JSONCPP_LICENSE		:= MIT
JSONCPP_LICENSE_FILES	:= file://LICENSE;md5=fa2a23dd1dc6c139f35105379d76df2b

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

JSONCPP_CONF_TOOL	:= meson
JSONCPP_CONF_OPT	:= \
	$(CROSS_MESON_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/jsoncpp.targetinstall:
	@$(call targetinfo)

	@$(call install_init, jsoncpp)
	@$(call install_fixup, jsoncpp,PRIORITY,optional)
	@$(call install_fixup, jsoncpp,SECTION,base)
	@$(call install_fixup, jsoncpp,AUTHOR,"Florian Baeuerle <florian.baeuerle@allegion.com>")
	@$(call install_fixup, jsoncpp,DESCRIPTION,missing)

	@$(call install_lib, jsoncpp, 0, 0, 0644, libjsoncpp)
	@$(call install_finish, jsoncpp)

	@$(call touch)

# vim: syntax=make
