# -*-makefile-*-
# $Id: i386-ratio-uno-2053-1.make,v 1.1 2004/04/02 13:28:22 bbu Exp $
#
# Copyright (C) 2003 by Auerswald GmbH & Co. KG <linux-development@auerswald.de>
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

VENDORTWEAKS = ratio-uno-2053-1

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

ratio-uno-2053-1_targetinstall: $(STATEDIR)/ratio-uno-2053-1.targetinstall

$(STATEDIR)/ratio-uno-2053-1.targetinstall:
	@$(call targetinfo, vendor-tweaks.targetinstall)

#	copy /etc template
	cp -a $(TOPDIR)/etc/ratio-uno-2053-1/. $(ROOTDIR)/etc

#	remove CVS stuff
	find $(ROOTDIR) -name "CVS" | xargs rm -fr 
	rm -f $(ROOTDIR)/JUST_FOR_CVS

#	make scripts executable
	chmod 755 $(ROOTDIR)/etc/init.d/*

#	generate version stamps
	perl -i -p -e "s,\@VERSION@,$(VERSION),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@PATCHLEVEL@,$(PATCHLEVEL),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@SUBLEVEL@,$(SUBLEVEL),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@PROJECT@,$(PROJECT),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@EXTRAVERSION@,$(EXTRAVERSION),g" $(ROOTDIR)/etc/init.d/banner
	perl -i -p -e "s,\@DATE@,$(shell date -Iseconds),g" $(ROOTDIR)/etc/init.d/banner

	# create menu.lst for grub
	install -d $(ROOTDIR)/boot
	echo "# Konfiguration grub" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "# RATIO " >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#             www.ratiosystem.de" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "timeout 3" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "default 0" >> $(ROOTDIR)/boot/grub/menu.lst
	echo 'title "Compact Flash"' >> $(ROOTDIR)/boot/grub/menu.lst
	echo "root (hd0,0)" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "kernel /boot/bzImage ip=10.192.255.200::10.192.240.254:255.255.240.0:EMIS-IP:eth0:off root=/dev/hda1" >> $(ROOTDIR)/boot/grub/menu.lst
	echo " " >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#Alternativ: Services f�r 2 NICs anmelden:" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#kernel /boot/bzImage ip=192.168.0.209::192.168.0.254:255.255.255.0::eth0:off,192.168.1.254:::255.255.255.0::eth1:off root=/dev/hdc1" >> $(ROOTDIR)/boot/grub/menu.lst
	echo " " >> $(ROOTDIR)/boot/grub/menu.lst
	echo "# Kernelparameter:" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "# Dokumentiert in Linux Kernel Decumentation" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#    Verzeichnis ..ptxdist-0.5.0/build/linux-2.4.22/Documentation/kernel-parameters.txt" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#    IP-Parameter: nfsroot.txt" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#  Bedeutung der IP-Parameter von links nach rechts:" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#    1. Client-IP" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#    2. Server-IP" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#    3. Gateway-IP" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#    4. Netmask" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#    5. Hostname" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#    6. Device (z.B. eth0)" >> $(ROOTDIR)/boot/grub/menu.lst
	echo "#    7. Autoconf (on oder off)" >> $(ROOTDIR)/boot/grub/menu.lst
	
	# create some mountpoints	
	#install -d $(ROOTDIR)/data/

	install -d $(ROOTDIR)/var/run
	install -d $(ROOTDIR)/var/log
	install -d $(ROOTDIR)/var/lock
	
	# create home directories
	#install -d $(ROOTDIR)/home/ratio
	install -d $(ROOTDIR)/home/system
	
	# create some symlinks
	#ln -sf /data/var/spool $(ROOTDIR)/var/spool
	#ln -sf /data/var/cron $(ROOTDIR)/var/cron
	#ln -sf /home/system/localtime $(ROOTDIR)/etc/localtime

	# we need to fix owner / permissions at first startup 
	install -m 755 -D $(MISCDIR)/ptx-init-permissions.sh $(ROOTDIR)/sbin/ptx-init-permissions.sh

	touch $@

# vim: syntax=make
