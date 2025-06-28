#!/bin/bash

source ./common.sh
app_name=mongodb
check_root

cp mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying MongoDB repo"



dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing mongodb server"

systemctl enable mongod  &>>$LOG_FILE
VALIDATE $? " enabling mongodb-org"

systemctl start mongod
VALIDATE $? "starting mongodb-org"


sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "updating listen address"

systemctl restart mongod 
VALIDATE $? "restarting mongodb"

print_time