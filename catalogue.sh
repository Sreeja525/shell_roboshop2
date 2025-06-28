#!/bin/bash

source ./common.sh
app_name=catalogue

check_root

app_setup

nodejs_setup

systemd_setup

cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? " copying mongo repo"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "installing mongodb"

STATUS=$(mongosh --host mongodb.sreeja.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ "$STATUS" -lt 0 ]
then
    mongosh --host mongodb.sreeja.site </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi

print_time