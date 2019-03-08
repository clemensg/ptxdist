# -*-makefile-*-
#
# Copyright (C) 2012 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_QT5) += qt5

#
# Paths and names
#
QT5_VERSION	:= 5.12.1
QT5_MD5		:= 6a37466c8c40e87d4a19c3f286ec2542
QT5		:= qt-everywhere-src-$(QT5_VERSION)
QT5_SUFFIX	:= tar.xz
QT5_URL		:= \
	http://download.qt-project.org/official_releases/qt/$(basename $(QT5_VERSION))/$(QT5_VERSION)/single/$(QT5).$(QT5_SUFFIX) \
	http://download.qt-project.org/development_releases/qt/$(basename $(QT5_VERSION))/$(shell echo $(QT5_VERSION) | tr 'A-Z' 'a-z')/single/$(QT5).$(QT5_SUFFIX)
QT5_SOURCE	:= $(SRCDIR)/$(QT5).$(QT5_SUFFIX)
QT5_DIR		:= $(BUILDDIR)/$(QT5)
QT5_BUILD_OOT	:= YES
QT5_LICENSE	:= (LGPL-3.0-only OR GPL-2.0-only) AND GFDL-1.3-only
QT5_LICENSE_FILES := \
	file://LICENSE.GPLv2;md5=c96076271561b0e3785dad260634eaa8 \
	file://LICENSE.GPLv3;md5=88e2b9117e6be406b5ed6ee4ca99a705 \
	file://LICENSE.LGPLv3;md5=e0459b45c5c4840b353141a8bbed91f0 \
	file://LICENSE.FDL;md5=6d9f2a9af4c8b8c3c769f6cc1b6aaf7e
QT5_MKSPECS	:= $(call ptx/get-alternative, config/qt5, linux-ptx-g++)

ifdef PTXCONF_QT5
ifeq ($(strip $(QT5_MKSPECS)),)
$(error Qt5 mkspecs are missing)
endif
endif

# broken on PPC
ifdef PTXCONF_ARCH_PPC
PTXCONF_QT5_MODULE_QTCONNECTIVITY :=
PTXCONF_QT5_MODULE_QTCONNECTIVITY_QUICK :=
PTXCONF_QT5_MODULE_QTSCRIPT :=
PTXCONF_QT5_MODULE_QTSCRIPT_WIDGETS :=
PTXCONF_QT5_MODULE_QTWEBENGINE :=
PTXCONF_QT5_MODULE_QTWEBENGINE_WIDGETS :=
PTXCONF_QT5_MODULE_QTWEBVIEW :=
endif
# QtWebEngine needs at least ARMv6
ifdef PTXCONF_ARCH_ARM
ifndef PTXCONF_ARCH_ARM_V6
PTXCONF_QT5_MODULE_QTWEBENGINE :=
PTXCONF_QT5_MODULE_QTWEBENGINE_WIDGETS :=
PTXCONF_QT5_MODULE_QTWEBVIEW :=
endif
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

# the extra section seems to confuse the Webkit JIT code
QT5_WRAPPER_BLACKLIST := \
	TARGET_COMPILER_RECORD_SWITCHES

# PKG_CONFIG_LIBDIR and PKG_CONFIG_SYSROOT_DIR must be set. Otherwise Qt
# disables pkg-config while cross-compiling
# use "/." for PKG_CONFIG_SYSROOT_DIR. Otherwise the resulting "//..."
# paths are treated as relative to the source dir by chromium
QT5_PKG_CONFIG_ENV := \
	$(CROSS_ENV_PKG_CONFIG) \
	PKG_CONFIG_LIBDIR=/empty \
	PKG_CONFIG_SYSROOT_DIR=/. \

# target options are provided via mkspecs
QT5_CONF_ENV := \
	$(QT5_PKG_CONFIG_ENV) \
	MAKEFLAGS="$(PARALLELMFLAGS)" \
	COMPILER_PREFIX=$(COMPILER_PREFIX)

ifdef PTXCONF_QT5_MODULE_QTWEBENGINE
QT5_CONF_ENV += PTX_QMAKE_CFLAGS="$(filter -m%,$(shell ptxd_cross_cc_v | sed -n -e "s/'//g" -e "/^COLLECT_GCC_OPTIONS=/{s/[^=]*=\(.*\)/\1/p;q}"))"
endif

