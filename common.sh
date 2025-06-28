#!/bin/bash

START_TIME= $(date +%s)
USERID=$( id -u )
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER=/var/log/shellscript-logs
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD
echo "creating $LOGS_FOLDER"


mkdir -p $LOGS_FOLDER # -p --> It creates parent directories as needed (e.g., if /var/log/myapp/logs doesn’t exist, it will create the full path).
echo "script started executed at : $(date)" | tee -a  $LOG_FILE 


check_root() {

    if [ $USERID -ne 0 ]
    then 
        echo -e "$R ERROR: Please run with root access $N" | tee -a $LOG_FILE
        exit 1 #give other than 0 upto 127
    else    
        echo -e "$G you are running with root access $N" | tee -a $LOG_FILE
    fi
}
VALIDATE(){
    if [ $1 -eq 0 ]
    then    
        echo -e "$G $2 is.... SUCCESS $N " | tee -a $LOG_FILE
    else
        echo  -e " $R  $2 is failure $N" | tee -a $LOG_FILE
        exit 1 #give other than 0 upto 127
    fi
}


nodejs_setup(){

    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? " disabling nodejs"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? " enabling nodejs"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? " installing nodejs"

    npm install &>>$LOG_FILE
    VALIDATE $? "downloading dependencies"
}
app_setup(){
    id roboshop
    if [ $? -eq 0 ]
    then
        echo "roboshop user is already exists"
    else
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        VALIDATE $? "creating system user"
    fi

    mkdir -p /app 
    VALIDATE $? "creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "Downloading $app_name"

    cd /app
    rm -rf /app/*

    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "unzipping $app_name"
}

systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copying $app_name service"

    systemctl daemon-reload &>>$LOG_FILE
    systemctl enable $app_name  &>>$LOG_FILE
    systemctl start $app_name
    VALIDATE $? "Starting $app_name"
}

print_time(){
     END_TIME=$(date +%s)
     TOTAL_TIME=$(($END_TIME - $START_TIME))
     echo -e "Script executed successfully, $Y Time taken: $TOTAL_TIME seconds $N"
}