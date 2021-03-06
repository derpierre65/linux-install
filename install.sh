#!/bin/bash

# check if we're running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# environment variables
LC_ALL=C.UTF-8
PHP_PPA="ondrej/php"

sudo mkdir -p /etc/apt/sources.list.d/

if ! grep -q "^deb .*$PHP_PPA" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    # commands to add the ppa ...
    add-apt-repository ppa:ondrej/php
fi

# php, mariadb-server, redis-server, 
sudo apt -y install zsh git snapd openssl curl build-essential \
	wget gnupg2 gnupg-agent dirmngr scdaemon hopenpgp-tools yubikey-personalization \
	php-common php-curl php-json php-mbstring php-mysql php-xml php-zip php-swoole php-gd php-imagick php-redis \
  redis-server \
  mariadb-server \
  flameshot \
  ffmpeg

# cryptsetup, pcscd, secure-delete

# install google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo rm -f google-chrome-stable_current_amd64.deb

# install composer v2
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# nodejs
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# discord, slack
sudo snap install discord
sudo snap install slack --classic

# add canoncial hostnames to ssh config
echo 'CanonicalizeHostname yes
CanonicalDomains own3d.tv own3d.dev stream.tv

Host *
    User root
    ForwardAgent yes
    IdentitiesOnly yes' >> ~/.ssh/config

# docker & docker-compose
sudo apt -y install docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# jetbrains toolbox
cd ~/
wget https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-1.22.10774.tar.gz
chmod +x jetbrains-toolbox-1.22.10774.tar.gz
tar -zxvf jetbrains-toolbox-1.22.10774.tar.gz
cd jetbrains-toolbox-1.22.10774/
./jetbrains-toolbox
cd ..
rm -R jetbrains-toolbox-1.22.10774
rm jetbrains-toolbox-1.22.10774.tar.gz

# other programs
INSTALL_NAMES=(
"PhpStorm"
"OBS"
"gpaste"
"Thunderbird"
"Keepass"
"Lens"
"Spotify"
"Postman"
);
INSTALL_COMMANDS=(
"sudo snap install phpstorm --classic"
"sudo apt -y install obs-studio"
"sudo apt -y install gnome-shell-extension-gpaste gnome-shell-extension-prefs"
"sudo apt -y install thunderbird"
"sudo apt -y install keepassx"
"snap install kontena-lens --classic"
"snap install spotify"
"sudo snap install postman"
);

arrayLength=${#INSTALL_COMMANDS[@]}
for (( i=0; i<${arrayLength}; i++));
do
        read -e -p "Install ${INSTALL_NAMES[i]} (${i}/${arrayLength})? [Y/n] " YN
        if ( [[ $YN == "y" || $YN == "Y" || $YN == "" ]] ) then
                eval ${INSTALL_COMMANDS[i]}
        fi
done

# other settings
INSTALL_NAMES=(
"Show seconds in clock?"
);
INSTALL_COMMANDS=(
"gsettings set org.gnome.desktop.interface clock-show-seconds true"
);

arrayLength=${#INSTALL_COMMANDS[@]}
for (( i=0; i<${arrayLength}; i++));
do
        read -e -p "${INSTALL_NAMES[i]} [Y/n] " YN
        if ( [[ $YN == "y" || $YN == "Y" || $YN == "" ]] ) then
                eval ${INSTALL_COMMANDS[i]}
        fi
done
