#!/bin/bash

echo "VestaCP Transfer Script version: 0.1 Step 1"

printf "\n"

echo "This bash script works firstly add remote host's key to your ssh secrets directory for passwordless login."

read -p 'Please enter remote host user :' remoteuser

read -p 'Please enter remote host ip :' remotehost

ssh-copy-id $remoteuser@$remotehost -f

echo "If script fails in this step you can try ssh-keygen command, and try again. When you type ssh-keygen command in your cli put everything default (like Windows; next, next, next)"

printf "\n"

read -p 'Please enter website domain do you want to transfer new host (like: example.com) \
(If you only want change your domain address you can type same hosts ip adress): ' hostsite

read -p 'Enter remote website domain to transfer files: ' remotesite

rsync -av --progress --inplace --rsh='ssh -p 22' /home/admin/web/$hostsite/public_html/* $remoteuser@$remotehost:/home/admin/web/$remotesite/public_html/

sleep 5

printf "\n"

echo "Its time to dump your database file ..."

printf "\n"

read -p 'Please enter your database name: ' dbname

read -p 'Please enter your database user: ' dbuser

printf "\n"

mysqldump -u $dbuser -p $dbuser > ./$remotesite.sql

sleep 5

rsync -av --progress --inplace --rsh='ssh -p 22' ./$remotesite.sql $remoteuser@$remotehost:/home/admin/web/$remotesite/

echo "Looks like everything is done. You should launch second script on remote host."

printf "\n"

echo "Transfer script now creating environment files."

printf "\n"

cp ./db_env.txt ./db_$remotesite.txt

sed -i -e 's/siteone/$hostsite/g' ./db_$remotesite.txt

printf "\n"

rsync -av --progress --inplace --rsh='ssh -p 22' ./db_$remotesite.txt $remoteuser@$remotehost:/home/admin/web/$remotesite/

sleep 5

rsync -av --progress --inplace --rsh='ssh -p 22' ./step2.sh $remoteuser@$remotehost:/home/admin/web/$remotesite/

sleep 5

touch ./_transferfile

echo "!#/bin/bash" >> ./_transferfile

echo "site=$remotesite" >> ./_transferfile

rsync -av --progress --inplace --rsh='ssh -p 22' ./_transferfile $remoteuser@$remotehost:/tmp/

echo "Transfering jobs are done, now step 2 jobs are launching..."

ssh $remoteuser@$remotehost 'chmod +x /tmp/_transferfile; bash /tmp/_transferfile; chmod +x /home/admin/web/$site/step2.sh; bash /home/admin/web/$site/step2.sh; rm -f /tmp/_transferfile'

sleep 10

rm -f ./_transferfile

