#!/usr/bin/env bash

###
./scripts/clear.sh
### 1. Create Ca Container
docker-compose -f ./dockerfile/docker-compose-ca.yaml -p ca up -d

### 2. orderer  msp tls
./scripts/ca_msp_orderer.sh
./scripts/ca_tls_orderer.sh

### 3. org1  msp tls
./scripts/ca_msp_org1.sh
./scripts/ca_tls_org1.sh

### 4. org2  msp tls
./scripts/ca_msp_org2.sh
./scripts/ca_tls_org2.sh
###

echo "create msp tls is successful"
