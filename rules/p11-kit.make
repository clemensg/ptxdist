# -*-makefile-*-
#
# Copyright (C) 2019 by Rouven Czerwinski <r.czerwinski@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_P11_KIT) += p11-kit

#
# Paths and names
#
P11_KIT_VERSION	:= 0.23.15
P11_KIT_MD5	:= c4c3eecfe6bd6e62e436f62b51980749
P11_KIT		:= p11-kit-$(P11_KIT_VERSION)
P11_KIT_SUFFIX	:= tar.gz
P11_KIT_URL	:= https://github.com/p11-glue/p11-kit/releases/download/$(P11_KIT_VERSION)/$(P11_KIT).$(P11_KIT_SUFFIX)
P11_KIT_SOURCE	:= $(SRCDIR)/$(P11_KIT).$(P11_KIT_SUFFIX)
P11_KIT_DIR	:= $(BUILDDIR)/$(P11_KIT)
P11_KIT_LICENSE	:= BSD-3-Clause

#
# autoconf
#
P11_KIT_CONF_TOOL	:= autoconf
P11_KIT_CONF_OPT		:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-trust-module \
	--disable-doc \
	--disable-doc-html \
	--disable-doc-pdf \
	--without-libtasn1 \
	--with-libffi \
	--with-systemd \

$(STATEDIR)/p11-kit.targetinstall:
	@$(call targetinfo)

	@$(call install_init, p11-kit)
	@$(call install_fixup, p11-kit,PRIORITY,optional)
	@$(call install_fixup, p11-kit,SECTION,base)
	@$(call install_fixup, p11-kit,AUTHOR,"Rouven Czerwinski <r.czerwinski@pengutronix.de>")
	@$(call install_fixup, p11-kit,DESCRIPTION,missing)

	@$(call install_copy, p11-kit, 0, 0, 0755, -, /usr/bin/p11-kit)

	@$(call install_copy, p11-kit, 0, 0, 0755, -, \
		/usr/libexec/p11-kit/p11-kit-remote)
	@$(call install_copy, p11-kit, 0, 0, 0755, -, \
		/usr/libexec/p11-kit/p11-kit-server)
	@$(call install_copy, p11-kit, 0, 0, 0755, -, \
		/usr/lib/pkcs11/p11-kit-client.so)

	@$(call install_lib,  p11-kit, 0, 0, 0644, libp11-kit)
	@$(call install_link, p11-kit, libp11-kit.so.0.3.0, \
		/usr/lib/p11-kit-proxy.so)

	@$(call install_finish, p11-kit)

	@$(call touch)

# vim: syntax=make
