#!/bin/sh

SSID=
WIFISSID=Rockchip-guest
WIFIPWD=RKguest2.4
IPADDR=
WPAPID=
NETMASK=
GW=
DNS=

function getdhcp() {
	while true
	do
		IPADDR=`dhd_priv wl dhcpc_dump | awk '{print $5}' | sed -n '3p'`
		if [ "$IPADDR" != "0.0.0.0" ];then
			NETMASK=`dhd_priv wl dhcpc_dump | awk '{print $7}' | sed -n '3p'`
			GW=`dhd_priv wl dhcpc_dump | awk '{print $9}' | sed -n '3p'`
			DNS=`dhd_priv wl dhcpc_dump | awk '{print $11}' | sed -n '3p'`

			ifconfig wlan0 $IPADDR netmask $NETMASK
			route add default gw $GW
			echo "nameserver $DNS" > /etc/resolv.conf

			echo $IPADDR $NETMASK $GW $DNS
			break
		fi
	done
}

SSID=`dhd_priv isam_status | grep bssid`

if [ "$SSID" ==  "" ];then
	cp /etc/wpa_supplicant.conf /tmp/
	echo "connect to WiFi ssid: $WIFISSID, Passwd: $WIFIPWD"
	sed -i "s/SSID/$WIFISSID/g" /tmp/wpa_supplicant.conf
	sed -i "s/PASSWORD/$WIFIPWD/g" /tmp/wpa_supplicant.conf

	while true
	do
		wpa_supplicant -B -i wlan0 -c /tmp/wpa_supplicant.conf
		sleep 1
		break
		#WPAPID=`ps -ef | grep wpa_supplicant | awk '{print $2}' | sed -n '2p'`
	done

	while true
	do
		SSID=`dhd_priv isam_status | awk '{print $9}' | sed -n '4p' | cut -d '"' -f 2`
		if [ "$SSID" !=  "" ];then
			echo $SSID
			break
		fi
	done

	getdhcp

else
	ifconfig wlan0 up
	getdhcp
fi
