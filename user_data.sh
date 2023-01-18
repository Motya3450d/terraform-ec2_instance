yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo service httpd start
sudo chkconfig httpd on