define ptx/qt5-system
$(call ptx/ifdef, PTXCONF_$(strip $(1)),-system,-no)
endef

define ptx/qt5-module
$(call ptx/ifdef, PTXCONF_QT5_MODULE_$(strip $(1)),,-skip $(2))
endef

#
# autoconf
#
QT5_CONF_TOOL	:= autoconf

#
# Note: autoconf style options are not shown in '--help' but they can be used
# This also avoid the problem where e.g. '-largefile' also matches '-l<library>'
#
QT5_CONF_OPT	:= \
	-prefix /usr \
	-headerdir /usr/include/qt5 \
	-archdatadir /usr/lib/qt5 \
	-datadir /usr/share/qt5 \
	-examplesdir /usr/lib/qt5/examples \
	-hostbindir /usr/bin/qt5 \
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
	-xplatform linux-ptx-g++ \
	--disable-trace \
	--disable-rpath \
	-reduce-exports \
	--disable-pch \
	--disable-ltcg \
	$(if $(filter 0,$(PTXDIST_VERBOSE)),-silent) \
	\
	-pkg-config \
	\
	$(call ptx/qt5-module, QT3D, qt3d) \
	-skip qtactiveqt \
	-skip qtandroidextras \
	$(call ptx/qt5-module, QTCANVAS3D, qtcanvas3d) \
	$(call ptx/qt5-module, QTCHARTS, qtcharts) \
	$(call ptx/qt5-module, QTCONNECTIVITY, qtconnectivity) \
	$(call ptx/qt5-module, QTDATAVIS3D, qtdatavis3d) \
	$(call ptx/qt5-module, QTDECLARATIVE, qtdeclarative) \
	-skip qtdoc \
	$(call ptx/qt5-module, QTGAMEPAD, qtgamepad) \
	$(call ptx/qt5-module, QTGRAPHICALEFFECTS, qtgraphicaleffects) \
	$(call ptx/qt5-module, QTIMAGEFORMATS, qtimageformats) \
	$(call ptx/qt5-module, QTLOCATION, qtlocation) \
	-skip qtmacextras \
	$(call ptx/qt5-module, QTMULTIMEDIA, qtmultimedia) \
	$(call ptx/qt5-module, QTNETWORKAUTH, qtnetworkauth) \
	$(call ptx/qt5-module, QTPURCHASING, qtpurchasing) \
	$(call ptx/qt5-module, QTQUICKCONTROLS, qtquickcontrols) \
	$(call ptx/qt5-module, QTQUICKCONTROLS2, qtquickcontrols2) \
	$(call ptx/qt5-module, QTREMOTEOBJECTS, qtremoteobjects) \
	$(call ptx/qt5-module, QTSCRIPT, qtscript) \
	$(call ptx/qt5-module, QTSCXML, qtscxml) \
	$(call ptx/qt5-module, QTSENSORS, qtsensors) \
	$(call ptx/qt5-module, QTSERIALBUS, qtserialbus) \
	$(call ptx/qt5-module, QTSERIALPORT, qtserialport) \
	$(call ptx/qt5-module, QTSPEECH, qtspeech) \
	$(call ptx/qt5-module, QTSVG, qtsvg) \
	$(call ptx/qt5-module, QTTOOLS, qttools) \
	$(call ptx/qt5-module, QTTRANSLATIONS, qttranslations) \
	$(call ptx/qt5-module, QTVIRTUALKEYBOARD, qtvirtualkeyboard) \
	$(call ptx/qt5-module, QTWAYLAND, qtwayland) \
	$(call ptx/qt5-module, QTWEBCHANNEL, qtwebchannel) \
	$(call ptx/qt5-module, QTWEBENGINE, qtwebengine) \
	$(call ptx/qt5-module, QTWEBGLPLUGIN, qtwebglplugin) \
	$(call ptx/qt5-module, QTWEBSOCKETS, qtwebsockets) \
	$(call ptx/qt5-module, QTWEBVIEW, qtwebview) \
	-skip qtwinextras \
	$(call ptx/qt5-module, QTX11EXTRAS, qtx11extras) \
	$(call ptx/qt5-module, QTXMLPATTERNS, qtxmlpatterns) \
	-make libs \
	-make tools \
	$(call ptx/ifdef, PTXCONF_QT5_PREPARE_EXAMPLES,-make examples) \
	--$(call ptx/endis, PTXCONF_QT5_PREPARE_EXAMPLES)-compile-examples \
	--$(call ptx/endis, PTXCONF_QT5_GUI)-gui \
	--$(call ptx/endis, PTXCONF_QT5_WIDGETS)-widgets \
	-$(call ptx/ifdef, PTXCONF_QT5_DBUS,dbus-linked,no-dbus) \
	--$(call ptx/endis, PTXCONF_QT5_ACCESSIBILITY)-accessibility \
	\
	--$(call ptx/endis, PTXCONF_QT5_GLIB)-glib \
	--$(call ptx/endis, $(call ptx/ifdef, PTXCONF_QT5_ICU,,PTXCONF_ICONV))-iconv \
	--$(call ptx/endis, PTXCONF_QT5_ICU)-icu \
	-qt-pcre \
	-system-zlib \
	--$(call ptx/endis, PTXCONF_QT5_JOURNALD)-journald \
	--disable-syslog \
	\
	--$(call ptx/endis, PTXCONF_QT5_OPENSSL)-ssl \
	--$(call ptx/endis, PTXCONF_QT5_OPENSSL)-openssl \
	--disable-sctp \
	--disable-libproxy \
	--disable-system-proxies \
	\
	--disable-cups \
	--$(call ptx/endis, PTXCONF_QT5_GUI)-fontconfig \
	$(call ptx/qt5-system, QT5_GUI)-freetype \
	-qt-harfbuzz \
	--disable-gtk \
	-$(call ptx/ifdef, PTXCONF_QT5_OPENGL,opengl $(PTXCONF_QT5_OPENGL_API),no-opengl) \
	$(call ptx/ifdef, PTXCONF_QT5_GUI,-qpa $(PTXCONF_QT5_PLATFORM_DEFAULT)) \
	--$(call ptx/endis, PTXCONF_QT5_X11)-xcb-xlib \
	\
	--disable-directfb \
	--$(call ptx/endis, PTXCONF_QT5_PLATFORM_EGLFS)-eglfs \
	--$(call ptx/endis, PTXCONF_QT5_PLATFORM_EGLFS_KMS)-gbm \
	--$(call ptx/endis, PTXCONF_QT5_PLATFORM_BACKEND_KMS)-kms \
	--$(call ptx/endis, PTXCONF_QT5_PLATFORM_LINUXFB)-linuxfb \
	--disable-mirclient \
	$(call ptx/qt5-system, QT5_PLATFORM_XCB)-xcb \
	\
	--$(call ptx/endis, PTXCONF_QT5_LIBUDEV)-libudev \
	--$(call ptx/endis, PTXCONF_QT5_INPUT_EVDEV)-evdev \
	--$(call ptx/endis, PTXCONF_QT5_INPUT_LIBINPUT)-libinput \
	--disable-mtdev \
	--$(call ptx/endis, PTXCONF_QT5_INPUT_TSLIB)-tslib \
	--$(call ptx/endis, PTXCONF_QT5_XI)-xcb-xinput \
	--$(call ptx/endis, PTXCONF_QT5_LIBXKBCOMMON)-xkbcommon \
	\
	--$(call ptx/endis, PTXCONF_QT5_GIF)-gif \
	$(call ptx/qt5-system, QT5_LIBPNG)-libpng \
	$(call ptx/qt5-system, QT5_LIBJPEG)-libjpeg \
	\
	--disable-sql-db2 \
	--disable-sql-ibase \
	--$(call ptx/endis, PTXCONF_QT5_MODULE_QTBASE_SQL_MYSQL)-sql-mysql \
	--disable-sql-oci \
	--disable-sql-odbc \
	--disable-sql-psql \
	--disable-sql-sqlite2 \
	--disable-sql-tds \
	--$(call ptx/endis, PTXCONF_QT5_MODULE_QTBASE_SQL_SQLITE)-sql-sqlite \
	$(call ptx/qt5-system, PTXCONF_QT5_MODULE_QTBASE_SQL_SQLITE)-sqlite

