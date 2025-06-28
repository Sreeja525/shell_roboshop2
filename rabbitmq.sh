#!/bin/bash
source ./common.sh
check_root
app_name=rabbitmq

app_name=rabbitmq

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "copying repo"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "installing rabbitmq"


systemctl enable rabbitmq-server
VALIDATE $? "enabling rabbitmq"

systemctl start rabbitmq-server
VALIDATE $? "starting rabbitmq"


rabbitmqctl add_user roboshop roboshop123 
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

print_time