#!/bin/bash
echo "$1" | clone-vm7
virsh start rh7_node$1
expect <<  EOF
spawn virsh console rh7_node$1
expect "#"  {send "\r"}
expect "login:"  {send "root\r"}
expect "密码："  {send "123456\r"}
expect "#"       {send "nmcli connection modify eth0 ipv4.method manual ipv4.addresses  192.168.4.$2/24 connection.autoconnect yes\r"}
expect "#"  {send "nmcli connection up eth0\r"}
expect "#"  {send "yum-config-manager --add ftp://192.168.4.254/rhel7\r"}
expect "#"  {send "echo "gpgcheck=0" > /etc/yum.repos.d/192.168.4.254_rhel7.repo\r"}
expect "#"  {send "yum repolist\r"}
expect "#"  {send "exit\r"}
EOF
expect << EOF
spawn ssh-copy-id 192.168.4.$2
expect "yes"  {send "yes\r"}
expect "password:"  {send "123456\r"}
expect "#"  {send "exit\t"}
EOF


