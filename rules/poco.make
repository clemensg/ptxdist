# -*-makefile-*-
#
# Copyright (C) 2010 by Robert Schwebel <r.schwebel@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_POCO) += poco

#
# Paths and names
#
POCO_VERSION	:= 1.9.0
POCO_MD5	:= 9047586e0ba393bfeced96e3b7ae6286
POCO		:= poco-$(POCO_VERSION)
POCO_SUFFIX	:= tar.gz
POCO_URL	:= http://pocoproject.org/releases/$(POCO)/$(POCO)-all.$(POCO_SUFFIX)
POCO_SOURCE	:= $(SRCDIR)/$(POCO).$(POCO_SUFFIX)
POCO_DIR	:= $(shell readlink -f "$(BUILDDIR)/$(POCO)")
POCO_LICENSE	:= BSL-1.0

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

POCO_LIBS-					:= CppUnit
POCO_LIBS-					+= CppUnit/WinTestRunner
POCO_LIBS-					+= Data/ODBC
POCO_LIBS-					+= PageCompiler
POCO_LIBS-					+= PageCompiler/File2Page

POCO_LIBS-y					+= Foundation
POCO_LIBS-$(PTXCONF_POCO_ENCODINGS)		+= Encodings
POCO_LIBS-$(PTXCONF_POCO_XML)			+= XML
POCO_LIBS-$(PTXCONF_POCO_JSON)			+= JSON
POCO_LIBS-$(PTXCONF_POCO_UTIL)			+= Util
POCO_LIBS-$(PTXCONF_POCO_NET)			+= Net
POCO_LIBS-$(PTXCONF_POCO_NETSSL_OPENSSL)	+= NetSSL_OpenSSL
POCO_LIBS-$(PTXCONF_POCO_CRYPTO)		+= Crypto
POCO_LIBS-$(PTXCONF_POCO_DATA)			+= Data
POCO_LIBS-$(PTXCONF_POCO_DATA_SQLITE)		+= Data/SQLite
POCO_LIBS-$(PTXCONF_POCO_DATA_MYSQL)		+= Data/MySQL
POCO_LIBS-$(PTXCONF_POCO_ZIP)			+= Zip
POCO_LIBS-$(PTXCONF_POCO_MONGODB)		+= MongoDB
POCO_LIBS-$(PTXCONF_POCO_REDIS)			+= Redis

POCO_CONF_TOOL	:= autoconf
POCO_CONF_OPT	:= \
	--config=Linux \
	--prefix=/usr \
	--no-tests \
	--no-samples \
	--omit=$(subst $(ptx/def/space),$(ptx/def/comma),$(POCO_LIBS-)) \
	$(call ptx/ifdef/PTXCONF_POCO_POQUITO,--poquito) \
	--unbundled \
	--shared

POCO_MAKE_ENV	:= \
	$(CROSS_ENV) \
	CROSS_COMPILE=$(PTXCONF_COMPILER_PREFIX) \
	POCO_TARGET_OSNAME=Linux \
	POCO_TARGET_OSARCH=$(PTXCONF_ARCH_STRING)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/poco.targetinstall:
	@$(call targetinfo)

	@$(call install_init, poco)
	@$(call install_fixup, poco,PRIORITY,optional)
	@$(call install_fixup, poco,SECTION,base)
	@$(call install_fixup, poco,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, poco,DESCRIPTION,missing)

	@$(foreach lib, $(POCO_LIBS-y), \
		$(call install_lib, poco, 0, 0, 0644, \
			libPoco$(subst /,,$(subst _OpenSSL,,$(lib))));)

	@$(call install_finish, poco)

	@$(call touch)

# vim: syntax=make