ifdef PTXCONF_QT5_MODULE_QTMULTIMEDIA
QT5_CONF_OPT	+= \
	--disable-pulseaudio \
	--$(call ptx/endis, PTXCONF_QT5_MODULE_QTMULTIMEDIA)-alsa \
	$(call ptx/ifdef, PTXCONF_QT5_MODULE_QTMULTIMEDIA_GST,-gstreamer 1.0,-no-gstreamer)
endif
ifdef PTXCONF_QT5_MODULE_QTWEBENGINE
QT5_CONF_OPT	+= \
	--$(call ptx/endis, PTXCONF_QT5_MODULE_QTWEBENGINE)-alsa \
	--disable-webengine-pulseaudio \
	-qt-webengine-icu \
	-qt-webengine-ffmpeg \
	-system-webengine-opus \
	-qt-webengine-webp \
	--disable-webengine-pepper-plugins \
	--disable-webengine-printing-and-pdf \
	--disable-webengine-proprietary-codecs \
	--disable-webengine-spellchecker \
	--disable-webengine-webrtc
endif

ifdef PTXCONF_QT5_GUI
ifndef PTXCONF_QT5_PLATFORM_DEFAULT
$(error Qt5: select at least one GUI platform!)
endif
endif

# Note: these options are not listed in '--help' but they exist
QT5_CONF_OPT += \
	--disable-sm \
	--$(call ptx/endis, PTXCONF_QT5_OPENGL)-egl

