#!/usr/bin/env bash

USER="root"
PASSWORD="toor"

databases=`mysql -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "sys" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != "phpmyadmin" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        sudo mysqldump -u $USER -p$PASSWORD --databases $db > /vagrant/database/$db.sql
        echo -e "\e[96m Database successfully backed up \e[39m"
    fi
done