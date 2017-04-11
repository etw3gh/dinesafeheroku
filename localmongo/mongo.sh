#!/bin/bash
# connect to mongo instance hosted on an aws server
# set $OC_MONGO_{USER|PWD|IP|PORT|DB} in .bashrc and Heroku settings
mongo -u $OC_DS_USER -p $OC_MONGO_PWD $OC_MONGO_IP:$OC_MONGO_PORT/$OC_MONGO_DS
