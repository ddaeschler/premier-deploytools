(echo o; echo n; echo p; echo 1; echo ; echo; echo w) | fdisk "/dev/xvdb"
mkfs.ext3 /dev/xvdb1
mount /dev/xvdb1
