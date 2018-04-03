#!/usr/bin/env bash

### Exit script on error
set -e

echo "********** Install SSHD **********"
apt-get install -y openssh-server
mkdir /var/run/sshd
# Change root password below
#echo 'root:password' | chpasswd
echo root:$MYPSD | chpasswd
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

