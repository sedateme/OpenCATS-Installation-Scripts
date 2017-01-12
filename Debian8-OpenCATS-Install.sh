#!/bin/sh
# This script will install a new OpenCATS instance on a fresh Debian 8 server.
# This script is experimental and does not ensure any security.


export DEBIAN_FRONTEND=noninteractive
apt -y update
apt install -y mariadb-server mariadb-client apache2 curl php5 php-soap php5-ldap php5-mysql php5-gd php5-curl antiword poppler-utils html2text unrtf

# Set up database
mysql -u root --execute="CREATE DATABASE cats_dev;"
mysql -u root --execute="CREATE USER 'cats'@'localhost' IDENTIFIED BY 'password';"
mysql -u root --execute="GRANT ALL PRIVILEGES ON cats_dev.* TO 'cats'@'localhost';"

# Download OpenCATS
cd /var/www/html
wget https://github.com/opencats/OpenCATS/archive/0.9.3-3.tar.gz
tar -xvzf 0.9.3-3.tar.gz
mv OpenCATS-0.9.3-3 opencats
cd /var/www/html/opencats

# Install composer
cd /usr/src
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
cd /var/www/html/opencats


# Install OpenCATS composer dependancies
composer install
cd ..

# Set file and folder permissions
chown www-data:www-data -R opencats && chmod -R 770 opencats/attachments opencats/upload

# Restart Apache to load new config
service apache2 restart

echo ""
echo "Setup Finished, Your OpenCATS applicant tracking system should now be installed."
echo "MySQL was installed without a root password, It is recommended that you set a root MySQL password."
echo ""

echo "You can finish installation of your OpenCATS applicant tracking system at: http://localhost/opencats"
