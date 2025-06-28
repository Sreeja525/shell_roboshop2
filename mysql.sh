#!/bin/bash
source ./common.sh
check_root
app_name=mysql

echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD

dnf install mysql-server -y &>>$LOG_FILE

systemctl enable mysqld
systemctl start mysqld  

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD
VALIDATE $? "Setting MySQL root password"

print_time