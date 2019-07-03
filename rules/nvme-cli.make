# -*-makefile-*-
#
# Copyright (C) 2019 by Lucas Stach <l.stach@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_NVME_CLI) += nvme-cli

#
# Paths and names
#
NVME_CLI_VERSION	:= 1.7
NVME_CLI_MD5		:= ec64bc935957f6bc52109bde704a5a42
NVME_CLI		:= nvme-cli-$(NVME_CLI_VERSION)
NVME_CLI_SUFFIX		:= tar.gz
NVME_CLI_URL		:= https://github.com/linux-nvme/nvme-cli/archive/v$(NVME_CLI_VERSION).$(NVME_CLI_SUFFIX)
NVME_CLI_SOURCE		:= $(SRCDIR)/$(NVME_CLI).$(NVME_CLI_SUFFIX)
NVME_CLI_DIR		:= $(BUILDDIR)/$(NVME_CLI)
NVME_CLI_LICENSE	:= GPL-2.0

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------
NVME_CLI_CONF_TOOL := NO

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------
NVME_CLI_MAKE_OPT := $(CROSS_ENV_PROGS) nvme

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------
NVME_CLI_INSTALL_OPT := PREFIX=/usr install

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------
$(STATEDIR)/nvme-cli.targetinstall:
	@$(call targetinfo)

	@$(call install_init, nvme-cli)
	@$(call install_fixup, nvme-cli,PRIORITY,optional)
	@$(call install_fixup, nvme-cli,SECTION,base)
	@$(call install_fixup, nvme-cli,AUTHOR,"Lucas Stach <l.stach@pengutronix.de>")
	@$(call install_fixup, nvme-cli,DESCRIPTION,missing)

	@$(call install_copy, nvme-cli, 0, 0, 0755, -, /usr/sbin/nvme)

	@$(call install_finish, nvme-cli)

	@$(call touch)

# vim: syntax=make
