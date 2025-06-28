#!/bin/bash
source ./common.sh
check_root


dnf module disable nginx -y 
VALIDATE $? "disbaling nginx"

dnf module enable nginx:1.24 -y 
VALIDATE $? "enabling nginx"

dnf install nginx -y 
VALIDATE $? "installing nginx"

systemctl enable nginx 
systemctl start nginx 
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* 

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip 
VALIDATE $? "downloading web content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip 
VALIDATE $? "unzipping web content"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "cpoying nginx conf file"

systemctl restart nginx 
VALIDATE $? "restarting nginx"

print_time