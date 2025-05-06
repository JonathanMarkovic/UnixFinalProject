#This must be used in EFI mode
#Loads the keymap for the file
loadkeys us


timedatectl set-ntp true
#Will start up the disk configuration menu
#Installation with the script is done assuming 2 partitions on the same disk
#cfdisk
cfdisk /dev/sda
mkfs.fat -F 32 /dev/sda1
mkfs.btrfs /dev/sda2
mount /dev/sda2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt
mount -o subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/home
mount -o subvol=@home /dev/sda2 /mnt/home
mkdir -p /mnt/efi
mount /dev/sda1 /mnt/efi

#Installing other packages
pacstrap -K /mnt base base-devel linux linux-firmware git btrfs-progs nano networkmanager

#Fstab
genfstab -U /mnt >> /mnt/etc/fstab

read -p "Enter username: " NEWUSER

arch-chroot /mnt /bin/bash <<EOF

#Setting local time to est
ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
hwclock --systohc

#echo -e "Uncomment the line for your locale"
#sleep 5
#nano /etc/locale.gen
#locale-gen
#echo "KEYMAP=us" > /etc/vconsole.conf

# Locale and keymap
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

#Setting hostname
echo "Arch" > /etc/hostname
echo -e "127.0.0.0 localhost\n::1 localhost\n127.0.1.1 Arch" > /etc/hosts

#root and User creation
echo "Set your root password"
passwd

# Create user
useradd -m -G wheel -s /bin/bash $NEWUSER
echo "Set password for $NEWUSER:"
passwd $NEWUSER
echo "$NEWUSER ALL=(ALL) ALL" >> /etc/sudoers.d/$NEWUSER
chmod 0440 /etc/sudoers.d/$NEWUSER

#Setting up Grub
pacman -S grub
pacman -S efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB  
grub-mkconfig -o /boot/grub/grub.cfg

#prepping for reboot
systemctl enable NetworkManager

EOF

#Reboot
umount -R /mnt
reboot
