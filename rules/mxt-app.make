# -*-makefile-*-
#
# Copyright (C) 2019 by Lucas Stach <l.stach@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_MXT_APP) += mxt-app

#
# Paths and names
#
MXT_APP_VERSION	:= 1.28
MXT_APP_MD5	:= a56f6b28f193a7c21cd83cbe02f33dcc
MXT_APP		:= mxt-app-$(MXT_APP_VERSION)
MXT_APP_SUFFIX	:= tar.gz
MXT_APP_URL	:= https://github.com/atmel-maxtouch/mxt-app/archive/v$(MXT_APP_VERSION).$(MXT_APP_SUFFIX)
MXT_APP_SOURCE	:= $(SRCDIR)/$(MXT_APP).$(MXT_APP_SUFFIX)
MXT_APP_DIR	:= $(BUILDDIR)/$(MXT_APP)
MXT_APP_LICENSE	:= BSD-2-Clause

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------
MXT_APP_CONF_TOOL	:= autoconf
MXT_APP_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-debug \
	--disable-man

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/mxt-app.targetinstall:
	@$(call targetinfo)

	@$(call install_init, mxt-app)
	@$(call install_fixup, mxt-app,PRIORITY,optional)
	@$(call install_fixup, mxt-app,SECTION,base)
	@$(call install_fixup, mxt-app,AUTHOR,"Lucas Stach <l.stach@pengutronix.de>")
	@$(call install_fixup, mxt-app,DESCRIPTION,missing)

	@$(call install_copy, mxt-app, 0, 0, 0755, -, /usr/bin/mxt-app)

	@$(call install_finish, mxt-app)

	@$(call touch)

# vim: syntax=make
