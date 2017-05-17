#!/bin/bash
# Wordpress server install scrip
# By Benjamin Guichard

# Create : Variables
export DEBIAN_FRONTEND=noninteractive
export CODENAME=`lsb_release --codename | cut -f2`

# Add : sources repositories
wget -qO- https://nginx.org/keys/nginx_signing.key | apt-key add -
echo "deb http://nginx.org/packages/ubuntu/ $CODENAME nginx" > /etc/apt/sources.list.d/nginx.list

# Update : the system
apt-get update
apt-get dist-upgrade -y && apt autoremove -y

# Install : and configure Nginx 1.12
apt-get install -y nginx=1.12.*
sed -i 's/^user.*/user www-data;/' /etc/nginx/nginx.conf
mv /tmp/default.conf /etc/nginx/conf.d/default.conf
/usr/sbin/service nginx restart

# Install : Php7 + Mariadb-client
apt-get install -y php7.0-fpm php7.0-curl php7.0-mcrypt php7.0-gd php7.0-mysql mariadb-client
/usr/sbin/service php7.0-fpm restart

# Install : Wordpress
wget -P ~/ https://wordpress.org/latest.tar.gz
mkdir -p /var/www/wordpress/
tar xzf ~/latest.tar.gz -C /var/www/wordpress --strip-components=1
