#!/bin/bash

useradd -m -G wheel -p $(echo "thisismypassword" | openssl passwd -1 -stdin) -s /bin/bash lab

cat <<EOF >> /etc/ssh/sshd_config

Match user lab
  PasswordAuthentication yes

EOF

systemctl restart sshd.service

cat <<EOF >> /etc/sudoers

%wheel  ALL=(ALL)       NOPASSWD: ALL

EOF

cat <<EOF > /etc/motd

Welcome to the Kayobe Lab!

You may want to change your password immediately.

To bootstrap Kayobe all-in-one overcloud, run:

    bash ~/stack-with-magnum.sh

Once this is complete, use the OpenStack environment as follows:

    source ~/adminrc.sh
    openstack coe cluster list

EOF
