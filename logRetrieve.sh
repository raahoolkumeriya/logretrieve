#!/bin/bash

#--------------------------------------------------------------------------
#	Date: 	Fri Apr 12 21:09:55 IST 2019
#	Author: Rahul Kumeriya
#	Desc: 	System Log Retrieve
#	Usages: ./logsRetrieve.sh [OPTIONS]
#		OPTIONS  
#			-l,--logPath      Absolute log path 
#			-s,--startTime    date in the format "YYYY-MM-DD"
#			-e,--endTime      date in the format "YYYY-MM-DD"
# 			-h,--host	  host ip address or dns name
#-------------------------------------------------------------------------

#-------------------- below default variables can be put in conf file ------------->
LINUX_FLAVOURS=`cat /etc/os-release | grep "^ID=" | sed 's/ID=//g'`    
logPath=/var/log                                              # -----> Default log path 
startTime=`date -d '1 day ago' +'%Y-%m-%d'`                   # -----> Default startTime 1 day ago
endTime=`date +'%Y-%m-%d'` 				      # -----> Default endTime to current date
host=localhost  					      # -----> default to localhost
#---------- if config hold default values then load it with . <config_name> or source <config_name>


echo $startTime
