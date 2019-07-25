#!/usr/bin/env bash
echo "create ca_tls_orderer.sh starting"
######################################################################步骤一：启动 ca
echo "步骤一：启动 tls_ca"
fabric-ca-client enroll -M ./crypto-config/ordererOrganizations/example.com/tls -u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
######################################################################步骤二：添加联盟成员

echo "步骤二：添加联盟成员"
fabric-ca-client affiliation list -M ./crypto-config/ordererOrganizations/example.com/tls -u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
fabric-ca-client affiliation remove --force org1 -M ./crypto-config/ordererOrganizations/example.com/tls -u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
fabric-ca-client affiliation remove --force org2 -M ./crypto-config/ordererOrganizations/example.com/tls -u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
fabric-ca-client affiliation add com -M ./crypto-config/ordererOrganizations/example.com/tls -u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
fabric-ca-client affiliation add com.example -M ./crypto-config/ordererOrganizations/example.com/tls -u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client

######################################################################步骤三：生成Admin@example.com的tls
echo "步骤三：生成Admin@example.com的tls"
### register
fabric-ca-client register 	--id.name Admin@example.com \
							--id.type client \
							--id.affiliation "com.example" \
							--id.attrs '"hf.Registrar.Roles=client,orderer,peer,user","hf.Registrar.DelegateRoles=client,orderer,peer,user",hf.Registrar.Attributes=*,hf.GenCRL=true,hf.Revoker=true,hf.AffiliationMgr=true,hf.IntermediateCA=true,role=admin:ecert' \
							--id.secret=123456 \
							--csr.cn=example.com \
							--csr.hosts=['example.com'] \
							-M ./crypto-config/ordererOrganizations/example.com/tlstmp \
							-u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -d --enrollment.profile tls \
						-u http://Admin@example.com:123456@localhost:7055 \
						--csr.cn=example.com \
						--csr.hosts=['example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/users/Admin@example.com/tlstmp --home ./fabric-ca-client

###
mkdir  ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/tls/

### cp   Admin@example.com/tls/ca.crt todo
cp  /opt/go/src/Rootca/docker/cafile/ca-order-tls.example.com/ca-chain.pem \
   ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/tls/ca.crt

### cp  Admin@example.com/tls/client.crt
cp 	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/tlstmp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/tls/client.crt

### cp  Admin@example.com/tls/client.key
cp 	 ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/tlstmp/keystore/*_sk \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/tls/client.key

### cp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/tlstmp/tlscacerts ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/tlstmp/tlsintermediatecerts ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/msp
######################################################################步骤四： 生成orderer0.example.com的tls

### register
fabric-ca-client register 	--id.name orderer0.example.com \
							--id.type orderer --id.affiliation "com.example" \
							--id.attrs '"role=orderer",ecert=true' \
							--id.secret=123456 \
							--csr.cn=orderer0.example.com \
							--csr.hosts=['orderer0.example.com'] \
							-M ./crypto-config/ordererOrganizations/example.com/tlstmp \
							-u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -d --enrollment.profile tls \
						-u http://orderer0.example.com:123456@localhost:7055 \
						--csr.cn=orderer0.example.com \
						--csr.hosts=['orderer0.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tlstmp --home ./fabric-ca-client
### mkdir
mkdir	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/

### cp   Admin@example.com/tls/ca.crt todo
cp   /opt/go/src/Rootca/docker/cafile/ca-order-tls.example.com/ca-chain.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/ca.crt

cp 	 ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tlstmp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/server.crt

cp 	 ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tlstmp/keystore/*_sk \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tls/server.key

###cp msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tlstmp/tlscacerts ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/tlstmp/tlsintermediatecerts  ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp

######################################################################步骤五： 生成orderer1.example.com的tls

### register
fabric-ca-client register 	--id.name orderer1.example.com \
							--id.type orderer --id.affiliation "com.example" \
							--id.attrs '"role=orderer",ecert=true' \
							--id.secret=123456 \
							--csr.cn=orderer1.example.com \
							--csr.hosts=['orderer1.example.com'] \
							-M ./crypto-config/ordererOrganizations/example.com/tlstmp \
							-u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -d --enrollment.profile tls \
						-u http://orderer1.example.com:123456@localhost:7055 \
						--csr.cn=orderer1.example.com \
						--csr.hosts=['orderer1.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tlstmp --home ./fabric-ca-client

### mkdir
mkdir  	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/
### 生成tls
### cp   orderer1.example.com/tls/ca.crt todo
cp   /opt/go/src/Rootca/docker/cafile/ca-order-tls.example.com/ca-chain.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/ca.crt


cp 	 ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tlstmp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.crt

cp 	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tlstmp/keystore/*_sk \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.key

### cp msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tlstmp/tlscacerts ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/tlstmp/tlsintermediatecerts  ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp

######################################################################步骤六： 生成orderer2.example.com的tls

### register
fabric-ca-client register 	--id.name orderer2.example.com \
							--id.type orderer --id.affiliation "com.example" \
							--id.attrs '"role=orderer",ecert=true' \
							--id.secret=123456 \
							--csr.cn=orderer2.example.com \
							--csr.hosts=['orderer2.example.com'] \
							-M ./crypto-config/ordererOrganizations/example.com/tlstmp \
							-u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -d --enrollment.profile tls \
						-u http://orderer2.example.com:123456@localhost:7055 \
						--csr.cn=orderer2.example.com \
						--csr.hosts=['orderer2.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tlstmp --home ./fabric-ca-client
### mkdir
mkdir  	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/

### cp   orderer2.example.com/tls/ca.crt todo
cp    /opt/go/src/Rootca/docker/cafile/ca-order-tls.example.com/ca-chain.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt

cp  	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tlstmp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt

cp 	 ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tlstmp/keystore/*_sk \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

### cp msp

cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tlstmp/tlscacerts ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tlstmp/tlsintermediatecerts  ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp

######################################################################步骤六： 生成orderer3.example.com的tls

### register
fabric-ca-client register 	--id.name orderer3.example.com \
							--id.type orderer --id.affiliation "com.example" \
							--id.attrs '"role=orderer",ecert=true' \
							--id.secret=123456 \
							--csr.cn=orderer3.example.com \
							--csr.hosts=['orderer3.example.com'] \
							-M ./crypto-config/ordererOrganizations/example.com/tlstmp \
							-u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -d --enrollment.profile tls \
						-u http://orderer3.example.com:123456@localhost:7055 \
						--csr.cn=orderer3.example.com \
						--csr.hosts=['orderer3.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tlstmp --home ./fabric-ca-client

### mkdir
mkdir  	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/

### cp   orderer3.example.com/tls/ca.crt todo
cp   /opt/go/src/Rootca/docker/cafile/ca-order-tls.example.com/ca-chain.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt

cp 	 ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tlstmp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt

cp 	 ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tlstmp/keystore/*_sk \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

### cp msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tlstmp/tlscacerts ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tlstmp/tlsintermediatecerts  ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp

######################################################################步骤六： 生成orderer4.example.com的tls

### register
fabric-ca-client register 	--id.name orderer4.example.com \
							--id.type orderer --id.affiliation "com.example" \
							--id.attrs '"role=orderer",ecert=true' \
							--id.secret=123456 \
							--csr.cn=orderer4.example.com \
							--csr.hosts=['orderer4.example.com'] \
							-M ./crypto-config/ordererOrganizations/example.com/tlstmp \
							-u http://admin:adminpw@localhost:7055 --home ./fabric-ca-client
### enroll
fabric-ca-client enroll -d --enrollment.profile tls \
						-u http://orderer4.example.com:123456@localhost:7055 \
						--csr.cn=orderer4.example.com \
						--csr.hosts=['orderer4.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/tlstmp --home ./fabric-ca-client

### mkdir
mkdir  	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/

### cp   orderer1.example.com/tls/ca.crt todo
cp    /opt/go/src/Rootca/docker/cafile/ca-order-tls.example.com/ca-chain.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/ca.crt

cp 	 ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/tlstmp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/server.crt

cp 	 ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/tlstmp/keystore/*_sk \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/server.key

### cp msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/tlstmp/tlscacerts ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/msp
cp -r ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/tlstmp/tlsintermediatecerts  ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/msp
