echo -e "\e[33mCopying  mongodb repo file\e[0m"

cp mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[33mInstalling mongodb\e[0m"
yum install mongodb-org -y &>>/tmp/roboshop.log


echo -e "\e[33mupdate mongodb listen address \e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongodb.conf

echo -e "\e[33mEnable mongodb server\e[0m"
systemctl enable mongodb &>>/tmp/roboshop.log

echo -e "\e[33mStart mongodb server\e[0m"
systemctl restart mongod &>>/tmp/roboshop.log