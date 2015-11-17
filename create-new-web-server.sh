#!/bin/bash

# usage: create-new-web-server.sh server_name [wine_volume_name]

if [ $# -lt 1 ]
then
    echo "usage: create-new-web-server.sh server_name [wine_volume_name] "
    exit
fi

server_name=$1
wine_volume_name=""
wine_volume_size=""

if [ $# -gt 1 ]
then
    wine_volume_name=$2
    wine_volume_size="75"
fi

#create the server and read the IP address information
privip=""
regex="Private IP:\s*(.*)"
while IFS= read -r line
do
    [[ $line =~ $regex ]]
    if [ ! -z "${BASH_REMATCH[1]}" ]
        then
        privip="${BASH_REMATCH[1]}"
    fi

    echo $line

done < <(python create-server.py ${server_name} "general1-2" "2GB-cluster-clone-image" ${wine_volume_name} ${wine_volume_size})

if [ -z $privip ]
    then
    echo "Unable to obtain a private IP address from the new server. Cannot continue"
    exit 1
fi

#wait for the server to settle "installing software"
sleep 2m

#we have the ip address. send the remote commands to format and mount the volume
ssh root@${privip} < format-and-mount-volume.sh

#add the lsync configuration to our local configs
python generate-lsync-config.py ${privip} >> /etc/lsyncd.conf

#restart lsyncd
service lsyncd restart
