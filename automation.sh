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

#Task3
inventory_file="/var/www/html/inventory.html"
cron_file="/etc/cron.d/automation"
if [ ! -f "$inventory_file" ]
then
touch "$inventory_file"
echo "Log Type&emsp;&emsp;&emsp;&emsp;Time Created&emsp;&emsp;&emsp;&emsp;Type&emsp;&emsp;&emsp;&emsp;Size&emsp;&emsp;&emsp;&emsp;<br>" >> "$inventory_file"
fi
echo -e "<br><br>" >> $inventory_file

echo "http-d&emsp;&emsp;&emsp;&emsp;&nbsp;"$timestamp"&emsp;&emsp;&nbsp;&nbsp;tar&emsp;&emsp;&emsp;&emsp;&emsp;"$file_size"&emsp;&emsp;&emsp;<br>" >> "$inventory_file"

if [ ! -f "$cron_file" ]
then
touch "$cron_file"
echo "00 00 * * * root /root/Automation_Project/automation.sh" > "$cron_file"
fi