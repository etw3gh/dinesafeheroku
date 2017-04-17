#!/bin/bash
# connect to mongo instance hosted on an aws server
# set $OC_MONGO_{USER|PWD|IP|PORT|DB} in .bashrc and Heroku settings

if [ "$1"  = "--admin" ] || [ "$1"  = "-a" ]
then
  USER=$OC_MONGO_USER   
  DB=$OC_MONGO_DB   
else
  USER=$OC_DS_USER   
  DB=$OC_MONGO_DS
fi

mongo -u $USER -p $OC_MONGO_PWD $OC_MONGO_IP:$OC_MONGO_PORT/$DB
