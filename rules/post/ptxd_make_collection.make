# -*-makefile-*-
#
# Copyright (C) 2012 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

# calculate a unique temporary file name
define _ptx_collection_mangle
$(PTXDIST_TEMPDIR)/.$(subst /,-,$(subst $(PTXDIST_WORKSPACE)/,,$(strip $(1))))
endef
# generate the actual package list
define _ptx_collection_do
$(PACKAGES-y) $(filter $(foreach PKG,$(call ptx/force-sh, sed -n 's/^PTXCONF_\([^_][^=]*\)=y$$/\1/p' "$(strip $(1))"),$(PTX_MAP_TO_package_$(PKG))), $(PACKAGES-m))
endef
# mark the collection for verification and save the package list
define _ptx_collection_write
$(eval ACTIVE_COLLECTIONS += $(1))
$(file >$(2),_pkg := $(3))
$(3)
endef
# load the package list if available, otherwise generate it
define _ptx_collection_once
$(if $(wildcard $(2)),$(eval include $(2))$(_pkg),$(call _ptx_collection_write,$(1),$(2),$(call _ptx_collection_do,$(1))))
endef
define _ptx_collection
$(call _ptx_collection_once,$(1),$(call _ptx_collection_mangle,$(1)))
endef

ptx/collection = $(strip $(call _ptx_collection,$(strip $(1))))

PHONY += ptx-validate-collections
$(STATEDIR)/virtual-host-tools.install: | ptx-validate-collections

ptx-validate-collections:
	@$(ptx/env) \
	ptx_collections="$(ACTIVE_COLLECTIONS)" \
	ptxd_make_validate_collection

# vim: syntax=make
