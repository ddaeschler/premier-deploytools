#!/bin/bash

# usage: create-new-web-server.sh server_name [wine_volume_name]

if [ $# -lt 2 ]
then
    echo "usage: create-new-web-server.sh server_name [wine_volume_name] "
    exit
fi

server_name=$1
wine_volume_name=""
wine_volume_size=""

if [ $# -gt 2 ]
then
    wine_volume_name=$2
    wine_volume_size="75"
fi

#create the server
python create-server.py ${server_name} "general1-2" "2GB-cluster-clone-image" ${wine_volume_name} ${wine_volume_size}

#retrieve the IP address
