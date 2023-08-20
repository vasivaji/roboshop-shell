
echo  -e "\e[33mConfiguring nodejs repo \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo  -e "\e[33minstalling node js \e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo  -e "\e[33madd application user \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo  -e "\e[33mCreate application directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo  -e "\e[33mDownloading app content \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log


cd /app &>>/tmp/roboshop.log

echo  -e "\e[33mextract app content \e[0m"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log

echo  -e "\e[33mInstall nodejs dependencies \e[0m"
npm install &>>/tmp/roboshop.log

echo  -e "\e[33mCopying service file \e[0m"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo  -e "\e[33mStart catalogue services \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl start catalogue &>>/tmp/roboshop.log

echo  -e "\e[33mcopying mongodb repo file \e[0m"
 cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo  -e "\e[33minstall mongodb client \e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo  -e "\e[33mload scheema \e[0m"
mongo --host mongodb-dev.devopsb73.xyz </app/schema/catalogue.js &>>/tmp/roboshop.log

