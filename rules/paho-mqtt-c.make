# -*-makefile-*-
#
# Copyright (C) 2019 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PAHO_MQTT_C) += paho-mqtt-c

#
# Paths and names
#
PAHO_MQTT_C_VERSION	:= 1.3.0
PAHO_MQTT_C_MD5		:= 8fac1bff9b0d5a74fa1caf8db0501fca
PAHO_MQTT_C		:= paho.mqtt.c-$(PAHO_MQTT_C_VERSION)
PAHO_MQTT_C_SUFFIX	:= tar.gz
PAHO_MQTT_C_URL		:= https://github.com/eclipse/paho.mqtt.c/archive/v$(PAHO_MQTT_C_VERSION).$(PAHO_MQTT_C_SUFFIX)
PAHO_MQTT_C_SOURCE	:= $(SRCDIR)/$(PAHO_MQTT_C).$(PAHO_MQTT_C_SUFFIX)
PAHO_MQTT_C_DIR		:= $(BUILDDIR)/$(PAHO_MQTT_C)
# "Eclipse Distribution License - v 1.0" is in fact BSD-3-Clause
PAHO_MQTT_C_LICENSE	:= EPL-1.0 AND BSD-3-Clause
PAHO_MQTT_C_LICENSE_FILES := \
	file://LICENSE;md5=f2001efbb1450daa099206651f80d39c \
	file://epl-v10;md5=659c8e92a40b6df1d9e3dccf5ae45a08 \
	file://edl-v10;md5=3adfcc70f5aeb7a44f3f9b495aa1fbf3

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

PAHO_MQTT_C_CONF_TOOL	:= cmake
PAHO_MQTT_C_CONF_OPT	:= \
	$(CROSS_CMAKE_USR) \
	-DPAHO_WITH_SSL=TRUE \
	-DOPENSSL_SEARCH_PATH=$(PTXDIST_SYSROOT_TARGET)/usr

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/paho-mqtt-c.targetinstall:
	@$(call targetinfo)

	@$(call install_init, paho-mqtt-c)
	@$(call install_fixup, paho-mqtt-c,PRIORITY,optional)
	@$(call install_fixup, paho-mqtt-c,SECTION,base)
	@$(call install_fixup, paho-mqtt-c,AUTHOR,"Marc Kleine-Budde <mkl@pengutronix.de>")
	@$(call install_fixup, paho-mqtt-c,DESCRIPTION,missing)

	@$(call install_lib, paho-mqtt-c, 0, 0, 0644, libpaho-mqtt3as)

	@$(call install_finish, paho-mqtt-c)

	@$(call touch)

# vim: syntax=make
