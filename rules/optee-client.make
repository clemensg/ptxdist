# -*-makefile-*-
#
# Copyright (C) 2017 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_OPTEE_CLIENT) += optee-client

#
# Paths and names
#
OPTEE_CLIENT_VERSION	:= 3.5.0
OPTEE_CLIENT_MD5	:= 2738729cb2457f2b4993ef6b91a6519d
OPTEE_CLIENT		:= optee-client-$(OPTEE_CLIENT_VERSION)
OPTEE_CLIENT_SUFFIX	:= tar.gz
OPTEE_CLIENT_URL	:= https://github.com/OP-TEE/optee_client/archive/$(OPTEE_CLIENT_VERSION).$(OPTEE_CLIENT_SUFFIX)
OPTEE_CLIENT_SOURCE	:= $(SRCDIR)/$(OPTEE_CLIENT).$(OPTEE_CLIENT_SUFFIX)
OPTEE_CLIENT_DIR	:= $(BUILDDIR)/$(OPTEE_CLIENT)
OPTEE_CLIENT_LICENSE	:= BSD-2-Clause

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

OPTEE_CLIENT_CONF_TOOL := NO
OPTEE_CLIENT_MAKE_ENV := \
	$(CROSS_ENV) \
	LIBDIR=/usr/lib \
	INCLUDEDIR=/usr/include

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/optee-client.targetinstall:
	@$(call targetinfo)

	@$(call install_init, optee-client)
	@$(call install_fixup, optee-client,PRIORITY,optional)
	@$(call install_fixup, optee-client,SECTION,base)
	@$(call install_fixup, optee-client,AUTHOR,"Marc Kleine-Budde <mkl@pengutronix.de>")
	@$(call install_fixup, optee-client,DESCRIPTION,missing)

	@$(call install_lib, optee-client, 0, 0, 0644, libteec)
	@$(call install_copy, optee-client, 0, 0, 0755, -, /usr/sbin/tee-supplicant)
ifdef PTXCONF_OPTEE_CLIENT_SYSTEMD_UNIT
	@$(call install_alternative, optee-client, 0, 0, 0644, \
		/usr/lib/systemd/system/tee-supplicant.service)
	@$(call install_link, optee-client, ../tee-supplicant.service,\
		/usr/lib/systemd/system/multi-user.target.wants/tee-supplicant.service)
endif

	@$(call install_finish, optee-client)

	@$(call touch)

# vim: syntax=make
