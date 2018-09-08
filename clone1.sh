#!/bin/bash
echo "$1" | clone-vm7
virsh start rh7_node$1
expect <<  EOF
spawn virsh console rh7_node$1
expect "#"  {send "\r"}
expect "login:"  {send "root\r"}
expect "密码："  {send "123456\r"}
expect "#"  {send "nmcli connection add con-name eth3 ifname eth3 type ethernet\r"}
expect "#"       {send "nmcli connection modify eth3 ipv4.method manual ipv4.addresses  201.1.2.$2/24 connection.autoconnect yes\r"}
expect "#"  {send "nmcli connection up eth3\r"}
expect "#"  {send "yum-config-manager --add ftp://201.1.2.254/rhel7\r"}
expect "#"  {send "echo "gpgcheck=0" > /etc/yum.repos.d/201.1.2.254_rhel7.repo\r"}
expect "#"  {send "yum repolist\r"}
expect "#"  {send "exit\r"}
EOF
expect << EOF
spawn ssh-copy-id 201.1.2.$2
expect "yes"  {send "yes\r"}
expect "password:"  {send "123456\r"}
expect "#"  {send "exit\t"}
EOF
ssh -X 201.1.2.$2
