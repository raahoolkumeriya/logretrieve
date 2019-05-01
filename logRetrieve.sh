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



# Verification of login User. Condition pass for ROOT user only. 
if [[ $EUID -ne 0 ]] 
then 
	echo "This script must be run as root."
	exit 1;
fi

# Verification of OS Distribution 
if [[ -f /etc/os-release ]]
then
	if [ $LINUX_FLAVOURS = "ubuntu" ] || [ $LINUX_FLAVOURS = "rhel" ]     # currently check for ubuntu and RHEL distrubution only 
	then
		echo "I am using Linux flavour : $LINUX_FLAVOURS "
	else 
		echo "This script only works for Ubuntu, RHEL flavours"
		exit 1;
	fi
fi

# OPTIONS for script with below loop
while [ -n "$1" ] 
do 
	case "$1" in
		-l|--logPath)
		 	logPath=$2;
			shift 2 
		;;
		-s|--startTime)
			startTime=$2
			 
			shift 2
		;;
		-e|--endTime)
			endTime=$2
			shift 2 
		;;
		-h|--host)
			host=$2
			shift 2 
		;;
		--) shift
			break;;
		*)      echo "$1 is not a option"
			exit 1
		;;
	esac
done

#ls -lart $logPath*log | awk '$6 == "$(date --date=$startTime +%b)" && $7 >= "$(date --date=$startTime +%d)" { print $9 } ' 

if [ $host = "localhost" ]
then
	find $logPath/*log -type f -newermt $startTime ! -newermt $endTime -exec ls -lart {} \;
else
	echo ----------------------------
	echo "Enter User Credentials  "
	echo ----------------------------
	echo  -n " Username : " 
	read username
#ssh -T -q -i /home/raahool/.ssh/id_rsa  $username@$host<<EOF
ssh -q $username@$host<<EOF
	find ${logPath}/*log -type f -newermt $startTime ! -newermt $endTime -exec ls -lart {} \;
EOF
fi

exit 0
