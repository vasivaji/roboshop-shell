color="\e[33m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path=" app"
app_presetup(){
echo  -e "${color}add application user ${nocolor}"
  useradd roboshop &>>log_file
  if[ $? -e 0]; then
    echo success
    else
    echo failure
    fi
 echo  -e "${color}Create application directory ${nocolor}"
  rm -rf ${app_path} &>>log_file
  if[ $? -e 0]; then
    echo success
    else
    echo failure
    fi
  mkdir ${app_path} &>>log_file

  if[ $? -e 0]; then
  echo success
  else
  echo failure
  fi


  echo  -e "${color}Downloading app content ${nocolor}"
    curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>log_file
 cd ${app_path} &>>log_file
 if[ $? -e 0]; then
   echo success
   else
   echo failure
   fi

  echo  -e "${color}extract app content ${nocolor}"
  unzip /tmp/$component.zip &>>log_file
  if[ $? -e 0]; then
    echo success
    else
    echo failure
    fi

}

systemd_setup(){
   echo -e "${color}Copying the service file${nocolor}"
    cp $component.service /etc/systemd/system/$component.service &>>log_file
    if[ $? -e 0]; then
      echo success
      else
      echo failure
      fi
    systemctl daemon-reload &>>log_file
    echo -e "${color}Start shipping services ${nocolor}"
    systemctl enable $component &>>log_file
    systemctl start $component &>>log_file
    if[ $? -e 0]; then
      echo success
      else
      echo failure
      fi
}


nodejs(){
  echo  -e "${color}Configuring nodejs repo ${nocolor}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>log_file

  echo  -e "${color}installing node js ${nocolor}"
  yum install nodejs -y &>>log_file

 app_presetup

  echo  -e "${color}Install nodejs dependencies ${nocolor}"
  npm install &>>log_file

  systemd_setup
}

mongo_scheema_setup(){
  echo  -e "${color}copying mongodb repo file ${nocolor}"
   cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>log_file

  echo  -e "${color}install mongodb client ${nocolor}"
  yum install mongodb-org-shell -y &>>log_file

  echo  -e "${color}load scheema ${nocolor}"
  mongo --host mongodb-dev.devopsb73.xyz <${app_path}/schema/$component.js &>>log_file
}

mysql_schema_setup(){
   echo -e "${color}Installing mysql ${nocolor}"
    yum install mysql -y &>>log_file

    echo -e "${color} Upload schema${nocolor}"
    mysql -h <mysql-dev.devopsb73.xyz> -uroot -pRoboShop@1 < ${app_path}/schema/shipping.sql &>>log_file

    echo -e "${color} Restart shipping${nocolor}"
    systemctl restart $component &>>log_file
}


maven(){
  echo -e "${color}Installing jaava packajes ${nocolor}"
  yum install maven -y &>>log_file

 app_presetup

  #download the app dependencies
  echo -e "${color} download the app dependencies${nocolor}"
  cd ${app_path} &>>log_file
  mvn clean package &>>log_file
  mv target/$component-1.0.jar $component.jar &>>log_file

 systemd_setup

 mysql_schema_setup
}