ifdef PTXCONF_QT5_MODULE_QTDECLARATIVE
QT5_CONF_OPT += \
	--$(call ptx/endis, PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)-qml-debug
endif

ifdef PTXCONF_QT5_MODULE_QTBASE_SQL_MYSQL
QT5_CONF_OPT += -mysql_config $(SYSROOT)/usr/bin/mysql_config
endif

# change default C++ standard
# the detected standard is not used for configure and examples
QT5_CXXFLAGS := -std=c++11

$(STATEDIR)/qt5.prepare:
	@$(call targetinfo)
	@rm -rf "$(QT5_DIR)/qtbase/mkspecs/linux-ptx-g++"
	@mkdir "$(QT5_DIR)/qtbase/mkspecs/linux-ptx-g++"
	@$(foreach file, $(wildcard $(QT5_MKSPECS)/*), \
		$(QT5_CONF_ENV) ptxd_replace_magic "$(file)" > \
		"$(QT5_DIR)/qtbase/mkspecs/linux-ptx-g++/$(notdir $(file))"$(ptx/nl))

	@+$(call world/prepare, QT5)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

QT5_MAKE_ENV := \
	$(QT5_PKG_CONFIG_ENV) \
	ICECC_REMOTE_CPP=0

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/qt5.install:
	@$(call targetinfo)
	@$(call world/install, QT5)
	@find $(QT5_PKGDIR) -name '*.qmltypes' | xargs -r rm
	@$(call touch)

QT5_QT_CONF := $(PTXDIST_SYSROOT_CROSS)/bin/qt5/qt.conf

$(STATEDIR)/qt5.install.post:
	@$(call targetinfo)
	@$(call world/install.post, QT5)
	@rm -rf $(PTXDIST_SYSROOT_CROSS)/bin/qt5
	@cp -a $(SYSROOT)/usr/bin/qt5 $(PTXDIST_SYSROOT_CROSS)/bin/qt5
	@echo "[Paths]"						>  $(QT5_QT_CONF)
	@echo "HostPrefix=$(SYSROOT)/usr"			>> $(QT5_QT_CONF)
	@echo "HostData=$(SYSROOT)/usr/lib/qt5"			>> $(QT5_QT_CONF)
	@echo "HostBinaries=$(PTXDIST_SYSROOT_CROSS)/bin/qt5"	>> $(QT5_QT_CONF)
	@echo "Prefix=$(SYSROOT)/usr"				>> $(QT5_QT_CONF)
	@echo "Headers=$(SYSROOT)/usr/include/qt5"		>> $(QT5_QT_CONF)
	@echo "Imports=/usr/lib/qt5/imports"			>> $(QT5_QT_CONF)
	@echo "Qml2Imports=/usr/lib/qt5/qml"			>> $(QT5_QT_CONF)
	@echo ""						>> $(QT5_QT_CONF)
	@$(call touch)


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

QT5_LIBS-y							:=
QT5_QML-y							:=

### Qt3d ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QT3D)				+= Qt53DAnimation Qt53DCore Qt53DExtras Qt53DInput Qt53DLogic Qt53DRender
QT5_LIBS-$(PTXCONF_QT5_MODULE_QT3D_QUICK)			+= Qt53DQuick Qt53DQuickAnimation Qt53DQuickExtras Qt53DQuickInput Qt53DQuickRender Qt53DQuickScene2D
QT5_QML-$(PTXCONF_QT5_MODULE_QT3D_QUICK)			+= Qt3D
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QT3D)				+= geometryloaders/libdefaultgeometryloader
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QT3D)				+= geometryloaders/libgltfgeometryloader
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QT3D)				+= sceneparsers/libgltfsceneexport
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QT3D)				+= sceneparsers/libgltfsceneimport
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QT3D_QUICK)			+= renderplugins/libscene2d

### QtBase ###
QT5_LIBS-y							+= Qt5Core
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTBASE)				+= Qt5Concurrent
QT5_LIBS-$(PTXCONF_QT5_DBUS)					+= Qt5DBus
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTBASE_GUI)			+= Qt5Gui
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTBASE)				+= Qt5Network
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTBASE_OPENGL)			+= Qt5OpenGL
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTBASE_PRINT)			+= Qt5PrintSupport
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTBASE_SQL)			+= Qt5Sql
ifdef PTXCONF_QT5_TEST
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTBASE_WIDGETS)			+= Qt5Test
endif
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTBASE_WIDGETS)			+= Qt5Widgets
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTBASE)				+= Qt5Xml
QT5_LIBS-$(PTXCONF_QT5_PLATFORM_EGLFS)				+= Qt5EglFSDeviceIntegration
QT5_LIBS-$(PTXCONF_QT5_PLATFORM_EGLFS_KMS)			+= Qt5EglFsKmsSupport
QT5_LIBS-$(PTXCONF_QT5_PLATFORM_XCB)				+= Qt5XcbQpa
QT5_PLUGINS-$(PTXCONF_QT5_DBUS)					+= bearer/libqconnmanbearer
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTBASE)			+= bearer/libqgenericbearer
QT5_PLUGINS-$(PTXCONF_QT5_DBUS)					+= bearer/libqnmbearer
QT5_PLUGINS-$(PTXCONF_QT5_INPUT_EVDEV)				+= generic/libqevdevkeyboardplugin
QT5_PLUGINS-$(PTXCONF_QT5_INPUT_EVDEV)				+= generic/libqevdevmouseplugin
QT5_PLUGINS-$(PTXCONF_QT5_INPUT_EVDEV)				+= generic/libqevdevtabletplugin
QT5_PLUGINS-$(PTXCONF_QT5_INPUT_EVDEV)				+= generic/libqevdevtouchplugin
QT5_PLUGINS-$(PTXCONF_QT5_INPUT_LIBINPUT)			+= generic/libqlibinputplugin
QT5_PLUGINS-$(PTXCONF_QT5_INPUT_TSLIB)				+= generic/libqtslibplugin
QT5_PLUGINS-$(PTXCONF_QT5_GIF)					+= imageformats/libqgif
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTBASE_GUI)			+= imageformats/libqico
QT5_PLUGINS-$(PTXCONF_QT5_LIBJPEG)				+= imageformats/libqjpeg
QT5_PLUGINS-$(PTXCONF_QT5_PLATFORM_XCB)				+= platforminputcontexts/libcomposeplatforminputcontextplugin
ifdef PTXCONF_QT5_MODULE_QTBASE_GUI
QT5_PLUGINS-$(PTXCONF_QT5_DBUS)					+= platforminputcontexts/libibusplatforminputcontextplugin
endif
QT5_PLUGINS-$(PTXCONF_QT5_PLATFORM_EGLFS)			+= platforms/libqeglfs
QT5_PLUGINS-$(PTXCONF_QT5_PLATFORM_LINUXFB)			+= platforms/libqlinuxfb
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTBASE_GUI)			+= platforms/libqminimal
QT5_PLUGINS-$(PTXCONF_QT5_PLATFORM_EGLFS)			+= platforms/libqminimalegl
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTBASE_GUI)			+= platforms/libqoffscreen
QT5_PLUGINS-$(PTXCONF_QT5_PLATFORM_VNC)				+= platforms/libqvnc
QT5_PLUGINS-$(PTXCONF_QT5_PLATFORM_XCB)				+= platforms/libqxcb
QT5_PLUGINS-$(PTXCONF_QT5_PLATFORM_EGLFS_KMS)			+= egldeviceintegrations/libqeglfs-kms-integration
QT5_PLUGINS-$(PTXCONF_QT5_PLATFORM_EGLFS_X11)			+= egldeviceintegrations/libqeglfs-x11-integration
QT5_PLUGINS-$(PTXCONF_QT5_PLATFORM_XCB)				+= xcbglintegrations/libqxcb-egl-integration
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTBASE_SQL_MYSQL)		+= sqldrivers/libqsqlmysql
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTBASE_SQL_SQLITE)		+= sqldrivers/libqsqlite

### QtCanvas3d ###
QT5_QML-$(PTXCONF_QT5_MODULE_QTCANVAS3D_QUICK)			+= QtCanvas3D

### QtCharts ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTCHARTS)				+= Qt5Charts
QT5_QML-$(PTXCONF_QT5_MODULE_QTCHARTS_QUICK)			+= QtCharts

### QtConnectivity ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTCONNECTIVITY)			+= Qt5Bluetooth
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTCONNECTIVITY)			+= Qt5Nfc
QT5_QML-$(PTXCONF_QT5_MODULE_QTCONNECTIVITY_QUICK)		+= QtBluetooth
QT5_QML-$(PTXCONF_QT5_MODULE_QTCONNECTIVITY_QUICK)		+= QtNfc

### QtDataVisualization ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTDATAVIS3D)			+= Qt5DataVisualization
QT5_QML-$(PTXCONF_QT5_MODULE_QTDATAVIS3D_QUICK)			+= QtDataVisualization

### QtDeclarative ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE)			+= Qt5Qml
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_QUICK)		+= Qt5Quick
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_QUICK)		+= Qt5QuickShapes
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_QUICK_WIDGETS)	+= Qt5QuickWidgets
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_QUICK)		+= Qt5QuickParticles
ifdef PTXCONF_QT5_TEST
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_QUICK)		+= Qt5QuickTest
endif
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)		+= qmltooling/libqmldbg_debugger
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)		+= qmltooling/libqmldbg_local
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)		+= qmltooling/libqmldbg_messages
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)		+= qmltooling/libqmldbg_native
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)		+= qmltooling/libqmldbg_nativedebugger
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)		+= qmltooling/libqmldbg_preview
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)		+= qmltooling/libqmldbg_profiler
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_QUICK_DEBUG)	+= qmltooling/libqmldbg_quickprofiler
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)		+= qmltooling/libqmldbg_server
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_DEBUG)		+= qmltooling/libqmldbg_tcp
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_QUICK_DEBUG)	+= qmltooling/libqmldbg_inspector
QT5_QML-$(PTXCONF_QT5_MODULE_QTDECLARATIVE)			+= Qt
QT5_QML-$(PTXCONF_QT5_MODULE_QTDECLARATIVE)			+= QtQuick
QT5_QML-$(PTXCONF_QT5_MODULE_QTDECLARATIVE)			+= QtQuick.2
QT5_QML-$(PTXCONF_QT5_MODULE_QTDECLARATIVE)			+= QtQml
ifdef PTXCONF_QT5_TEST
QT5_QML-$(PTXCONF_QT5_MODULE_QTDECLARATIVE_QUICK)		+= QtTest
endif

### QtGamepad ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTGAMEPAD)			+= Qt5Gamepad
QT5_QML-$(PTXCONF_QT5_MODULE_QTGAMEPAD)				+= QtGamepad
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTGAMEPAD)			+= gamepads/libevdevgamepad

### QtGraphicalEffects ###
QT5_QML-$(PTXCONF_QT5_MODULE_QTGRAPHICALEFFECTS)		+= QtGraphicalEffects

### QtImageFormats ###
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTIMAGEFORMATS)		+= imageformats/libqicns
QT5_PLUGINS-$(PTXCONF_QT5_LIBMNG)				+= imageformats/libqmng
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTIMAGEFORMATS)		+= imageformats/libqtga
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTIMAGEFORMATS)		+= imageformats/libqtiff
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTIMAGEFORMATS)		+= imageformats/libqwbmp
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTIMAGEFORMATS)		+= imageformats/libqwebp


### QtLocation ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTLOCATION)			+= Qt5Positioning
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTLOCATION_QUICK)			+= Qt5Location
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTLOCATION_QUICK)			+= Qt5PositioningQuick
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTLOCATION)			+= position/libqtposition_positionpoll
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTLOCATION_QUICK)		+= geoservices/libqtgeoservices_osm
QT5_QML-$(PTXCONF_QT5_MODULE_QTLOCATION_QUICK)			+= QtLocation
QT5_QML-$(PTXCONF_QT5_MODULE_QTLOCATION_QUICK)			+= QtPositioning

### QtMultimedia ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA)			+= Qt5Multimedia
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA_QUICK)		+= Qt5MultimediaQuick
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA_WIDGETS)		+= Qt5MultimediaWidgets
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA_GST)			+= Qt5MultimediaGstTools
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA_GST)		+= audio/libqtaudio_alsa
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA_GST)		+= mediaservice/libgstaudiodecoder

#libgstcamerabin pulls in a dependency to gst-plugins-bad1 that we can't properly describe in the rules
#QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA_GST)		+= mediaservice/libgstcamerabin

QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA_GST)		+= mediaservice/libgstmediacapture
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA_GST)		+= mediaservice/libgstmediaplayer
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA)			+= playlistformats/libqtmultimedia_m3u
ifdef PTXCONF_QT5_OPENGL_ES2
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA)			+= video/videonode/libeglvideonode
endif
QT5_QML-$(PTXCONF_QT5_MODULE_QTMULTIMEDIA_QUICK)		+= QtMultimedia

### QtNetworkAuth ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTNETWORKAUTH)			+= Qt5NetworkAuth

### QtPurchasing ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTPURCHASING)			+= Qt5Purchasing
QT5_QML-$(PTXCONF_QT5_MODULE_QTPURCHASING)			+= QtPurchasing

### QtQuickControls ###
# all in QT5_QML- added by QtDeclarative

### QtQuickControls2 ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTQUICKCONTROLS2)			+= Qt5QuickTemplates2
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTQUICKCONTROLS2)			+= Qt5QuickControls2

### QtRemoteObjects ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTREMOTEOBJECTS)			+= Qt5RemoteObjects
QT5_QML-$(PTXCONF_QT5_MODULE_QTREMOTEOBJECTS_QUICK)		+= QtRemoteObjects

### QtScript ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTSCRIPT)				+= Qt5Script
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTSCRIPT_WIDGETS)			+= Qt5ScriptTools

### QtScxml ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTSCXML)				+= Qt5Scxml
QT5_QML-$(PTXCONF_QT5_MODULE_QTSCXML_QUICK)			+= QtScxml

### QtSensors ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTSENSORS)			+= Qt5Sensors
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTSENSORS)			+= sensorgestures/libqtsensorgestures_plugin
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTSENSORS)			+= sensorgestures/libqtsensorgestures_shakeplugin
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTSENSORS)			+= sensors/libqtsensors_generic
ifdef PTXCONF_QT5_DBUS
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTSENSORS)			+= sensors/libqtsensors_iio-sensor-proxy
endif
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTSENSORS)			+= sensors/libqtsensors_linuxsys
QT5_QML-$(PTXCONF_QT5_MODULE_QTSENSORS_QUICK)			+= QtSensors

### QtSerialBus ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTSERIALBUS)			+= Qt5SerialBus
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTSERIALBUS)			+= canbus/libqtsocketcanbus

### QtSerialPort ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTSERIALPORT)			+= Qt5SerialPort

### QtSpeech ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTSPEECH)				+= Qt5TextToSpeech

### QtSvg ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTSVG)				+= Qt5Svg
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTSVG_WIDGETS)			+= iconengines/libqsvgicon
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTSVG)				+= imageformats/libqsvg

### QtTools ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTTOOLS_WIDGETS)			+= Qt5Designer
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTTOOLS_WIDGETS)			+= Qt5DesignerComponents
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTTOOLS_WIDGETS)			+= Qt5Help

### QtVirtualKeyboard ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTVIRTUALKEYBOARD)		+= Qt5VirtualKeyboard
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTVIRTUALKEYBOARD)		+= platforminputcontexts/libqtvirtualkeyboardplugin

### QtWayland ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTWAYLAND)			+= Qt5WaylandClient
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTWAYLAND)			+= Qt5WaylandCompositor
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND)			+= platforms/libqwayland-generic
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND_MESA)		+= platforms/libqwayland-egl
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND_MESA)		+= wayland-graphics-integration-client/libqt-plugin-wayland-egl
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND_MESA)		+= wayland-graphics-integration-client/libdmabuf-server
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND_MESA)		+= wayland-graphics-integration-client/libdrm-egl-server
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND_MESA)		+= wayland-graphics-integration-server/libqt-plugin-wayland-egl
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND_MESA)		+= wayland-graphics-integration-server/libdmabuf-server
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND_MESA)		+= wayland-graphics-integration-server/libdrm-egl-server
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND)			+= wayland-shell-integration/libivi-shell
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND)			+= wayland-shell-integration/libwl-shell
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND)			+= wayland-shell-integration/libxdg-shell-v5
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND)			+= wayland-shell-integration/libxdg-shell-v6
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND)			+= wayland-shell-integration/libxdg-shell
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWAYLAND)			+= wayland-decoration-client/libbradient

QT5_QML-$(PTXCONF_QT5_MODULE_QTWAYLAND_QUICK)			+= QtWayland

### QtWebChannel ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTWEBCHANNEL)			+= Qt5WebChannel
QT5_QML-$(PTXCONF_QT5_MODULE_QTWEBCHANNEL_QUICK)		+= QtWebChannel

### QtWebEngine ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTWEBENGINE)			+= Qt5WebEngine
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTWEBENGINE)			+= Qt5WebEngineCore
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTWEBENGINE_WIDGETS)		+= Qt5WebEngineWidgets
QT5_QML-$(PTXCONF_QT5_MODULE_QTWEBENGINE)			+= QtWebEngine

### QtWebGLPlugin ###
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWEBGLPLUGIN)			+= platforms/libqwebgl

### QtWebSockets ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTWEBSOCKETS)			+= Qt5WebSockets
QT5_QML-$(PTXCONF_QT5_MODULE_QTWEBSOCKETS_QUICK)		+= QtWebSockets

### QtWebView ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTWEBVIEW)			+= Qt5WebView
QT5_QML-$(PTXCONF_QT5_MODULE_QTWEBVIEW)				+= QtWebView
QT5_PLUGINS-$(PTXCONF_QT5_MODULE_QTWEBVIEW)			+= webview/libqtwebview_webengine

### QtX11Extras ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTX11EXTRAS)			+= Qt5X11Extras

### QtXmlPatterns ###
QT5_LIBS-$(PTXCONF_QT5_MODULE_QTXMLPATTERNS)			+= Qt5XmlPatterns



$(STATEDIR)/qt5.targetinstall:
	@$(call targetinfo)

	@$(call install_init, qt5)
	@$(call install_fixup, qt5,PRIORITY,optional)
	@$(call install_fixup, qt5,SECTION,base)
	@$(call install_fixup, qt5,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, qt5,DESCRIPTION,missing)

	@$(foreach lib, $(QT5_LIBS-y), \
		$(call install_lib, qt5, 0, 0, 0644, lib$(lib))$(ptx/nl))

ifdef PTXCONF_QT5_MODULE_QTWEBENGINE
	@$(call install_copy, qt5, 0, 0, 0755, -, \
		/usr/lib/qt5/libexec/QtWebEngineProcess)
	@$(call install_copy, qt5, 0, 0, 0644, -, \
		/usr/share/qt5/resources/icudtl.dat)
	@$(call install_copy, qt5, 0, 0, 0644, -, \
		/usr/share/qt5/resources/qtwebengine_devtools_resources.pak)
	@$(call install_copy, qt5, 0, 0, 0644, -, \
		/usr/share/qt5/resources/qtwebengine_resources.pak)
	@$(call install_copy, qt5, 0, 0, 0644, -, \
		/usr/share/qt5/resources/qtwebengine_resources_100p.pak)
	@$(call install_copy, qt5, 0, 0, 0644, -, \
		/usr/share/qt5/resources/qtwebengine_resources_200p.pak)
endif

	@$(foreach plugin, $(QT5_PLUGINS-y), \
		$(call install_copy, qt5, 0, 0, 0644, -, \
			/usr/lib/qt5/plugins/$(plugin).so)$(ptx/nl))

	@$(foreach import, $(QT5_IMPORTS-y), \
		$(call install_tree, qt5, 0, 0, -, \
		/usr/lib/qt5/imports/$(import))$(ptx/nl))

	@$(foreach qml, $(QT5_QML-y), \
		$(call install_tree, qt5, 0, 0, -, \
		/usr/lib/qt5/qml/$(qml))$(ptx/nl))

ifdef PTXCONF_QT5_MODULE_QTDECLARATIVE_QMLSCENE
	@$(call install_copy, qt5, 0, 0, 0755, -, /usr/bin/qmlscene)
endif

	@$(call install_finish, qt5)

	@$(call touch)

# vim: syntax=make
