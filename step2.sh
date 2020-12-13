#!/bin/bash

echo "VestaCP Transfer Script version: 0.1 Step 2"

chown -R admin:admin ./public_html/

read -p 'Please enter your new domain (without https://): ' newdomain

read -p 'Please enter new database name: ' dbname

read -p 'Please enter new database user: ' dbuser

read -sp 'Please enter $dbuser password' dbpass

mysql -u$dbuser -p'$dbpass' $dbname < $newdomain.sql 

sleep 5

mysql -u$dbuser -p'$dbpass' $dbname < db_$newdomain.txt

sleep 10



