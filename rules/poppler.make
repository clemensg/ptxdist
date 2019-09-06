# -*-makefile-*-
#
# Copyright (C) 2007 by Luotao Fu <l.fu@pengutronix.de>
#               2009 by Robert Schwebel
#               2017 by Roland Hieber <r.hieber@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#
# TODOs for improvement:
# - package libnss for signature support in PDFs
# - package libtiff for additional TIFF support
# - runtime-test the Qt5 backend
# - package libopenjpeg and build with --enable-libopenjpeg
#
# We provide this package
#
PACKAGES-$(PTXCONF_POPPLER) += poppler

#
# Paths and names
#
POPPLER_VERSION	:= 0.80.0
POPPLER_MD5	:= 8ff9964d1fcc9c334a9c66f6f426ab9c
POPPLER		:= poppler-$(POPPLER_VERSION)
POPPLER_SUFFIX	:= tar.xz
POPPLER_URL	:= http://poppler.freedesktop.org/$(POPPLER).$(POPPLER_SUFFIX)
POPPLER_SOURCE	:= $(SRCDIR)/$(POPPLER).$(POPPLER_SUFFIX)
POPPLER_DIR	:= $(BUILDDIR)/$(POPPLER)
POPPLER_LICENSE	:= GPL-2.0-only OR GPL-3.0-only
POPPLER_LICENSE_FILES	:= \
	file://COPYING;md5=751419260aa954499f7abaabaa882bbe \
	file://COPYING3;md5=d32239bcb673463ab874e80d47fae504

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

POPPLER_PATH	:= PATH=$(CROSS_PATH)
POPPLER_ENV 	:= $(CROSS_ENV)

#
# CMake
#
POPPLER_CONF_TOOL	:= cmake
POPPLER_CONF_OPT	:= \
	$(CROSS_CMAKE_USR) \
	-DBUILD_CPP_TESTS=NO \
	-DBUILD_GTK_TESTS=NO \
	-DBUILD_QT5_TESTS=NO \
	-DBUILD_SHARED_LIBS=ON \
	-DENABLE_CMS=$(call ptx/ifdef,PTXCONF_POPPLER_CMS,lcms2,none) \
	-DENABLE_CPP=$(call ptx/onoff,PTXCONF_POPPLER_CPP) \
	-DENABLE_DCTDECODER=$(call ptx/ifdef,PTXCONF_POPPLER_JPEG,libjpeg,none) \
	-DENABLE_GLIB=$(call ptx/onoff,PTXCONF_POPPLER_GLIB) \
	-DENABLE_GOBJECT_INTROSPECTION=$(call ptx/onoff,PTXCONF_POPPLER_INTROSPECTION) \
	-DENABLE_GTK_DOC=NO \
	-DENABLE_LIBCURL=$(call ptx/onoff,PTXCONF_POPPLER_CURL) \
	-DENABLE_LIBOPENJPEG=$(call ptx/ifdef,PTXCONF_POPPLER_OPENJPEG,openjpeg2,none) \
	-DENABLE_QT5=$(call ptx/onoff,PTXCONF_POPPLER_QT5) \
	-DENABLE_QT_STRICT_ITERATORS=ON \
	-DENABLE_SPLASH=$(call ptx/onoff,PTXCONF_POPPLER_SPLASH) \
	-DENABLE_UNSTABLE_API_ABI_HEADERS=OFF \
	-DENABLE_UTILS=$(call ptx/onoff,PTXCONF_POPPLER_BIN) \
	-DENABLE_XPDF_HEADERS=$(call ptx/onoff,PTXCONF_POPPLER_XPDF) \
	-DENABLE_ZLIB=$(call ptx/onoff,PTXCONF_POPPLER_ZLIB) \
	-DENABLE_ZLIB_UNCOMPRESS=NO \
	-DEXTRA_WARN=NO \
	-DFONT_CONFIGURATION=fontconfig \
	-DSPLASH_CMYK=$(call ptx/onoff,PTXCONF_POPPLER_SPLASH_CMYK) \
	-DTESTDATADIR=. \
	-DUSE_FLOAT=$(call ptx/onoff,PTXCONF_POPPLER_SPLASH_SINGLE) \
	-DWITH_Cairo=$(call ptx/onoff,PTXCONF_POPPLER_CAIRO) \
	-DWITH_GLIB=$(call ptx/onoff,PTXCONF_POPPLER_GLIB) \
	-DWITH_GObjectIntrospection=$(call ptx/onoff,PTXCONF_POPPLER_INTROSPECTION) \
	-DWITH_GTK=NO \
	-DWITH_Iconv=ON \
	-DWITH_JPEG=$(call ptx/onoff,PTXCONF_POPPLER_JPEG) \
	-DWITH_NSS3=$(call ptx/onoff,PTXCONF_POPPLER_NSS) \
	-DWITH_PNG=$(call ptx/onoff,PTXCONF_POPPLER_PNG) \
	-DWITH_TIFF=$(call ptx/onoff,PTXCONF_POPPLER_TIFF)

ifdef PTXCONF_POPPLER_QT5
POPPLER_COMPILE_ENV := \
	ICECC_REMOTE_CPP=0
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/poppler.targetinstall:
	@$(call targetinfo)

	@$(call install_init, poppler)
	@$(call install_fixup, poppler, PRIORITY, optional)
	@$(call install_fixup, poppler, SECTION, base)
	@$(call install_fixup, poppler, AUTHOR, "r.schwebel@pengutronix.de")
	@$(call install_fixup, poppler, DESCRIPTION, missing)

	@$(call install_lib, poppler, 0, 0, 0644, libpoppler)

ifdef PTXCONF_POPPLER_BIN
	@cd $(PKGDIR)/$(POPPLER)/usr/bin/ && \
	for i in *; do\
		$(call install_copy, poppler, 0, 0, 0755, -, /usr/bin/$$i); \
	done
endif
ifdef PTXCONF_POPPLER_CPP
	@$(call install_lib, poppler, 0, 0, 0644, libpoppler-cpp)
endif
ifdef PTXCONF_POPPLER_GLIB
	@$(call install_lib, poppler, 0, 0, 0644, libpoppler-glib)
endif
ifdef PTXCONF_POPPLER_QT5
	@$(call install_lib, poppler, 0, 0, 0644, libpoppler-qt5)
endif
ifdef PTXCONF_POPPLER_INTROSPECTION
	@$(call install_copy, poppler, 0, 0, 0644, -, \
		/usr/share/gir-1.0/Poppler-0.18.gir)
	@$(call install_copy, poppler, 0, 0, 0644, -, \
		/usr/lib/girepository-1.0/Poppler-0.18.typelib)
endif
	@$(call install_finish, poppler)

	@$(call touch)

# vim: syntax=make
