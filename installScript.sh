#!/bin/bash
#This must be used in EFI mode
# Ensure script runs in EFI mode
if [ ! -d /sys/firmware/efi ]; then
  echo "EFI firmware not detected. Please boot in UEFI mode."
  exit 1
fi

#Loads the keymap for the file
loadkeys us
timedatectl set-ntp true

# Verify disk presence before partitioning
DISK="/dev/sda"
if [ ! -b "$DISK" ]; then
  echo "Disk $DISK not found. Please check your disk configuration."
  exit 1
fi

# Confirm partitioning
echo "WARNING: This will modify partitions on $DISK."
read -p "Proceed? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "Partitioning canceled."
  exit 0
fi

#Will start up the disk configuration menu
#Installation with the script is done assuming 2 partitions on the same disk
cfdisk "$DISK"

# Check if any partitions are already mounted and unmount them
check_and_unmount() {
  local device=$1
  if grep -q "$device" /proc/mounts; then
    echo "$device is currently mounted. Attempting to unmount..."
    mountpoints=$(grep "$device" /proc/mounts | awk '{print $2}')
    for mp in $mountpoints; do
      echo "Unmounting $device from $mp..."
      umount -f "$mp" || { echo "Failed to unmount $device from $mp"; return 1; }
    done
    echo "Successfully unmounted $device"
  else
    echo "$device is not mounted"
  fi
  return 0
}

# Display partition information for verification
echo "Current partition information:"
fdisk -l "$DISK"
lsblk -f

# Unmount all partitions that will be formatted
echo "Checking if partitions are mounted..."
check_and_unmount "${DISK}1" || { echo "Failed to unmount ${DISK}1. Please unmount manually and try again."; exit 1; }
check_and_unmount "${DISK}2" || { echo "Failed to unmount ${DISK}2. Please unmount manually and try again."; exit 1; }

# Additional check for /mnt
if mountpoint -q /mnt; then
  echo "Unmounting /mnt..."
  umount -R /mnt || { echo "Failed to unmount /mnt. Please unmount manually and try again."; exit 1; }
fi

# Format the partitions with confirmation
echo "Ready to format partitions:"
echo "  ${DISK}1 will be formatted as FAT32 (EFI partition)"
echo "  ${DISK}2 will be formatted as BTRFS (Root partition)"
read -p "Proceed with formatting? (y/n): " FORMAT_CONFIRM
if [[ "$FORMAT_CONFIRM" != "y" ]]; then
  echo "Formatting canceled."
  exit 0
fi

echo "Formatting ${DISK}1 as FAT32..."
mkfs.fat -F32 "${DISK}1" || { echo "Failed to format ${DISK}1"; exit 1; }

echo "Formatting ${DISK}2 as BTRFS..."
mkfs.btrfs -f "${DISK}2" || { echo "Failed to format ${DISK}2"; exit 1; }

# Verify the formatted filesystem
echo "Verifying formatted filesystems:"
lsblk -f

# Make sure /mnt is not already mounted
if mountpoint -q /mnt; then
  echo "Unmounting /mnt before proceeding..."
  umount -R /mnt
fi

# Create mount point if it doesn't exist
mkdir -p /mnt

# Mount the main partition and create subvolumes
echo "Mounting ${DISK}2 to /mnt..."
mount "${DISK}2" /mnt || { echo "Failed to mount ${DISK}2 to /mnt"; exit 1; }
echo "Creating btrfs subvolumes..."
btrfs subvolume create /mnt/@ || { echo "Failed to create @ subvolume"; exit 1; }
btrfs subvolume create /mnt/@home || { echo "Failed to create @home subvolume"; exit 1; }
echo "Unmounting /mnt..."
umount /mnt || { echo "Failed to unmount /mnt"; exit 1; }

# Mount subvolumes
echo "Mounting @ subvolume to /mnt..."
mount -o subvol=@ "${DISK}2" /mnt || { echo "Failed to mount @ subvolume"; exit 1; }
echo "Creating /mnt/home directory..."
mkdir -p /mnt/home
echo "Mounting @home subvolume to /mnt/home..."
mount -o subvol=@home "${DISK}2" /mnt/home || { echo "Failed to mount @home subvolume"; exit 1; }
echo "Creating /mnt/efi directory..."
mkdir -p /mnt/efi
echo "Mounting ${DISK}1 to /mnt/efi..."
mount "${DISK}1" /mnt/efi || { echo "Failed to mount ${DISK}1 to /mnt/efi"; exit 1; }

# Verify mounts
echo "Verifying mounts:"
mount | grep "/mnt"

# Check if /mnt is properly mounted before proceeding
if ! mountpoint -q /mnt; then
  echo "ERROR: /mnt is not a mountpoint. Mount failed. Exiting."
  exit 1
fi

echo "Installing base packages to /mnt..."
#Installing other packages
pacstrap -K /mnt base base-devel linux linux-firmware git btrfs-progs nano networkmanager grub efibootmgr || { 
  echo "Failed to install packages to new root. Check your internet connection and try again."
  exit 1
}

#Fstab
genfstab -U /mnt >> /mnt/etc/fstab

read -p "Enter username: " NEWUSER
if [[ -z "$NEWUSER" ]]; then
  echo "Invalid username. Please enter a valid username."
  exit 1
fi

# Create the chroot script
cat > /mnt/setup.sh << EOL
#!/bin/bash
# Set local time and hardware clock
ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
hwclock --systohc

# Locale and keymap settings
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# Set the system hostname
echo "Arch" > /etc/hostname
echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 Arch" > /etc/hosts

# Set root password
echo "Set your root password"
passwd

# Create the user
useradd -m -G wheel -s /bin/bash "${NEWUSER}"
echo "Set password for ${NEWUSER}:"
passwd ${NEWUSER}
echo "${NEWUSER} ALL=(ALL) ALL" >> /etc/sudoers.d/${NEWUSER}
chmod 0440 /etc/sudoers.d/${NEWUSER}

# Install and configure GRUB
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB  
grub-mkconfig -o /boot/grub/grub.cfg

# Enable NetworkManager
systemctl enable NetworkManager
EOL

# Make setup script executable
chmod +x /mnt/setup.sh

# Run the setup script in chroot
arch-chroot /mnt /setup.sh

# Cleanup
rm /mnt/setup.sh

#Reboot
umount -R /mnt
echo "Installation complete! You can now reboot."
read -p "Reboot now? (y/n): " REBOOT
if [[ "$REBOOT" == "y" ]]; then
  reboot
fi
