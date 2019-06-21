# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Grzeschik <mgr@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_OPENOCD) += host-openocd

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_OPENOCD_CONF_TOOL	:= autoconf
HOST_OPENOCD_CONF_ENV	:= \
	CCACHE=none
HOST_OPENOCD_CONF_OPT	:= \
	$(HOST_AUTOCONF) \
	--enable-shared \
	--disable-static \
	--disable-werror \
	--disable-internal-jimtcl \
	--disable-internal-libjaylink \
	--enable-dummy \
	--enable-ftdi \
	--enable-stlink \
	--disable-ti-icdi \
	--disable-ulink \
	--disable-usb-blaster-2 \
	--disable-ft232r \
	--disable-vsllink \
	--disable-xds110 \
	--disable-osbdm \
	--disable-opendous \
	--disable-aice \
	--disable-usbprog \
	--disable-rlink \
	--disable-armjtagew \
	--disable-cmsis-dap \
	--disable-kitprog \
	--disable-usb_blaster \
	--disable-presto\
	--disable-openjtag \
	--disable-jlink \
	--disable-parport \
	--disable-parport-ppdev \
	--disable-parport-giveio \
	--disable-jtag_vpi \
	--disable-amtjtagaccel \
	--disable-zy1000 \
	--disable-zy1000-master \
	--disable-ioutil \
	--disable-ep93xx \
	--disable-at91rm9200 \
	--disable-bcm2835gpio \
	--disable-imx_gpio \
	--disable-gw16012 \
	--disable-oocd_trace \
	--disable-buspirate \
	--disable-sysfsgpio \
	--disable-minidriver-dummy \
	--disable-target-64 \
	--disable-remote-bitbang \
	--disable-doxygen-pdf \
	--disable-doxygen-html

# vim: syntax=make
