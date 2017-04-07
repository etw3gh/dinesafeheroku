#!/bin/bash
# connect to mongo instance hosted on an aws server
# set $OC_MONGO-{USER|PWD|IP|PORT|DB} in .bashrc
mongo -u $OC_MONGO_USER -p $OC_MONGO_PWD $OC_MONGO_IP:$OC_MONGO_PORT/$OC_MONGO_DB
