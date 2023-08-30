source common.sh


component=redis
echo -e "\e[33minstalling redis repo file \e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
yum module enable ${component}:remi-6.2 -y

echo -e "\e[33minstalling redis services \e[0m"
yum install ${component} -y

echo -e "\e[33mupdate redis listen address \e[0m"
sed -i -e "s/127.0.0.1/ 0.0.0.0"  /etc/${component}.conf  /etc/redis/${component}.conf

echo -e "\e[36mStarting Redis[0m"
systemctl enable ${component}
systemctl start ${component}