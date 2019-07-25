#!/usr/bin/env bash
sudo docker rm -f $(sudo docker ps -aq)
sudo docker network prune
sudo docker volume prune
##
rm -rf  data/
rm -rf  config/
rm -rf  fabric-ca-client/
##

echo "clear is successful "
