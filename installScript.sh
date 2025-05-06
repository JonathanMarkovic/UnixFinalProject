#This must be used in EFI mode
#Loads the keymap for the file
loadkeys us


timedatectl set-ntp true
#Will start up the disk configuration menu
#Installation with the script is done assuming 2 partitions on the same disk
cfdisk
mkfs.fat -F 32 /dev/sda1
mkfs.btrfs /dev/sda2
mount /dev/sda2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
mount -o subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/home
mount -o subvol=@home /dev/sda2 /mnt/home
mkdir -p /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi

#Installing other packages
pacstrap -K /mnt base base-devel linux linux-firmware git btrfs-progs nano

#Fstab
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

#Setting local time to est
ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
hwclock --systohc

echo -e "Uncomment the line for your locale"
sleep 5
nano /etc/locale.gen
locale-gen
echo "KEYMAP=us" > /etc/vconsole.conf

#Setting hostname
echo "Arch" > /etc/hostname
echo -e "127.0.0.0 localhost\n::1 localhost\n127.0.1.1 Arch" > /etc/hosts

#root and User creation
echo "Set your root password"
passwd

#Setting up Grub
pacman -S grub
pacman -S efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB  
grub-mkconfig -o /boot/grub/grub.cfg

#prepping for reboot
pacman -S networkmanager
systemctl enable NetworkManager
exit
umount -R /mnt
reboot
