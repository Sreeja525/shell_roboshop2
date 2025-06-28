#!/bin/bash
source ./common.sh
check_root
app_name=redis

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling Default Redis version"
dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling Redis:7"

dnf install redis -y  &>>$LOG_FILE
VALIDATE $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Edited redis.conf to accept remote connections"

systemctl enable redis 
VALIDATE $? "Enabling Redis"

systemctl start redis 
VALIDATE $? "Started Redis"

print_time