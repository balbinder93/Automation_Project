#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
myname=balbinder
fileName=${myname}-httpd-logs-${timestamp}.tar
s3_bucket=upgrad-balbinder
sudo apt update -y
if echo dpkg --get-selections | grep -q "apache2"
then
	echo "Already Installed"
else
	sudo apt install apache2 -y
fi

if systemctl is-active apache2
then
	echo "Already running"
else
	sudo service apache2 start
fi
if systemctl is-enabled apache2
then
	echo "Already enabled"
else
	sudo systemctl enable apache2
fi
tar -cvf /tmp/${fileName} /var/log/apache2/*.log

aws s3 \
cp /tmp/${fileName} \
s3://${s3_bucket}/${fileName}

