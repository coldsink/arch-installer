#! /bin/bash

prompt="echo "======================================================================"
clear
$prompt
echo
echo " > Setting zoneinfo... "
echo
$prompt
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
sleep 0.5s
clear
$prompt
echo
echo " > Finalizing locale preferences. " 
echo
$prompt
echo "en_US.UTF-8 UTF-8 > /etc/locale.gen"
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
locale-gen
hwclock --systohc --utc
clear
$prompt
echo
echo " > Please enter machine hostname. "
echo
$prompt
echo
read -p ' -> ' hostname
clear
$prompt
echo
echo " > Hostname set. "
echo
$prompt
echo "$hostname" >> /etc/hostname
echo "
127.0.0.1	localhost
::1		localhost
127.0.1.1 	$hostname.localdomain	$hostname" >> /etc/hosts
sleep 0.5s
clear
$prompt
echo
echo " > Configuring sudo... "
echo
$prompt
sleep 0.5s
clear
visudo
clear
$prompt
echo
echo " > Installing bootloader... "
echo
$prompt
sleep 0.5s
clear
$prompt
echo
echo " > Installing bootloader... "
echo
$prompt
echo
pacman -S grub efibootmgr
clear
$prompt
echo
echo " > Configuring bootloader... " 
echo
$prompt
sleep 0.5s
clear
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=arch
clear
grub-mkconfig -o /boot/grub/grub.cfg
clear
$prompt
echo
echo " > Set root password. "
echo
$prompt
echo
passwd
clear
sleep 0.5s
$prompt
echo
echo " > Enter "yes" for wireless. Enter "no" for wired. "
echo
$prompt
echo
read -p " -> " network
	if [ $network = yes ]
	then 
		clear
		$prompt
		echo
		ip link 
		echo
		$prompt
		echo
		echo " > Choose wireless interface. "
		read -p " -> " wireless_interface
		echo
		echo " > Enter network SSID. "
		read -p " -> " ssid
		echo
		echo " > Enter network password. "
		read -p " -> " psk
		clear
		$prompt
		echo
		echo " > Settings applied. Configuring network settings... "
		echo
		$prompt
		mkdir -p /etc/wpa_supplicant 
		wpa_passphrase "$ssid" "$psk" >> /etc/wpa_supplicant/wpa_supplicant-$wireless_interface.conf
		clear
		$prompt
		echo
		echo " > Upon reboot, you will need to enable dhcpcd@$wireless_interface.service and wpa_supplicant@$wireless_interface.service. "
		echo
		$prompt
		sleep 3s
	else
		clear
		$prompt
		echo
		ip link
		echo
		$prompt
		echo
		echo " > Choose wired interface. "	
		read -p " -> " wired_interface
		clear
		$prompt
		echo
		echo " > Upon reboot, you will need to enable dhcpcd@$wired_interface.service "
		echo
		$prompt
		sleep 3s
		clear
$prompt
echo
echo "Installation finished. Rebooting... "
echo
$prompt
sleep 1s
clear
