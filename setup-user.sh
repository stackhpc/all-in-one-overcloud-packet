#!/bin/bash

useradd -m -G wheel -p $(echo "thisismypassword" | openssl passwd -1 -stdin) -s /bin/bash lab

cat <<EOF >> /etc/ssh/sshd_config

Match user lab
  PasswordAuthentication yes

EOF

cat <<EOF >> /etc/sudoers

%wheel  ALL=(ALL)       NOPASSWD: ALL

EOF

systemctl restart sshd.service
