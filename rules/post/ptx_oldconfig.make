# -*-makefile-*-

#
# ptx_oldconfig
#
# execute "make oldconfig" on a programm. Mainly used for
# kconfig based packages.
#
define ptx/oldconfig
	$(call execute,$(1),$(MAKE) \
		$(filter-out --output-sync%,$($(strip $(1))_MAKEVARS) $($(strip $(1))_MAKE_OPT)) oldconfig)
endef

# vim: syntax=make
