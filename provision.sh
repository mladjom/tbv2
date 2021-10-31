#!/usr/bin/env bash

# Ubuntu 20.04 LTS (Focal Fossa), Apache HTTP Server version 2.4, PHP 7.4, MySQL 8, phpMyAdmin, Composer

start=`date +%s`

echo -e "\e[96m Updating & Upgrading  \e[39m"
sudo apt update
sudo apt upgrade

echo -e "\e[96m Installing some tools  \e[39m"
sudo apt -y install curl zip git nano unzip webp nmap
sudo apt -y install webp jpegoptim optipng

echo -e "\e[96m Installing Apache HTTP Server \e[39m"
sudo apt -y install apache2
# Enable some apache modules
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers

echo -e "\e[96m Installing PHP 8.x  \e[39m"
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.0 libapache2-mod-php8.0
sudo systemctl restart apache2

#sudo apt -y install php libapache2-mod-php php7.4-mysql php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd
#sudo apt -y install php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl

# Restart apache server to reflect changes
sudo systemctl restart apache2

echo -e "\e[96m Installing MySQL server \e[39m"
echo -e "\e[93m User: root, Password: toor \e[39m"
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password toor'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password toor'
sudo apt-get install -y mysql-server

#mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;"
#mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;"
#mysql -u root -proot -e "FLUSH PRIVILEGES;"

echo -e "\e[96m Begin silent install phpMyAdmin \e[39m"
echo -e "\e[93m User: root, Password: toor \e[39m"
# Set non-interactive mode
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password toor'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password toor'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password toor'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'﻿

sudo apt -y install phpmyadmin
sudo sed -i "s/|\s*\((count(\$analyzed_sql_results\['select_expr'\]\)/| (\1)/g" /usr/share/phpmyadmin/libraries/sql.lib.php

if [[ -f /vagrant/default.conf ]]; then
    cp /vagrant/default.conf /etc/apache2/sites-available/default.conf
    sudo a2ensite default.conf
fi

if [[ -f /vagrant/custom.conf ]]; then
    cp /vagrant/custom.conf /etc/apache2/sites-available/custom.conf
    sudo a2ensite custom.conf
fi

echo -e "\e[96m Installing Composer \e[39m"
curl -sS https://getcomposer.org/installer -o composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer


#echo -e "\e[96m Installing Symfony \e[39m"
#wget https://get.symfony.com/cli/installer -O - | bash
#sudo mv /home/vagrant/.symfony/bin/symfony /usr/local/bin/symfony
#
#echo -e "\e[96m Installing Node.js \e[39m"
#sudo apt -y install nodejs
#
#echo -e "\e[96m Installing Yarn \e[39m"
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
#sudo apt update && sudo apt install yarn

# Restart apache server to reflect changes
sudo systemctl restart apache2

echo -e "\e[96m Check the status of Apache  \e[39m"
sudo systemctl status apache2

echo -e "\e[96m Check Apache version  \e[39m"
apachectl -v

echo -e "\e[96m Apache conf check  \e[39m"
apachectl configtest

echo -e "\e[96m Check PHP version  \e[39m"
php -v

echo -e "\e[96m Check the status of MySQL  \e[39m"
sudo service mysql status

echo -e "\e[96m Check MySQL version  \e[39m"
mysql --version

echo -e "\e[96m Check Composer version  \e[39m"
composer -V

echo -e "\e[96m Check Node.js version  \e[39m"
nodejs -v

echo -e "\e[96m Check Yarn version  \e[39m"
yarn --version

# Clean up cache
sudo apt-get clean

end=`date +%s`
echo -e "\e[92m Execution time was \e[39m" `expr $end - $start` "\e[92m seconds. \e[39m"
cat << "EOF"
                                          ___
                                        .'   '.
                                       /       \           oOoOo
                                      |         |       ,==|||||
                                       \       /       _|| |||||
                                        '.___.'    _.-'^|| |||||
                                      __/_______.-'     '==HHHHH
                                 _.-'` /                   """""
                              .-'     /   oOoOo
                              `-._   / ,==|||||
                                  '-/._|| |||||
                                   /  ^|| |||||
                                  /    '==HHHHH
                                 /________"""""
                                 `\       `\
                                   \        `\   /
                                   \         `\/
                                    /
                                   /
                                  /_____
 .----------------.  .----------------.  .----------------.  .----------------.
| .--------------. || .--------------. || .--------------. || .--------------. |
| |  _________   | || |   ______     | || | ____   ____  | || |    _____     | |
| | |  _   _  |  | || |  |_   _ \    | || ||_  _| |_  _| | || |   / ___ `.   | |
| | |_/ | | \_|  | || |    | |_) |   | || |  \ \   / /   | || |  |_/___) |   | |
| |     | |      | || |    |  __'.   | || |   \ \ / /    | || |   .'____.'   | |
| |    _| |_     | || |   _| |__) |  | || |    \ ' /     | || |  / /____     | |
| |   |_____|    | || |  |_______/   | || |     \_/      | || |  |_______|   | |
| |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'
EOF