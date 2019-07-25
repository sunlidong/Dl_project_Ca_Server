#!/usr/bin/env bash
###IntermediaCA2
echo "create ca_msp_org2.sh starting"
######################################################################步骤一：启动 ca
echo "步骤一：启动 ca"
######################################################################步骤二：为org2.example.com准备msp

### enroll
fabric-ca-client enroll --csr.cn=org2.example.com \
						--csr.hosts=['org2.example.com'] \
						-M ./crypto-config/peerOrganizations/org2.example.com/msp \
						-u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
### config.yaml
path=./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/msp/config.yaml
echo "NodeOUs:"&>$path
echo "  Enable: true"&>>$path
echo "  ClientOUIdentifier:"&>>$path
echo "    Certificate: intermediatecerts/localhost-9056.pem"&>>$path
echo "    OrganizationalUnitIdentifier: client"&>>$path
echo "  PeerOUIdentifier:"&>>$path
echo "    Certificate: intermediatecerts/localhost-9056.pem"&>>$path
echo "    OrganizationalUnitIdentifier: peer"&>>$path
### list
fabric-ca-client affiliation list -M ./crypto-config/peerOrganizations/org2.example.com/msp -u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
###
fabric-ca-client affiliation remove --force org2 -M ./crypto-config/peerOrganizations/org2.example.com/msp -u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
fabric-ca-client affiliation remove --force org2 -M ./crypto-config/peerOrganizations/org2.example.com/msp -u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
### add
fabric-ca-client affiliation add com -M ./crypto-config/peerOrganizations/org2.example.com/msp -u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
fabric-ca-client affiliation add com.example -M ./crypto-config/peerOrganizations/org2.example.com/msp -u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
fabric-ca-client affiliation add com.example.org2 -M ./crypto-config/peerOrganizations/org2.example.com/msp -u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
echo "步骤二：为org2.example.com准备msp"
######################################################################步骤三：注册org2.example.com的管理员Admin@org2.example.com

### register
fabric-ca-client register 	--id.name Admin@org2.example.com \
							--id.type client \
							--id.affiliation "com.example.org2" \
							--id.attrs '"hf.Registrar.Roles=client,orderer,peer,user","hf.Registrar.DelegateRoles=client,orderer,peer,user",hf.Registrar.Attributes=*,hf.GenCRL=true,hf.Revoker=true,hf.AffiliationMgr=true,hf.IntermediateCA=true,role=admin:ecert' \
							--id.secret=123456 \
							--csr.cn=org2.example.com \
							--csr.hosts=['org2.example.com'] \
							-M ./crypto-config/peerOrganizations/org2.example.com/msp \
							-u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -u http://Admin@org2.example.com:123456@localhost:9056 \
						--csr.cn=org2.example.com \
						--csr.hosts=['org2.example.com'] \
						-M ./crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp --home ./fabric-ca-client
### mkdir mulu  admin admincerts
mkdir ./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/admincerts
### cp
cp 	./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/admincerts
### mkdir msp admincerts
mkdir ./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/msp/admincerts
### cp
cp 	./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/msp/admincerts
echo "步骤三：注册org2.example.com的管理员Admin@org2.example.com"
######################################################################步骤四：为peer0.org2.example.com准备msp

### register
fabric-ca-client register 	--id.name peer0.org2.example.com \
							--id.type peer \
							--id.affiliation "com.example.org2" \
							--id.attrs '"role=peer",ecert=true' \
							--id.secret=123456 \
							--csr.cn=peer0.org2.example.com \
							--csr.hosts=['peer0.org2.example.com'] \
							-M ./crypto-config/peerOrganizations/org2.example.com/msp \
							-u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -u http://peer0.org2.example.com:123456@localhost:9056 \
						--csr.cn=peer0.org2.example.com \
						--csr.hosts=['peer0.org2.example.com'] \
						-M ./crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp --home ./fabric-ca-client

### mkdir
mkdir ./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/admincerts

### cp
cp 	./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/admincerts

######################################################################步骤五：为peer1.org2.example.com准备msp

### register
fabric-ca-client register 	--id.name peer1.org2.example.com \
							--id.type peer \
							--id.affiliation "com.example.org2" \
							--id.attrs '"role=peer",ecert=true' \
							--id.secret=123456 \
							--csr.cn=peer1.org2.example.com \
							--csr.hosts=['peer1.org2.example.com'] \
							-M ./crypto-config/peerOrganizations/org2.example.com/msp \
							-u http://admin:adminpw@localhost:9056 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -u http://peer1.org2.example.com:123456@localhost:9056 \
						--csr.cn=peer1.org2.example.com \
						--csr.hosts=['peer1.org2.example.com'] \
						-M ./crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp --home ./fabric-ca-client
### mkdir
mkdir ./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/admincerts
### cp
cp ./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/cert.pem ./fabric-ca-client/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/admincerts
