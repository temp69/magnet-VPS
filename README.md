# magnet-VPS

> Startup script for Vultr VPS, hosting magnet QT wallet.

When using this script you will end up beeing able to run the `magnet QT wallet` inside of the console window of Vultr!
![Vultr Console](https://github.com/temp69/magnet-VPS/blob/master/images/VultrMagnetBox.gif)

## Features

- QT Wallet in the console window of Vultr
- Stake your MAG coins and/or run a masternode

## Installation

You can either use a startup script on Vultr or create your VPS instance first and then download the script provided in this github execute it - to install everything needed.

The steps below will show how to create it using a startup script.

### Add Startup Script

Click on **(1)** - Add Startup Script

![Vultr StartUp Script01](https://github.com/temp69/magnet-VPS/blob/master/images/Vultr%20StartUp%20Script01.jpg)

Name it and add the content from **[here](https://raw.githubusercontent.com/temp69/magnet-VPS/master/magnet_VPS_startup.sh)** into the **(2)** script box.

![Vultr StartUp Script02](https://github.com/temp69/magnet-VPS/blob/master/images/Vultr%20StartUp%20Script02.jpg)

### Deploy a new Server

- Choose a location
- Ubuntu 18.04 x64
- 3.50$ will work
- Additional Features - Enable IPv6
- Startup Script - Choose the one you just added
- Enter a host name and deploy it

### Installation process

You can view the installation process, which can take ~ 10 minutes in the **Console view**

![Vultr Installation process01](https://github.com/temp69/magnet-VPS/blob/master/images/Vultr%20Installation%20process01.jpg)
![Vultr Installation process02](https://github.com/temp69/magnet-VPS/blob/master/images/Vultr%20Installation%20process02.jpg)

Once it finishes it will greet you with a graphical login interface.

### Loggin in

Due to the fact that the Vultr console is using a different keyboard layout then the one you are used to, I have enabled a onboard keyboard which can be accessed by pressing **F3**

```diff
- I RECOMMEND ALWAYS USING THE ONBOARD KEYBOARD OR YOU MIGHT END UP NOT BEEING ABLE TO LOG IN
- ALSO USE IT WHEN ENCRYPTING THE WALLET!!!
```
![Vultr Loggin In](https://github.com/temp69/magnet-VPS/blob/master/images/Vultr%20Loggin%20In.jpg)

Once logged in the only thing left todo is click the magnet start icon on the top left of the screen.

### Additional Information

- You can not use Copy & Paste from your local computer into the console\
You can use a copy paste service from the internet eg.: pastebin

- Browser (Firefox) / File Manager / Terminal / Onboard keyboard / Text Editor can be found in the **Start menu**

- Hidden files / folders (e.g.: `.mag` folder) can be turned on in File Manager's Option menu
