#!/bin/bash

# check if we're running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# environment variables
LC_ALL=C.UTF-8
PHP_PPA="ondrej/php"

# install base stuff
apt -y install git curl build-essential wget software-properties-common

mkdir -p /etc/apt/sources.list.d/

if ! grep -q "^deb .*$PHP_PPA" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    # commands to add the ppa ...
    add-apt-repository ppa:ondrej/php
fi

# install services
INSTALL_NAMES=(
"nodejs"
"php"
"redis"
"mariadb-server"
"php composer"
"nginx"
"certbot"
"htop"
"deployer"
);

INSTALL_COMMANDS=(
"(curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -) && apt-get install -y nodejs"
"apt -y install php-common php-curl php-json php-mbstring php-mysql php-xml php-zip php-gd php-imagick php-redis"
"apt -y install redis-server"
"apt -y install mariadb-server"
"curl -sS https://getcomposer.org/installer -o composer-setup.php && php composer-setup.php --install-dir=/usr/local/bin --filename=composer && rm composer-setup.php"
"apt -y install nginx"
"apt -y install snapd; sudo snap install core; sudo snap refresh core; sudo snap install --classic certbot; sudo ln -s /snap/bin/certbot /usr/bin/certbot"
"apt -y install htop"
"curl -LO https://deployer.org/deployer.phar; mv deployer.phar /usr/local/bin/dep; chmod +x /usr/local/bin/dep"
);

arrayLength=${#INSTALL_COMMANDS[@]}
for (( i=0; i<${arrayLength}; i++));
do
        read -e -p "Install ${INSTALL_NAMES[i]} (${i}/${arrayLength})? [Y/n] " YN
        if ( [[ $YN == "y" || $YN == "Y" || $YN == "" ]] ) then
                eval ${INSTALL_COMMANDS[i]}
        fi
done
