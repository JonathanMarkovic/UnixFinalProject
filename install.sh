#This is the Unix Final Project Install File.
#This will start by installing Yay and then making sure all installation
#files are able to execute.
#You will be prompted for your sudo password.

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
sudo pacman -S base-devel
makepkg -si

cd ..
pwd
chmod +x ./installBrowsers.sh
chmod +x ./installDesktop.sh
chmod +x ./isntallEditors.sh
chmod +x ./installFileManagers.sh
chmod +x ./installTerminals.sh
chmod +x ./installUtilities.sh
chmod +x ./UnixProject.sh

bash ./UnixProject.sh
