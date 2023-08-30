\e[33m="color"
\e[0m="nocolor"
log_file="/tmp/roboshop.log"

echo -e "\e[33mInstalling jaava packajes \e[0m"
yum install maven -y &>>log_file
echo -e "\e[33mCreate app directory \e[0m"
useradd roboshop &>>log_file
mkdir /app &>>log_file

echo -e "\e[33mDownload the app content \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>log_file
cd /app &>>log_file

echo -e "\e[33m Extract the application content\e[0m"
unzip /tmp/shipping.zip &>>log_file


#download the app dependencies
cd /app &>>log_file
mvn clean package &>>log_file
mv target/shipping-1.0.jar shipping.jar &>>log_file


echo -e "\e[33m Copying the service file\e[0m"
cp shipping.service /etc/systemd/system/shipping.service &>>log_file
systemctl daemon-reload &>>log_file
echo -e "\e[33mStart shipping services \e[0m"
systemctl enable shipping &>>log_file
systemctl start shipping &>>log_file

echo -e "\e[33mInstalling mysql \e[0m"
yum install mysql -y &>>log_file

echo -e "\e[33m Upload schema\e[0m"
mysql -h <mysql-dev.devopsb73.xyz> -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>log_file

echo -e "\e[33m Restart shipping\e[0m"
systemctl restart shipping &>>log_file