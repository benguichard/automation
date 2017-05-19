#!/bin/bash
# Wordpress server install scrip
# By Benjamin Guichard

# Create : Variables
export DEBIAN_FRONTEND=noninteractive
export CODENAME=`lsb_release --codename | cut -f2`
export PHP_VERSION=7.0.15-*
export NGINX_VERSION=1.12.*

# add : sources repositories
wget -qO- https://nginx.org/keys/nginx_signing.key | apt-key add -
echo "deb http://nginx.org/packages/ubuntu/ $CODENAME nginx" > /etc/apt/sources.list.d/nginx.list

# update : system
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y

# install : nginx
apt-get install -y nginx=$NGINX_VERSION
sed -i 's/^user.*/user www-data;/' /etc/nginx/nginx.conf
mv /tmp/default.conf /etc/nginx/conf.d/default.conf
/usr/sbin/service nginx restart

# install : php7 + mariadb-client
apt-get install -y \
    php7.0-fpm=$PHP_VERSION \
    php7.0-curl=$PHP_VERSION \
    php7.0-mcrypt=$PHP_VERSION \
    php7.0-gd=$PHP_VERSION \
    php7.0-mysql=$PHP_VERSION
/usr/sbin/service php7.0-fpm restart

# Install : Wordpress
wget -P ~/ https://wordpress.org/latest.tar.gz
mkdir -p /var/www/wordpress/
tar xzf ~/latest.tar.gz -C /var/www/wordpress --strip-components=1
