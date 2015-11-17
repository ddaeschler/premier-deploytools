# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\t\([\+0-9a-zA-Z]*\)[ \t].*/\1/' << EOF | fdisk "/dev/xvdb"
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
    # default - entire disk
  n # new partition
  w # write the partition table
  q # and we're done
EOF

mkfs.ext4 /dev/xvdb1
echo "/dev/xvdb1    /var/vhosts/vol-winesites ext3 defaults,noatime,barrier=0 0 0" >> /etc/fstab
mount /dev/xvdb1
