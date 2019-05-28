# -*-makefile-*-
#
# Copyright (C) 2019 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PAHO_MQTT_CPP) += paho-mqtt-cpp

#
# Paths and names
#
PAHO_MQTT_CPP_VERSION	:= 1.0.1
PAHO_MQTT_CPP_MD5	:= 78c9c7c90d932926ab0d1181356e3ba8
PAHO_MQTT_CPP		:= paho.mqtt.cpp-$(PAHO_MQTT_CPP_VERSION)
PAHO_MQTT_CPP_SUFFIX	:= tar.gz
PAHO_MQTT_CPP_URL	:= https://github.com/eclipse/paho.mqtt.cpp/archive/v$(PAHO_MQTT_CPP_VERSION).$(PAHO_MQTT_CPP_SUFFIX)
PAHO_MQTT_CPP_SOURCE	:= $(SRCDIR)/$(PAHO_MQTT_CPP).$(PAHO_MQTT_CPP_SUFFIX)
PAHO_MQTT_CPP_DIR	:= $(BUILDDIR)/$(PAHO_MQTT_CPP)
# "Eclipse Distribution License - v 1.0" is in fact BSD-3-Clause
PAHO_MQTT_CPP_LICENSE	:= EPL-1.0 AND BSD-3-Clause
PAHO_MQTT_CPP_LICENSE_FILES := \
	file://about.html;md5=dcde438d73cf42393da9d40fabc0c9bc \
	file://epl-v10;md5=659c8e92a40b6df1d9e3dccf5ae45a08 \
	file://edl-v10;md5=3adfcc70f5aeb7a44f3f9b495aa1fbf3

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

PAHO_MQTT_CPP_CONF_TOOL	:= cmake

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/paho-mqtt-cpp.targetinstall:
	@$(call targetinfo)

	@$(call install_init, paho-mqtt-cpp)
	@$(call install_fixup, paho-mqtt-cpp,PRIORITY,optional)
	@$(call install_fixup, paho-mqtt-cpp,SECTION,base)
	@$(call install_fixup, paho-mqtt-cpp,AUTHOR,"Marc Kleine-Budde <mkl@pengutronix.de>")
	@$(call install_fixup, paho-mqtt-cpp,DESCRIPTION,missing)

	@$(call install_lib, paho-mqtt-cpp, 0, 0, 0644, libpaho-mqttpp3)

	@$(call install_finish, paho-mqtt-cpp)

	@$(call touch)

# vim: syntax=make
