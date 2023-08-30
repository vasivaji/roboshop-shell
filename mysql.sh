source common.sh

yum module disable mysql -y &>>/tmp/roboshop.log

cp mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

yum install mysql-community-server -y &>>/tmp/roboshop.log

systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log

mysql -uroot -pRoboShop@1 &>>/tmp/roboshop.log