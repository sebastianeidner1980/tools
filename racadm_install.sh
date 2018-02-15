#!/bin/bash


wget_install=$(sudo yum search wget | grep "^wget" | wc -l)

#####
#checking if wget is installed
####
echo "Checking wget" 

if [ $wget_install -eq 1 ];then
 echo "wget is installed"
else
 echo "Install wget"
 sudo yum -y install wget
fi

status=$(curl -s --head -w %{http_code} http://linux.dell.com/repo/hardware/latest/bootstrap.cgi -o /dev/null)
if [ $status -eq 200 ];then
	echo "Enable Repos" 
	sudo wget -q -O - http://linux.dell.com/repo/hardware/latest/bootstrap.cgi | bash
	echo "Install Racadm and create Link"
	sudo yum -y install srvadmin-idrac7
	sudo ln -s /opt/dell/srvadmin/sbin/racadm /usr/sbin/racadm
fi

