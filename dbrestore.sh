#!/usr/bin/env bash

USER="root"
PASSWORD="toor"

if ls /vagrant/database/*.sql >/dev/null 2>&1;
then
    databases=`ls -1 /vagrant/database/*.sql`
    for db in $databases; do
        #ndb = basename $db .sql
        ndb=${db%.*}
        ndb=${a##*/}
        echo "Importing "${db##*/}" ..."
        echo $ndb
        sudo mysql -u $USER -p$PASSWORD $ndb < $db
        echo -e "\e[96m Database successfully restored  \e[39m"
    done
else
    echo -e "\e[96m No databases  \e[39m"
fi