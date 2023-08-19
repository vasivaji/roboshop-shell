echo -e "\e[33mcopying  mongodb repo file\e[0m"

cp /etc/yum.repos.d/mongo.repo

echo -e "\e[33mInstalling mongodb\e[0m"
yum install mongodb-org -y

echo -e "\e[33menable mongodb server\e[0m"
systemctl enable mongodb

#modify the config file
echo -e "\e[33mstart mongodb server\e[0m"
systemctl restart mongod