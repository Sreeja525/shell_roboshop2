#!/bin/bash
source ./common.sh
check_root
app_name=shipping

app_setup
maven_setup
systemd_setup

dnf install mysql -y 
VALIDATE $? "Install MySQL"

#echo "Please enter root password to setup"
#read -s MYSQL_ROOT_PASSWORD
pwd
mysql -h mysql.sreeja.site -u root -pRoboShop@1 -e 'use cities'
if [ $? -ne 0 ]
then
    mysql -h mysql.sreeja.site -uroot -pRoboShop@1 < /app/db/schema.sql 
    mysql -h mysql.sreeja.site -uroot -pRoboShop@1 < /app/db/app-user.sql 
    mysql -h mysql.sreeja.site -uroot -pRoboShop@1 < /app/db/master-data.sql
    VALIDATE $? "Loading data into MySQL"
else
    echo -e "Data is already loaded into MySQL ... $Y SKIPPING $N"
fi

print_time