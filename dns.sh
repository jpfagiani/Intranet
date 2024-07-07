#!/bin/bash

apt update 
hostnamectl set-hostname intranet.cdpni.gov
apt install bind9 bind9utils dnsutils -y
cp -v /cdpni/intranet/etc/* /etc
	chattr +i /etc/resolv.conf
cp -v /cdpni/intranet/network/interfaces /etc/network/
cp -v /cdpni/intranet/ssh/sshd_config /etc/ssh/
systemctl restart sshd	
systemctl stop named
systemctl stop apparmor
cp -v /cdpni/intranet/default/named /etc/default/
mkdir -pv /var/bind9/chroot/{etc,dev,var/cache/bind,var/run/named} 
	mv -v /root/etc/bind /var/bind9/chroot/etc
	ln -s /var/bind9/chroot/etc/bind /etc/bind
	cp -v /etc/localtime /var/bind9/chroot/etc/	
	chown bind:bind -R /var/bind9/chroot/etc/bind/rndc.key /var/bind9/chroot/var/
	chmod 775 -R /var/bind9/chroot/var/
cp -av /dev/null /var/bind9/chroot/dev/
cp -av /dev/random /var/bind9/chroot/dev/
	chmod 660 /var/bind9/chroot/dev/{null,random}
cp -av /cdpni/intranet/init.d/named /etc/init.d	
cp -v /intranet/apparmor.d/usr.sbin.named /etc/apparmor.d/	
cp -av /usr/share/dns/root.hints /var/bind9/chroot/var/cache/bind
cp -v /cdpni/intranet/bind_chroot/etc/bind/named.conf* /etc/bind
cp -v /cdpni/intranet/bind_chroot/etc/bind/* /var/bind9/chroot/var/cache/bind
	chgrp bind /var/bind9/chroot/var/{cache/bind,run/named}
systemctl restart apparmor named
systemctl status named apparmor
echo "\$AddUnixListenSocket /var/bind9/chroot/dev/log" > /etc/rsyslog.d/bind-chroot.conf





