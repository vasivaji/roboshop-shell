component=catalogue
color="\e[33m"
nocolor="\e[0m"
log_file=/tmp/roboshop.log

echo  -e "${color}Configuring nodejs repo ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>log_file

echo  -e "${color}installing node js ${nocolor}"
yum install nodejs -y &>>log_file

echo  -e "${color}add application user ${nocolor}"
useradd roboshop &>>log_file

echo  -e "${color}Create application directory ${nocolor}"
rm -rf /app &>>log_file
mkdir /app &>>log_file

echo  -e "${color}Downloading app content ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>log_file


cd /app &>>log_file

echo  -e "${color}extract app content ${nocolor}"
unzip /tmp/$component.zip &>>log_file

echo  -e "${color}Install nodejs dependencies ${nocolor}"
npm install &>>log_file

echo  -e "${color}Copying service file ${nocolor}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>log_file

echo  -e "${color}Start $conponent services ${nocolor}"
systemctl daemon-reload &>>log_file
systemctl enable $component &>>log_file
systemctl start $component &>>log_file

echo  -e "${color}copying mongodb repo file ${nocolor}"
 cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>log_file

echo  -e "${color}install mongodb client ${nocolor}"
yum install mongodb-org-shell -y &>>log_file

echo  -e "${color}load scheema ${nocolor}"
mongo --host mongodb-dev.devopsb73.xyz </app/schema/$component.js &>>log_file

