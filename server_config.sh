#!/bin/bash


# install HTOP
apt-get install htop


# add swap
if [ ! -f "/swapfile" ]
then
	dd if=/dev/zero of=/swapfile bs=1M count=1500
	chown root:root /swapfile
	chmod 0600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo "/swapfile none swap sw 0 0" >> /etc/fstab
fi


# install git
apt-get install git


# add user and add to sudoers
adduser user
usermod -aG sudo user
usermod -aG www-data user


# create project folder
mkdir /home/www
chown -hR user:user /home/www


# install php 5.6
apt install software-properties-common
add-apt-repository ppa:ondrej/php
apt-get update
apt-get install python-software-properties
apt-get update
apt-get install php5.6 php5.6-curl php5.6-pgsql php5.6-zip php5.6-xml php5.6-mbstring php5.6-json php5.6-fpm php5.6-gd
cp -f ~/server_config/php/php.ini /etc/php/5.6/fpm/php.ini


# install nginx
apt-get install nginx
cp -f ~/server_config/nginx/nginx.conf /etc/nginx/nginx.conf
cp -f ~/server_config/nginx/conf.d/domain.conf /etc/nginx/sites-availible/default
cp -f ~/server_config/nginx/conf.d/domain.conf /etc/nginx/sites-enabled/default


# install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
cp -f ~/server_config/php/pool.d/www.conf /etc/php/5.6/fpm/pool.d/www.conf


# install NodeJS and NPM
apt-get install nodejs npm
ln -s /usr/bin/nodejs /usr/bin/node


# install curl
apt-get install curl


# install gulp
npm install --global gulp
npm link gulp


# install zsh
apt-get install zsh


# install postgres
apt-get install postgresql
sudo -u postgres psql postgres

# restart services
service nginx restart
service php5.6-fpm restart