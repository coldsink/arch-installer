#! /bin/bash
prompt="echo "===========================================================================================""
clear
$prompt
echo
echo " > Starting install..."
echo
$prompt
sleep 0.5s
clear
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
		wifi-menu
		clear
	else
		clear
		$prompt
		echo
		ip link
		echo
		$prompt
		echo
		echo " > Select wired interface. "
		read -p " -> " interface
		ip link set up $interface
		sleep 2s
		clear
	fi
		timedatectl set-ntp true
		echo " > Scanning drives... "
		sleep 0.25s
		clear
		echo
		$prompt
		echo
		echo " > Select drive to partition. This operation cannot be reverted. (ex. sdX, not /dev/sdX) "
		echo
		lsblk
		echo
		$prompt
		echo
		read -p ' -> ' drive
		clear
		$prompt
		echo
		echo " > Wiping drive... "
		echo
		$prompt
		sleep 0.5s
		wipefs -a /dev/$drive
		clear
		$prompt
		echo
		echo " > Create partitions... "
		echo
		$prompt
		sleep 0.5s
		cfdisk /dev/$drive
		clear
		$prompt
		echo
		echo " > Formatting partitions... "
		echo
		$prompt
		sleep 1s
		clear
		$prompt
		echo
		lsblk
		echo
		$prompt
		echo
		echo " > Enter efi partition. "
		read -p " -> " efi
		mkfs.vfat -n EFI /dev/$efi
		clear
		$prompt
		echo
		lsblk
		echo
		$prompt
		echo
		echo " > Enter swap partition. "
		read -p " -> " swp 
		mkswap -L SWAP /dev/$swp
		clear
		$prompt
		echo
		lsblk
		echo
		$prompt
		echo
		echo " > Enter root partition. "
		read -p " -> " root 
		mkfs.ext4 -L ROOT /dev/$root
		clear
		$prompt
		echo
		lsblk
		echo
		$prompt
		echo
		echo " > Enter home partition. "
		read -p " -> " home 
		mkfs.ext4 -L HOME /dev/$home
		clear
		$prompt
		echo
		echo " > Mounting partitions... "
		echo
		$prompt
		sleep 0.5s
		mount /dev/$root /mnt
		mkdir /mnt/home
		mount /dev/$home /mnt/home
		mkdir /mnt/efi
		mount /dev/$efi /mnt/efi
		swapon /dev/$swp
		clear
		$prompt
		echo
		echo " > Edit mirrorlist... "
		echo
		$prompt
		sleep 1s
		vim /etc/pacman.d/mirrorlist
		clear
		$prompt
		echo
		echo " > Installing base system... "
		echo
		$prompt
		echo
		pacstrap /mnt base linux linux-firmware base-devel vim sudo wpa_supplicant dhcpcd
		clear
		$prompt
		echo
		echo " > Generating fstab... "
		echo
		$prompt
		genfstab -U /mnt >> /mnt/etc/fstab
		sleep 0.5s
		clear
		$prompt
		echo
		echo " > Chrooting... "
		echo
		$prompt
		sleep 0.5s
		clear
		cp arch_install_2.sh /mnt
		arch-chroot /mnt ./arch_install_2.sh
		echo " > Reboot now? (yes) (no) "
		read -p " -> " reboot
		if [ reboot = yes ]
		then
			killall dhcpcd
			clear
			killall netctl
			clear
			rm -f /mnt/arch_install_2.sh
			umount -R /mnt
			reboot
		else
			echo " > Reboot aborted. "
		fi
