# -*-makefile-*-
#
# Copyright (C) 2009 by Juergen Beisert
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_TCL) += tcl

#
# Paths and names
#
TCL_MAJOR	:= 8
TCL_MINOR	:= 5
TCL_PL		:= 6
TCL_VERSION	:= $(TCL_MAJOR).$(TCL_MINOR).$(TCL_PL)
TCL		:= tcl$(TCL_VERSION)
TCL_SUFFIX	:= -src.tar.gz
TCL_URL		:= $(PTXCONF_SETUP_SFMIRROR)/tcl/$(TCL)$(TCL_SUFFIX)
TCL_SOURCE	:= $(SRCDIR)/$(TCL)$(TCL_SUFFIX)
TCL_DIR		:= $(BUILDDIR)/$(TCL)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(TCL_SOURCE):
	@$(call targetinfo)
	@$(call get, TCL)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

TCL_PATH	:= PATH=$(CROSS_PATH)
TCL_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
TCL_AUTOCONF := $(CROSS_AUTOCONF_USR) \
	--disable-rpath \
	--disable-symbols \
	--enable-load \
	--enable-shared

# TODO: Provide the correct encoding for the target
# --with-encoding=<valid encode from 'usr/lib/tcl8.5/encoding'>
# Note: TCL uses iso8859-1 until otherwise specified

ifdef PTXCONF_TCL_THREADS
TCL_AUTOCONF += --enable-threads
else
TCL_AUTOCONF += --disable-threads
endif

# 'configure' rejects some tests due to cross compiling

# checking system version... Linux-2.6.25.4-ptx <-- it detects host's one!
TCL_ACONF_VAR := tcl_cv_sys_version=Linux-$(PTXCONF_KERNEL_VERSION)

# checking for working memcmp... no
TCL_ACONF_VAR += ac_cv_func_memcmp_working=yes

# checking proper strstr implementation... unknown
TCL_ACONF_VAR += ac_cv_func_strstr=yes tcl_cv_strstr_unbroken=yes

# checking proper strtoul implementation... unknown
TCL_ACONF_VAR += ac_cv_func_strtoul=yes tcl_cv_strtoul_unbroken=yes

# checking proper strtod implementation... unknown
TCL_ACONF_VAR += ac_cv_func_strtod=yes tcl_cv_strtod_unbroken=yes tcl_cv_strtod_buggy=no

# checking if the C stack grows upwards in memory... unknown
TCL_ACONF_VAR += tcl_cv_stack_grows_up=no

# unresolved issues yet:
#  checking for timezone data... /usr/share/zoneinfo <-- it uses host's one
#
$(STATEDIR)/tcl.prepare:
	@$(call targetinfo)
	@$(call clean, $(TCL_DIR)/unix/config.cache)
	cd $(TCL_DIR)/unix && \
		$(TCL_PATH) $(TCL_ENV) \
		./configure $(TCL_AUTOCONF) $(TCL_ACONF_VAR)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/tcl.compile:
	@$(call targetinfo)
	cd $(TCL_DIR)/unix && $(TCL_PATH) $(MAKE) $(PARALLELMFLAGS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/tcl.install:
	@$(call targetinfo)
	@$(call install, TCL, $(TCL_DIR)/unix)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/tcl.targetinstall:
	@$(call targetinfo)

	@$(call install_init, tcl)
	@$(call install_fixup, tcl,PACKAGE,tcl)
	@$(call install_fixup, tcl,PRIORITY,optional)
	@$(call install_fixup, tcl,VERSION,$(TCL_VERSION))
	@$(call install_fixup, tcl,SECTION,base)
	@$(call install_fixup, tcl,AUTHOR,"Juergen Beisert <juergen\@kreuzholzen.de")
	@$(call install_fixup, tcl,DEPENDS,)
	@$(call install_fixup, tcl,DESCRIPTION,missing)

	@$(call install_copy, tcl, 0, 0, 0755, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR))
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/tclIndex, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/package.tcl, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/init.tcl, n)

	@$(call install_copy, tcl, 0, 0, 0755, -, \
		/usr/bin/tclsh$(TCL_MAJOR).$(TCL_MINOR))
# a simplified link is very useful
	@$(call install_link, tcl, \
		/usr/bin/tclsh$(TCL_MAJOR).$(TCL_MINOR), /usr/bin/tclsh)

	@$(call install_copy, tcl, 0, 0, 0644, -, /usr/lib/libtcl8.5.so)

ifdef PTXCONF_TCL_TESTING
	@$(call install_copy, tcl, 0, 0, 0755, /usr/lib/tcl$(TCL_MAJOR))
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR)/$(TCL_MAJOR).$(TCL_MINOR)/tcltest-2.3.0.tm, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR)/$(TCL_MAJOR).$(TCL_MINOR)/msgcat-1.4.2.tm, n)

	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/tm.tcl, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/parray.tcl, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/clock.tcl, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/auto.tcl, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/history.tcl, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/safe.tcl, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/word.tcl, n)

# avoid a subdirectory hell. Install them where also the other scripts are
	@$(call install_copy, tcl, 0, 0, 0644, \
		$(TCL_DIR)/library/opt/optparse.tcl, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/optparse.tcl, n)

	@$(call install_copy, tcl, 0, 0, 0644, \
		$(TCL_DIR)/library/opt/pkgIndex.tcl, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/pkgIndex.tcl, n)
endif

ifdef PTXCONF_TCL_ENCODING
	@$(call install_copy, tcl, 0, 0, 0755, \
		/usr/lib/tcl$(TCL_MAJOR).$(TCL_MINOR)/encoding)
ifndef PTXCONF_TCL_TESTING
# install some popular code pages
# FIXME: Are these the most common ones? Add more if not
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl8.5/encoding/iso8859-1.enc, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl8.5/encoding/iso8859-15.enc, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl8.5/encoding/cp437.enc, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl8.5/encoding/cp850.enc, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl8.5/encoding/ascii.enc, n)
	@$(call install_copy, tcl, 0, 0, 0644, -, \
		/usr/lib/tcl8.5/encoding/big5.enc, n)
else
# install all code pages
	@cd $(TCL_DIR)/library/encoding; \
	for file in * ; do \
		$(call install_copy, tcl, 0, 0, 0644, \
			$(TCL_DIR)/library/encoding/$$file, \
			/usr/lib/tcl8.5/encoding/$$file, n); \
        done
# copy all tests to the target
	@$(call install_copy, tcl, 0, 0, 0755, /usr/share/tcl-tests)
	@cd $(TCL_DIR)/tests; \
	for file in * ; do \
		PER=`stat -c "%a" $$file` \
		$(call install_copy, tcl, 0, 0, $$PER, \
			$(TCL_DIR)/tests/$$file, \
			/usr/share/tcl-tests/$$file, n); \
        done

# unresolved tests:
# Test file error: EscapeToUtfProc: invalid sub table

endif
endif

	@$(call install_finish, tcl)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

tcl_clean:
	rm -rf $(STATEDIR)/tcl.*
	rm -rf $(PKGDIR)/tcl_*
	rm -rf $(TCL_DIR)

# vim: syntax=make
