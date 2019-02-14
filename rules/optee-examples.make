# -*-makefile-*-
#
# Copyright (C) 2018 by Rouven Czerwinski <rouven@czerwinskis.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_ARCH_ARM)-$(PTXCONF_OPTEE_EXAMPLES) += optee-examples

#
# Paths and names
#
OPTEE_EXAMPLES_VERSION	:= 3.4.0
OPTEE_EXAMPLES_MD5	:= 20bf84c5c647f9270e9edb9bb79f75db
OPTEE_EXAMPLES		:= optee-examples-$(OPTEE_EXAMPLES_VERSION)
OPTEE_EXAMPLES_SUFFIX	:= tar.gz
OPTEE_EXAMPLES_URL	:= https://github.com/linaro-swg/optee_examples/archive/$(OPTEE_EXAMPLES_VERSION).$(OPTEE_EXAMPLES_SUFFIX)
OPTEE_EXAMPLES_SOURCE	:= $(SRCDIR)/$(OPTEE_EXAMPLES).$(OPTEE_EXAMPLES_SUFFIX)
OPTEE_EXAMPLES_DIR	:= $(BUILDDIR)/$(OPTEE_EXAMPLES)
OPTEE_EXAMPLES_LICENSE	:= BSD-2-Clause

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

OPTEE_EXAMPLES_CONF_TOOL	:= NO
OPTEE_EXAMPLES_MAKE_ENV		:= \
	$(CROSS_ENV) \
	HOST_CROSS_COMPILE=$(call remove_quotes,$(PTXCONF_COMPILER_PREFIX)) \
	TA_DEV_KIT_DIR=$(PTXDIST_SYSROOT_TARGET)/usr/lib/optee-os \
	TEEC_EXPORT=$(PTXDIST_SYSROOT_TARGET)/usr

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/optee-examples.install:
	@$(call targetinfo)
	@install -vd -m755 $(OPTEE_EXAMPLES_PKGDIR)/usr/lib/optee_armtz
	@install -vd -m755 $(OPTEE_EXAMPLES_PKGDIR)/usr/lib/optee/examples
	@install -v -m644 $(OPTEE_EXAMPLES_DIR)/out/ta/* $(OPTEE_EXAMPLES_PKGDIR)/usr/lib/optee_armtz
	@install -v -m755 $(OPTEE_EXAMPLES_DIR)/out/ca/* $(OPTEE_EXAMPLES_PKGDIR)/usr/lib/optee/examples/
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/optee-examples.targetinstall:
	@$(call targetinfo)

	@$(call install_init, optee-examples)
	@$(call install_fixup, optee-examples,PRIORITY,optional)
	@$(call install_fixup, optee-examples,SECTION,base)
	@$(call install_fixup, optee-examples,AUTHOR,"Rouven Czerwinski <rouven@czerwinskis.de>")
	@$(call install_fixup, optee-examples,DESCRIPTION,missing)

	@$(call install_tree, optee-examples, 0, 0, -, /usr/lib/optee_armtz)
	@$(call install_tree, optee-examples, 0, 0, -, /usr/lib/optee/examples)

	@$(call install_finish, optee-examples)

	@$(call touch)

# vim: syntax=make
