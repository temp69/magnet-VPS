#!/bin/bash
WALLET_URL=$(curl -s https://api.github.com/repos/magnetwork/mag/releases/latest | grep browser_download_url | grep -e "x86_64-linux" | cut -d '"' -f 4)
WALLET_ARCH=$(echo $WALLET_URL | cut -d '/' -f 9)
BOOTSTRAP_URL=$(curl -s https://api.github.com/repos/magnetwork/mag/releases/latest | grep browser_download_url | grep -e "bootstrap" | cut -d '"' -f 4)
BOOTSTRAP_FILE=$(echo $BOOTSTRAP_URL | cut -d '/' -f 9)
WALLET_DESKTOP="/root/Desktop"
WALLET_DIRECTORY="/root/magnet"
WALLET_DATADIR="/root/.mag"
WALLT_CONFIGFILE="mag.conf"
MAGNET_PRESSPACKAGE_URL="https://magnetwork.io/home/resources/MAG_PressPackage.zip"
MAGNET_PRESSPACKAGE="MAG_PressPackage.zip"

function prepareSwap() {
	if free | awk '/^Swap:/ {exit !$2}'; then
		printf "Swap exists\n" > /dev/tty1
	else
		dd if=/dev/zero of=/swapfile count=2048 bs=1M
		chmod 600 /swapfile
		mkswap /swapfile
		swapon /swapfile
		echo "/swapfile none swap sw 0 0" >> /etc/fstab
		printf "Swap with 2GB created\n" > /dev/tty1
	fi
}

function updateSystem() {
	sudo apt-get -y update
	sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
}

function installPrerequisits() {
	apt-get -y update
	apt-get -yq install lubuntu-core
	apt-get -yq install lxterminal
	apt-get -yq install xarchiver
	#apt-get -yq install libboost-all-dev
	#apt-get -yq install qtbase5-dev
	apt-get -yq install libminiupnpc-dev
	apt-get -yq install firefox
	apt-get -yq install gedit
	apt-get -yq install onboard
	apt-get -yq install pwgen
	apt-get -yq install unzip
	#apt-get -yq install software-properties-common
	#apt-get -yq install python-software-properties	
	#add-apt-repository -y ppa:bitcoin/bitcoin
	#apt-get -y update
	#apt-get -yq install libdb4.8-dev libdb4.8++-dev
}

function xorgConfig() {
	touch /usr/share/X11/xorg.conf.d/xorg.conf
	cat > /usr/share/X11/xorg.conf.d/xorg.conf << EOL
	Section "Device"
		Identifier      "device"
	EndSection
	Section "Screen"
		Identifier      "screen"
		Device          "device"
		Monitor         "monitor"
		DefaultDepth    24
		SubSection "Display"
			Modes       "1280x800" "1280x1024" "1280x960" "1280x768" "1280x720" "1024x768" "800x600"
		EndSubSection
	EndSection
	Section "Monitor"
		Identifier      "monitor"
		HorizSync       0.0 - 100.0
		VertRefresh     0.0 - 100.0
	EndSection
	Section "ServerLayout"
		Identifier      "layout"
		Screen          "screen"
	EndSection
EOL
}

function lightdmConfig() {
	touch /etc/lightdm/lightdm.conf
	cat > /etc/lightdm/lightdm.conf << EOL
[SeatDefaults]
autologin-user=root
autologin-user-timeout=0
user-session=ubuntu
xserver-command=X -s 0 dpms
EOL
echo 'keyboard=onboard' >> /etc/lightdm/lightdm-gtk-greeter.conf.d/30_lubuntu.conf
}

function downloadMagnetWallet() {
	mkdir -p $WALLET_DESKTOP
	mkdir -p $WALLET_DIRECTORY
	mkdir -p $WALLET_DATADIR
	cd $WALLET_DIRECTORY
	rm -rfv *
	wget $WALLET_URL
	tar -xvzf $WALLET_ARCH
	MAGQTWALLET=$(find -name mag-qt)
	cp $MAGQTWALLET $WALLET_DIRECTORY
	wget $MAGNET_PRESSPACKAGE_URL
	unzip $MAGNET_PRESSPACKAGE
	MAGICON=$(find -name MAG_logo.svg)
	cp $MAGICON $WALLET_DIRECTORY
}

function createMagnetDesktopIcon() {
	mkdir -p $WALLET_DESKTOP
	cd $WALLET_DESKTOP
	touch magnet.Desktop
	cat > magnet.Desktop << EOL
[Desktop Entry]
Name=MAGNET QT WALLET
Comment=Launches the magnet qt wallet
Exec=/root/magnet/mag-qt
Terminal=false
Type=Application
Icon=/root/magnet/MAG_logo.svg
EOL
}

function configMagnetWallet() {
	mkdir -p $WALLET_DATADIR
	cd $WALLET_DATADIR
	wget $BOOTSTRAP_URL
	unzip $BOOTSTRAP_FILE
	RANDOM_RPC_USER=$(pwgen 8 1)
	RANDOM_RPC_PASS=$(pwgen 20 1)
	touch $WALLET_DATADIR/$WALLT_CONFIGFILE
	cat > $WALLET_DATADIR/$WALLT_CONFIGFILE << EOL
rpcallowip=127.0.0.1
rpcport=17103
rpcuser=$RANDOM_RPC_USER
rpcpassword=$RANDOM_RPC_PASS
server=1
daemon=1
listen=1
staking=1
port=17172
debug=all
addnode=144.202.31.248:17172
addnode=45.32.222.50:17172
addnode=144.202.75.165:17172
addnode=95.179.199.60:17172
addnode=149.28.247.127:17172
addnode=209.222.30.206:17172
addnode=66.42.84.233:17172
EOL
}

#===========================================================
# EXECUTING STEPS
#===========================================================
printf "\n\nSetting up your VPS now, this will take some time." > /dev/tty1
printf "\nOnce finished a GUI login will greet you, press F3 for onboard keyboard\n" > /dev/tty1
printf "\nCreating SWAP drive if needed: " > /dev/tty1
prepareSwap

printf "\nUpdating system!" > /dev/tty1
updateSystem

printf "\nInstalling prerequisits!" > /dev/tty1
installPrerequisits

printf "\nCreating XORG/LIGHTDM config!" > /dev/tty1
xorgConfig
lightdmConfig

printf "\nPreparing magnet related content!" > /dev/tty1
downloadMagnetWallet
configMagnetWallet
createMagnetDesktopIcon

printf "\nSetting console to GUI!" > /dev/tty1
systemctl start lightdm
