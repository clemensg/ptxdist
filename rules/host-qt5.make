# -*-makefile-*-
#
# Copyright (C) 2017 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_QT5) += host-qt5

HOST_QT5_BUILD_OOT	:= YES

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

# to build qmake in parallel
HOST_QT5_CONF_ENV := \
	$(HOST_ENV) \
	MAKEFLAGS="$(PARALLELMFLAGS)"

#
# autoconf
#
HOST_QT5_CONF_TOOL	:= autoconf
HOST_QT5_CONF_OPT	:= \
	-prefix / \
	-bindir /bin/qt5 \
	-headerdir /include/qt5 \
	-archdatadir /lib/qt5 \
	-datadir /share/qt5 \
	-hostbindir /bin/qt5 \
	$(if $(filter 1,$(PTXDIST_VERBOSE)),-v) \
	-opensource \
	-confirm-license \
	-release \
	--disable-optimized-tools \
	--disable-separate-debug-info \
	--disable-gdb-index \
	--disable-strip \
	--disable-gc-binaries \
	--enable-shared \
	--disable-trace \
	--disable-rpath \
	--disable-pch \
	--disable-ltcg \
	$(if $(filter 0,$(PTXDIST_VERBOSE)),-silent) \
	\
	-pkg-config \
	\
	-skip qt3d \
	-skip qtactiveqt \
	-skip qtandroidextras \
	-skip qtcanvas3d \
	-skip qtcharts \
	-skip qtconnectivity \
	-skip qtdatavis3d \
	-skip qtdeclarative \
	-skip qtdoc \
	-skip qtgamepad \
	-skip qtgraphicaleffects \
	-skip qtimageformats \
	-skip qtlocation \
	-skip qtmacextras \
	-skip qtmultimedia \
	-skip qtnetworkauth \
	-skip qtpurchasing \
	-skip qtquickcontrols \
	-skip qtquickcontrols2 \
	-skip qtremoteobjects \
	-skip qtscript \
	-skip qtscxml \
	-skip qtsensors \
	-skip qtserialbus \
	-skip qtserialport \
	-skip qtspeech \
	-skip qtsvg \
	-skip qttools \
	-skip qttranslations \
	-skip qtvirtualkeyboard \
	-skip qtwayland \
	-skip qtwebchannel \
	-skip qtwebengine \
	-skip qtwebglplugin \
	-skip qtwebsockets \
	-skip qtwebview \
	-skip qtwinextras \
	-skip qtx11extras \
	-skip qtxmlpatterns \
	-make libs \
	-make tools \
	--disable-compile-examples \
	--disable-gui \
	--disable-widgets \
	--disable-dbus \
	--disable-accessibility \
	\
	--disable-glib \
	--disable-iconv \
	--disable-icu \
	-qt-pcre \
	-system-zlib \
	--disable-journald \
	--disable-syslog \
	\
	--disable-ssl \
	--disable-openssl \
	--disable-sctp \
	--disable-libproxy \
	--disable-system-proxies \
	\
	--disable-cups \
	--disable-fontconfig \
	--disable-freetype \
	-qt-harfbuzz \
	--disable-gtk \
	--opengl=no \
	--disable-xcb-xlib \
	\
	--disable-directfb \
	--disable-eglfs \
	--disable-gbm \
	--disable-kms \
	--disable-linuxfb \
	--disable-mirclient \
	--disable-xcb \
	\
	--disable-libudev \
	--disable-evdev \
	--disable-libinput \
	--disable-mtdev \
	--disable-tslib \
	--disable-xcb-xinput \
	--disable-xkbcommon \
	\
	-no-gif \
	-no-libpng \
	-no-libjpeg \
	\
	--disable-sql-db2 \
	--disable-sql-ibase \
	--disable-sql-mysql \
	--disable-sql-oci \
	--disable-sql-odbc \
	--disable-sql-psql \
	--disable-sql-sqlite2 \
	--disable-sql-tds \
	--disable-sql-sqlite \
	--disable-sqlite

# Note: these options are not listed in '--help' but they exist
HOST_QT5_CONF_OPT += \
	--disable-sm \
	--disable-egl

HOST_QT5_QT_CONF := $(PTXDIST_SYSROOT_HOST)/bin/qt5/qt.conf

HOST_QT5_MAKE_ENV := \
	ICECC_REMOTE_CPP=0

$(STATEDIR)/host-qt5.install.post:
	@$(call targetinfo)
	@$(call world/install.post, HOST_QT5)
	@echo "[Paths]"						>  $(HOST_QT5_QT_CONF)
	@echo "HostPrefix=$(PTXDIST_SYSROOT_HOST)"		>> $(HOST_QT5_QT_CONF)
	@echo "HostData=$(PTXDIST_SYSROOT_HOST)/lib/qt5"	>> $(HOST_QT5_QT_CONF)
	@echo "HostBinaries=$(PTXDIST_SYSROOT_HOST)/bin/qt5"	>> $(HOST_QT5_QT_CONF)
	@echo "Prefix=$(PTXDIST_SYSROOT_HOST)"			>> $(HOST_QT5_QT_CONF)
	@echo "Headers=$(PTXDIST_SYSROOT_HOST)/include/qt5"	>> $(HOST_QT5_QT_CONF)
	@echo "Data=$(PTXDIST_SYSROOT_HOST)/share/qt5"		>> $(HOST_QT5_QT_CONF)
	@echo "Binaries=$(PTXDIST_SYSROOT_HOST)/bin/qt5"	>> $(HOST_QT5_QT_CONF)
	@echo ""						>> $(HOST_QT5_QT_CONF)
	@$(call touch)

# vim: syntax=make
