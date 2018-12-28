# magnet-VPS

> Startup script for Vultr VPS, hosting magnet QT wallet.

When using this script you will end up beeing able to run the `magnet QT wallet` inside of the console window of Vultr!
![Vultr Console](https://picture.png)

## Features

- QT Wallet in the console window of Vultr
- Stake your MAG coins and/or run a masternode

## Installation

You can either use a startup script on Vultr or create your VPS instance first and then download the script provided in this github\
execute it - to install everything needed.\

The steps below will show how to create it using a startup script.

### Add Startup Script

Click on (1) - Add Startup Script

![Vultr StartUp Script01](https://picture.png)

Name it and add the content from [here](https://raw.githubusercontent.com/temp69/magnet-VPS/master/magnet_VPS_startup.sh) into the (2) script box.

![Vultr StartUp Script02](https://picture.png)

### Deploy a new Server

- Choose a location
- Ubuntu 18.04 x64
- 3.50$ will work
- Additional Features enable IPv6
- Startup Script - Choose the one you just added
- Enter a host name and deploy it

### Installation process

You can view the installation process, which can take ~ 10 minutes in the **Console view**

![Vultr Installation process](https://picture.png)

Once it finishes it will greet you with a graphical login interface.

### Loggin in

Due to the fact that the Vultr console is using a different keyboard layout then the one you are used to, I have enabled a onboard keyboard which\
can be accessed by pressing **<F3>**

```diff
I RECOMMEND ALWAYS USING THE ONBOARD KEYBOARD OR YOU MIGHT END UP NOT BEEING ABLE TO LOG IN
ALSO USE IT WHEN ENCRYPTING THE WALLET!!!
```
![Vultr Loggin In](https://picture.png)

Once logged in the only thing left todo is click the magnet start icon on the top left of the screen.

### Additional Information

- You can not use Copy & Paste from your local computer into the console\
You can use a copy paste server from the internet todo so, I installed Firefox on the box as well.

