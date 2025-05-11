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

cd Scripts
pwd

chmod +x ./installBrowsers.sh
chmod +x ./installDesktop.sh
chmod +x ./installEditors.sh
chmod +x ./installFileManagers.sh
chmod +x ./Scripts/installTerminals.sh
chmod +x ./Scripts/installUtilities.sh
chmod +x ./Scripts/UnixProject.sh
chnod +x ./Scripts/autoTask.sh

bash ./UnixProject.sh
