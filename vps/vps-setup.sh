#!/usr/bin/env bash

# DOMAIN
DOMAIN=$1
ROOT_MYSQL_PWD=$2

# Check if domain is set
if [ -z "$DOMAIN" ]
then
    echo "Domain is not set"
    exit 1
fi

# Check if root mysql password is set
if [ -z "$ROOT_MYSQL_PWD" ]
then
    echo "Root mysql password is not set"
    exit 1
fi

# Title function to display title
function title
{
    #write title
    echo "\033[32m -----------------------------------------------"
    echo " $1"
    echo " -----------------------------------------------\033[0m"
}

# Display title
# make title blue
echo "\033[34m"
echo " __   __ ___  ___   ___  ___  _____  _   _  ___ "
echo " \ \ / /| _ \/ __| / __|| __||_   _|| | | || _ \ "
echo "  \ V / |  _/\__ \ \__ \| _|   | |  | |_| ||  _/ "
echo "   \_/  |_|  |___/ |___/|___|  |_|   \___/ |_| "
echo "                    v 1.0\033[0m"

# Should fail if any command fails
set -e

# Update the system
title "Update the system"
sudo apt-get update && sudo apt-get upgrade -y

# Install mysql
title "Install mysql"
sudo apt-get install mysql-server -y

# Run mysql_secure_installation
sudo mysql_secure_installation

# Set root password
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$ROOT_MYSQL_PWD'; FLUSH PRIVILEGES;" -p

# Install php
title "Install php"
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.2 php8.2-fpm php8.2-mysql php8.2-xml php8.2-mbstring php8.2-intl php8.2-curl php8.2-gd

# Install nginx
title "Install nginx"
sudo apt-get install nginx -y

# Configure nginx
sudo mv files/nginx.conf /etc/nginx/nginx.conf
sudo mv files/default "/etc/nginx/sites-available/$DOMAIN"
sudo ln -s "/etc/nginx/sites-available/$DOMAIN" /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Install composer
title "Install composer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
HASH="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "if (hash_file('sha384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
composer --version

# Install certbot
title "Install certbot"
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot


