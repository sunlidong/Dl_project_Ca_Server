#!/usr/bin/env bash
echo "create ca_tls_org1.sh starting"
######################################################################步骤一：启动 ca
echo "步骤一：启动 tlstmp_ca1"

fabric-ca-client enroll --csr.cn=org1.example.com \
						--csr.hosts=['org1.example.com'] \
						-M ./crypto-config/peerOrganizations/org1.example.com/tlstmp \
						-u http://admin:adminpw@localhost:8055 --home ./fabric-ca-client
######################################################################步骤二：添加联盟成员
### 删除
fabric-ca-client affiliation list -M ./crypto-config/peerOrganizations/org1.example.com/tlstmp -u http://admin:adminpw@localhost:8055 --home ./fabric-ca-client
fabric-ca-client affiliation remove --force org1 -M ./crypto-config/peerOrganizations/org1.example.com/tlstmp -u http://admin:adminpw@localhost:8055 --home ./fabric-ca-client
### 添加
fabric-ca-client affiliation add com -M ./crypto-config/peerOrganizations/org1.example.com/tlstmp -u http://admin:adminpw@localhost:8055 --home ./fabric-ca-client
fabric-ca-client affiliation add com.example -M ./crypto-config/peerOrganizations/org1.example.com/tlstmp -u http://admin:adminpw@localhost:8055 --home ./fabric-ca-client
fabric-ca-client affiliation add com.example.org1 -M ./crypto-config/peerOrganizations/org1.example.com/tlstmp -u http://admin:adminpw@localhost:8055 --home ./fabric-ca-client
######################################################################步骤三：生成Admin@example.com的tlstmp

### register
fabric-ca-client register 	--id.name Admin@org1.example.com \
							--id.type client \
							--id.affiliation "com.example.org1" \
							--id.attrs '"hf.Registrar.Roles=client,orderer,peer,user","hf.Registrar.DelegateRoles=client,orderer,peer,user",hf.Registrar.Attributes=*,hf.GenCRL=true,hf.Revoker=true,hf.AffiliationMgr=true,hf.IntermediateCA=true,role=admin:ecert' \
							--id.secret=123456 \
							--csr.cn=org1.example.com \
							--csr.hosts=['org1.example.com'] \
							-M ./crypto-config/peerOrganizations/org1.example.com/tlstmp \
							-u http://admin:adminpw@localhost:8055 --home ./fabric-ca-client

### enroll
fabric-ca-client enroll -d 	--enrollment.profile tls \
							-u http://Admin@org1.example.com:123456@localhost:8055 \
							--csr.cn=org1.example.com \
							--csr.hosts=['org1.example.com'] \
							-M ./crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tlstmp --home ./fabric-ca-client
######################################################################步骤四：生成tlstmp

###
mkdir 	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/

### cp tls ca
cp   /opt/go/src/Rootca/docker/cafile/ca-org1-tls.example.com/ca-chain.pem \
	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/ca.crt

###
cp 	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tlstmp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/client.crt

###
cp 	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tlstmp/keystore/*_sk \
	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/tls/client.key

######################################################################步骤五： 生成peer0.org1.example.com的tlstmp

### register
fabric-ca-client register 	--id.name peer0.org1.example.com \
							--id.type peer \
							--id.affiliation "com.example.org1" \
							--id.attrs '"role=peer",ecert=true' \
							--id.secret=123456 \
							--csr.cn=peer0.org1.example.com \
							--csr.hosts=['peer0.org1.example.com'] \
							-M ./crypto-config/peerOrganizations/org1.example.com/tlstmp \
							-u http://admin:adminpw@localhost:8055 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -d --enrollment.profile tls \
						-u http://peer0.org1.example.com:123456@localhost:8055 \
						--csr.cn=peer0.org1.example.com \
						--csr.hosts=['peer0.org1.example.com'] \
						-M ./crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tlstmp --home ./fabric-ca-client

### mkdir

mkdir  	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/

### cp tls ca
cp   /opt/go/src/Rootca/docker/cafile/ca-org1-tls.example.com/ca-chain.pem \
	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

cp 	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tlstmp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt

cp 	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tlstmp/keystore/*_sk \
	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key

######################################################################步骤六： 生成peer1.org1.example.com的tlstmp

### register
fabric-ca-client register 	--id.name peer1.org1.example.com \
							--id.type peer \
							--id.affiliation "com.example.org1" \
							--id.attrs '"role=peer",ecert=true' \
							--id.secret=123456 \
							--csr.cn=peer1.org1.example.com \
							--csr.hosts=['peer1.org1.example.com'] \
							-M ./crypto-config/peerOrganizations/org1.example.com/tlstmp \
							-u http://admin:adminpw@localhost:8055 --home ./fabric-ca-client
### enroll
 fabric-ca-client enroll -d --enrollment.profile tls \
							-u http://peer1.org1.example.com:123456@localhost:8055 \
							--csr.cn=peer1.org1.example.com \
							--csr.hosts=['peer1.org1.example.com'] \
							-M ./crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tlstmp \
							--home ./fabric-ca-client

######################################################################步骤七： tlstmp

###mkdir

mkdir  	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/

cp   /opt/go/src/Rootca/docker/cafile/ca-org1-tls.example.com/ca-chain.pem \
	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt

cp 	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tlstmp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt

cp 	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tlstmp/keystore/*_sk \
	./fabric-ca-client/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key
