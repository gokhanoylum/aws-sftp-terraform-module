#!/bin/bash
while [ -z "$DEVICE" ]; do
  DEVICE=$(lsblk -dpno NAME,FSTYPE | grep -v 'part' | awk '$2=="" {print $1}' | grep -v 'nvme0n1' | head -n1)
  sleep 5
done

mkfs -t ext4 $DEVICE

groupadd sftp_group
useradd -m -g sftp_group -s /usr/sbin/nologin sftp_user
echo "sftp_user:**********************************" | chpasswd

MOUNT_POINT="/home/sftp_user/uploads"
mkdir -p $MOUNT_POINT
mount $DEVICE $MOUNT_POINT

UUID=$(blkid -s UUID -o value $DEVICE)
echo "UUID=$UUID $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab

chown root:root /home/sftp_user
chmod 755 /home/sftp_user
chown sftp_user:sftp_group $MOUNT_POINT

cat <<EOT >> /etc/ssh/sshd_config
Match Group sftp_group
    ChrootDirectory /home/sftp_user
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no
    PasswordAuthentication yes
EOT

systemctl restart ssh
