#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COMPOSE=/opt/green/bin/docker-compose
COMPOSE_FILE=/build/docker-joomla/docker-compose.yml
VOLUME_BASE=/data/www 
S_HOST=www
S_DEV=wlan0
S_DOMAIN=urbzdk.ba
S_HOST_IP=${smtp_ip:-192.168.14.30}
S_DNS_HOST_IP=${dns_lan_ip:-192.168.14.250}
CT_NAME=www-urbzdk

# add static ip 
  sudo ip addr show | grep $S_HOST_IP || \
  sudo ip addr add $S_HOST_IP/24 dev $S_DEV



create_volumes()
{
DATASET=/data/www
VOLUME_QUOTA=20G
ZCHECK=$(zfs list | grep -ic build)

  if [$ZCHECK -gt 0 ]
    echo $DATASET exists
    else
    echo $DATASET does not exist, createing.........
    sudo zfs create -o quota=$VOLUME_QUOTA -o mountpoint=$VOLUME_BASE/$S_REALM/$S_HOST $DATASET
  fi 
}

create_volumes

# run dokcer-compose 

  $COMPOSE -d $COMPOSE_FILE up


