#!/bin/bash
sudo yum -y update
sudo yum install -y httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo systemctl start httpd.service
sudo systemctl enable httpd.service