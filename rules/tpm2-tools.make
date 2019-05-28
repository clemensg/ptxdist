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
PACKAGES-$(PTXCONF_TPM2_TOOLS) += tpm2-tools

#
# Paths and names
#
TPM2_TOOLS_VERSION		:= 3.1.4
TPM2_TOOLS_MD5			:= 61b4a382d24c950148a3f5fe41ac2306
TPM2_TOOLS			:= tpm2-tools-$(TPM2_TOOLS_VERSION)
TPM2_TOOLS_SUFFIX		:= tar.gz
TPM2_TOOLS_URL			:= https://github.com/tpm2-software/tpm2-tools/releases/download/$(TPM2_TOOLS_VERSION)/$(TPM2_TOOLS).$(TPM2_TOOLS_SUFFIX)
TPM2_TOOLS_SOURCE		:= $(SRCDIR)/$(TPM2_TOOLS).$(TPM2_TOOLS_SUFFIX)
TPM2_TOOLS_DIR			:= $(BUILDDIR)/$(TPM2_TOOLS)
TPM2_TOOLS_LICENSE		:= BSD-3-Clause
TPM2_TOOLS_LICENSE_FILES	:= file://LICENSE;md5=91b7c548d73ea16537799e8060cea819

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
TPM2_TOOLS_CONF_TOOL	:= autoconf
TPM2_TOOLS_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-code-coverage \
	--disable-unit \
	--enable-hardening \
	--without-gcov

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

TPM2_TOOLS_PROGS := \
	tpm2_activatecredential \
	tpm2_certify \
	tpm2_create \
	tpm2_createpolicy \
	tpm2_createprimary \
	tpm2_dictionarylockout \
	tpm2_encryptdecrypt \
	tpm2_evictcontrol \
	tpm2_getcap \
	tpm2_getmanufec \
	tpm2_getpubak \
	tpm2_getpubek \
	tpm2_getrandom \
	tpm2_hash \
	tpm2_hmac \
	tpm2_listpersistent \
	tpm2_load \
	tpm2_loadexternal \
	tpm2_makecredential \
	tpm2_nvdefine \
	tpm2_nvlist \
	tpm2_nvread \
	tpm2_nvreadlock \
	tpm2_nvrelease \
	tpm2_nvwrite \
	tpm2_pcrevent \
	tpm2_pcrextend \
	tpm2_pcrlist \
	tpm2_quote \
	tpm2_rc_decode \
	tpm2_readpublic \
	tpm2_rsadecrypt \
	tpm2_rsaencrypt \
	tpm2_send \
	tpm2_sign \
	tpm2_startup \
	tpm2_takeownership \
	tpm2_unseal \
	tpm2_verifysignature

$(STATEDIR)/tpm2-tools.targetinstall:
	@$(call targetinfo)

	@$(call install_init, tpm2-tools)
	@$(call install_fixup, tpm2-tools,PRIORITY,optional)
	@$(call install_fixup, tpm2-tools,SECTION,base)
	@$(call install_fixup, tpm2-tools,AUTHOR,"Marc Kleine-Budde <mkl@pengutronix.de>")
	@$(call install_fixup, tpm2-tools,DESCRIPTION,missing)

	@$(foreach prog, $(TPM2_TOOLS_PROGS), \
                $(call install_copy, tpm2-tools, 0, 0, 0755, -, /usr/bin/$(prog))$(ptx/nl))

	@$(call install_finish, tpm2-tools)

	@$(call touch)

# vim: syntax=make
