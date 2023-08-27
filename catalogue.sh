component=catalogue
color="\e[33m"
nocolor="\e[0m"\

echo  -e "${color}Configuring nodejs repo ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo  -e "${color}installing node js ${nocolor}"
yum install nodejs -y &>>/tmp/roboshop.log

echo  -e "${color}add application user ${nocolor}"
useradd roboshop &>>/tmp/roboshop.log

echo  -e "${color}Create application directory ${nocolor}"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo  -e "${color}Downloading app content ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>/tmp/roboshop.log


cd /app &>>/tmp/roboshop.log

echo  -e "${color}extract app content ${nocolor}"
unzip /tmp/$component.zip &>>/tmp/roboshop.log

echo  -e "${color}Install nodejs dependencies ${nocolor}"
npm install &>>/tmp/roboshop.log

echo  -e "${color}Copying service file ${nocolor}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>/tmp/roboshop.log

echo  -e "${color}Start $conponent services ${nocolor}"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable $component &>>/tmp/roboshop.log
systemctl start $component &>>/tmp/roboshop.log

echo  -e "${color}copying mongodb repo file ${nocolor}"
 cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo  -e "${color}install mongodb client ${nocolor}"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo  -e "${color}load scheema ${nocolor}"
mongo --host mongodb-dev.devopsb73.xyz </app/schema/$component.js &>>/tmp/roboshop.log

