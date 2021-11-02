#!/usr/bin/env bash

# Ubuntu 20.04 LTS (Focal Fossa), NGINX, PHP 7.4, MySQL 8, phpMyAdmin, Composer

start=`date +%s`

echo -e "\e[96m Updating & Upgrading  \e[39m"
sudo apt update & sudo apt upgrade

echo -e "\e[96m Installing some tools  \e[39m"
sudo apt -y install curl zip git nano unzip webp nmap
sudo apt -y install webp jpegoptim optipng

echo -e "\e[96m Installing NGINX  \e[39m"
sudo -y apt install nginx

echo -e "\e[96m Installing PHP 8.0.x  \e[39m"
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo -y apt update
sudo -y apt install php8.0 
sudo apt -y install php-common php-mysql php-cgi php-mbstring php-curl 
sudo apt -y install php-gd php-xml php-xmlrpc php-pear php-fpm php-bcmath

# echo -e "\e[96m Installing MySQL server \e[39m"
# echo -e "\e[93m User: root, Password: toor \e[39m"
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password toor'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password toor'
sudo apt-get install -y mysql-server

mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;"
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;"
mysql -u root -proot -e "FLUSH PRIVILEGES;"

if [[ -f /vagrant/default.conf ]]; then
    cp /vagrant/default /etc/nginx/sites-available/default
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
fi

if [[ -f /vagrant/custom.conf ]]; then
    cp /vagrant/custom /etc/nginx/sites-available/custom 
    ln -s /etc/nginx/sites-available/custom /etc/nginx/sites-enabled/
fi

echo -e "\e[96m Installing Composer \e[39m"
curl -sS https://getcomposer.org/installer -o composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer


echo -e "\e[96m Installing Symfony \e[39m"
wget https://get.symfony.com/cli/installer -O - | bash
sudo mv /home/vagrant/.symfony/bin/symfony /usr/local/bin/symfony

echo -e "\e[96m NGINX  configuration syntax check \e[39m"
nginx -t

# Restart nginx server to reflect changes
service nginx restart

echo -e "\e[96m Check NGINX version  \e[39m"
nginx -v

echo -e "\e[96m Check PHP version  \e[39m"
php -v

echo -e "\e[96m Check the status of MySQL  \e[39m"
sudo service mysql status

echo -e "\e[96m Check MySQL version  \e[39m"
mysql --version

echo -e "\e[96m Check Composer version  \e[39m"
composer -V

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