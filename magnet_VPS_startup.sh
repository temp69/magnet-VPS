#!/bin/bash
WALLET_URL="https://magnetwork.io/Wallets/magnet-qt-1710.tar.gz"
WALLET_ARCH="magnet-qt-1710.tar.gz"
BOOTSTRAP_URL="https://magnetwork.io/Wallets/bootstrap.zip"
BOOTSTRAP_FILE="bootstrap.zip"
WALLET_DESKTOP="/root/Desktop"
WALLET_DIRECTORY="/root/magnet"
WALLET_DATADIR="/root/.magnet"

function prepare_swap() {
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

function update_system() {
	apt-get -y update
	apt-get -y upgrade
}

function install_prerequisits() {
	apt-get -yq install lubuntu-core
	apt-get -yq install lxterminal
	apt-get -yq install xarchiver
	apt-get -yq install libboost-all-dev
	apt-get -yq install qtbase5-dev
	apt-get -yq install libminiupnpc-dev
	apt-get -yq install firefox
	apt-get -yq install gedit
	apt-get -yq install onboard
	apt-get -yq install pwgen
	apt-get -yq install unzip
	apt-get -yq install software-properties-common
	apt-get -yq install python-software-properties	
	add-apt-repository -y ppa:bitcoin/bitcoin
	apt-get -y update
	apt-get -yq install libdb4.8-dev libdb4.8++-dev
}

function xorg_config() {
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

function lightdm_config() {
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

function download_magnet_wallet() {
	mkdir -p $WALLET_DESKTOP
	mkdir -p $WALLET_DIRECTORY
	mkdir -p $WALLET_DATADIR
	cd $WALLET_DIRECTORY
	wget $WALLET_URL
	tar -xvzf $WALLET_ARCH
	cp $WALLET_DIRECTORY/magnet.desktop $WALLET_DESKTOP
}

function config_magnet_wallet() {
	mkdir -p $WALLET_DATADIR
	cd $WALLET_DATADIR
	wget $BOOTSTRAP_URL
	unzip $BOOTSTRAP_FILE
	RANDOM_RPC_USER=$(pwgen 8 1)
	RANDOM_RPC_PASS=$(pwgen 20 1)
	touch $WALLET_DATADIR/magnet.conf
	cat > $WALLET_DATADIR/magnet.conf << EOL
rpcallowip=127.0.0.1
rpcport=17179
rpcuser=$RANDOM_RPC_USER
rpcpassword=$RANDOM_RPC_PASS
server=1
daemon=1
listen=1
staking=0
port=17177
debug=all
addnode=35.199.85.169:17177
addnode=35.198.223.207:17177
addnode=35.194.87.150:17177
addnode=35.189.4.137:17177
addnode=35.185.121.119:17177
addnode=35.200.21.250:17177
addnode=35.205.55.1:17177
addnode=35.189.66.131:17177
addnode=35.198.116.135:17177
addnode=35.199.118.191:17177
addnode=35.200.190.45:17177
addnode=35.189.37.6:17177
addnode=35.189.97.133:17177
addnode=35.203.183.136:17177
addnode=35.195.167.40:17177
addnode=35.199.188.194:17177
addnode=104.196.155.39:17177
addnode=35.197.228.109:17177
addnode=35.198.35.45:17177
addnode=35.197.145.93:17177
addnode=35.199.1.114:17177
addnode=35.201.4.254:17177
addnode=35.188.240.39:17177
addnode=35.199.48.8:17177
addnode=146.148.79.31:17177
addnode=104.196.202.240:17177
addnode=35.195.122.245:17177
addnode=35.198.82.29:17177
addnode=35.200.247.198:17177
EOL
}

#===========================================================
# EXECUTING STEPS
#===========================================================
printf "\n\nSetting up your VPS now, this will take some time." > /dev/tty1
printf "\nOnce finished a GUI login will greet you, press F3 for onboard keyboard\n" > /dev/tty1
printf "\nCreating SWAP drive if needed: " > /dev/tty1
prepare_swap

printf "\nUpdating system!" > /dev/tty1
update_system

printf "\nInstalling prerequisits!" > /dev/tty1
install_prerequisits

printf "\nCreating XORG/LIGHTDM config!" > /dev/tty1
xorg_config
lightdm_config

printf "\nPreparing magnet related content!" > /dev/tty1
download_magnet_wallet
config_magnet_wallet

printf "\nSetting console to GUI!" > /dev/tty1
systemctl start lightdm
