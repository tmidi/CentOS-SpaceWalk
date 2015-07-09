#!/bin/bash -x
# SpaceWalk bash installation on CentOS 7
# Spacewalk installed version : spacewalk-repo-2.3-4
# By Taleeb midi

# Setup Pause function
function pause(){
   read -p "$*"
}

# !!!! Function to get IP address (change the "2p" part of SED to get the IP address you want use):
# If not sure how to edit this function, please comment the following line(12), as well as lines (18-20), then edit /etc/host with you hostname and IP Address.
IPADDR="$(ip addr | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" | sed -n '2p')"

# 1 - set hostname to spacewalk; !!!! Change it to whatever hostname you want to use !!!!!!
hostname spacewalk

# 2 - edit /etc/hosts
cat >> /etc/hosts << EOF
spacewalk  $IPADDR
EOF

#Make sure you can resolve the hostname 
ping $(hostname -f) -c4

# Fully update the OS
sudo yum update -y

# Install EPEL release
sudo yum install epel-release -y

# Install JPackage 5.0

cat > /etc/yum.repos.d/jpackage-generic.repo << EOF
[jpackage-generic]
name=JPackage generic
#baseurl=http://mirrors.dotsrc.org/pub/jpackage/5.0/generic/free/
mirrorlist=http://www.jpackage.org/mirrorlist.php?dist=generic&type=free&release=5.0
enabled=1
gpgcheck=1
gpgkey=http://www.jpackage.org/jpackage.asc
EOF

#install SpaceWalk repo
sudo yum install -y http://yum.spacewalkproject.org/2.3/RHEL/7/x86_64/spacewalk-repo-2.3-4.el7.noarch.rpm

# For this install, I will be using Postgre SQL

yum install -y spacewalk-setup-postgresql

# Configure firewalld to allow http and https then reload the service:

sudo firewall-cmd --add-service=http --permanent; sudo firewall-cmd --add-service=http --permanent; firewalld-cmd --reload

# Install spacewalk-postgresql
sudo yum install -y spacewalk-postgresql

# Setup SpaceWalk
spacewalk-setup --disconnected

pause 'Press [Enter] key to continue...'


echo "Browse to the above  ^^^ URL ^^^ to manage your install"
echo "All is done here"
echo "Have a good day"
# Remove Exec permissions from this file
chmod -x SpaceWalk-CentOS7.sh