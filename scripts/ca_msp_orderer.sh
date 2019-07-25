#!/usr/bin/env bash
echo "create ca_msp_orderer.sh starting"
### example msp
#######################################################步骤一：为example.com准备msp##############################################
### get orderer msp  ca  admin
fabric-ca-client enroll -M ./crypto-config/ordererOrganizations/example.com/msp -u http://admin:adminpw@localhost:7056 --home ./fabric-ca-client

### 查看联盟
fabric-ca-client affiliation list -M ./crypto-config/ordererOrganizations/example.com/msp -u http://admin:adminpw@localhost:7056 --home ./fabric-ca-client

### 删除联盟
fabric-ca-client affiliation remove --force org1 -M ./crypto-config/ordererOrganizations/example.com/msp -u http://admin:adminpw@localhost:7056 --home ./fabric-ca-client
fabric-ca-client affiliation remove --force org2 -M ./crypto-config/ordererOrganizations/example.com/msp -u http://admin:adminpw@localhost:7056 --home ./fabric-ca-client

### 添加联盟
fabric-ca-client affiliation add com -M ./crypto-config/ordererOrganizations/example.com/msp -u http://admin:adminpw@localhost:7056 --home ./fabric-ca-client
fabric-ca-client affiliation add com.example -M ./crypto-config/ordererOrganizations/example.com/msp -u http://admin:adminpw@localhost:7056 --home ./fabric-ca-client

#######################################################步骤二：注册example.com的管理员Admin@example.com###########################
### 注册 admin register
fabric-ca-client register --id.name Admin@example.com \
						  --id.type client \
						  --id.affiliation "com.example" \
						  --id.attrs '"hf.Registrar.Roles=client,orderer,peer,user","hf.Registrar.DelegateRoles=client,orderer,peer,user",hf.Registrar.Attributes=*,hf.GenCRL=true,hf.Revoker=true,hf.AffiliationMgr=true,hf.IntermediateCA=true,role=admin:ecert' \
						  --id.secret=123456 \
						  --csr.cn=example.com \
						  --csr.hosts=['example.com'] \
						  -M ./crypto-config/ordererOrganizations/example.com/msp \
						  -u http://admin:adminpw@localhost:7056 \
						  --home ./fabric-ca-client

### 登记 下载证书 admin enroll
fabric-ca-client enroll -u http://Admin@example.com:123456@localhost:7056 \
						--csr.cn=example.com \
						--csr.hosts=['example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp --home ./fabric-ca-client

### 创建目录 users Admin
mkdir ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/admincerts

### 拷贝 证书至管理员目录.这样这个证书才能是管理员证书，其实他的证书的本质是一样，只是说联盟链的管理员目录要这样一个证书，谁到这个位置就是
cp 	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/admincerts

### 创建目录 msp  Admin
mkdir ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/msp/admincerts

### 拷贝
cp 	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/msp/admincerts

#######################################################步骤三：为orderer0.example.com准备msp###########################

### 注册msp register orderer0
fabric-ca-client register --id.name orderer0.example.com \
						  --id.type orderer \
						  --id.affiliation "com.example" \
						  --id.attrs '"role=orderer",ecert=true' \
						  --id.secret=123456 \
						  --csr.cn=orderer0.example.com \
						  --csr.hosts=['orderer0.example.com'] \
						  -M ./crypto-config/ordererOrganizations/example.com/msp \
						  -u http://admin:adminpw@localhost:7056 \
						  --home ./fabric-ca-client
### enroll msp
fabric-ca-client enroll -u http://orderer0.example.com:123456@localhost:7056 \
						--csr.cn=orderer0.example.com \
						--csr.hosts=['orderer0.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp \
						--home ./fabric-ca-client

### 创建拷贝目录
mkdir ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/admincerts

### 拷贝
cp 	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/admincerts

#######################################################步骤四：为orderer1.example.com准备msp###########################

### 注册msp register
fabric-ca-client register --id.name orderer1.example.com \
						  --id.type orderer \
						  --id.affiliation "com.example" \
						  --id.attrs '"role=orderer",ecert=true' \
						  --id.secret=123456 \
						  --csr.cn=orderer1.example.com \
						  --csr.hosts=['orderer1.example.com'] \
						  -M ./crypto-config/ordererOrganizations/example.com/msp \
						  -u http://admin:adminpw@localhost:7056 \
						  --home ./fabric-ca-client
### enroll msp
fabric-ca-client enroll -u http://orderer1.example.com:123456@localhost:7056 \
						--csr.cn=orderer1.example.com \
						--csr.hosts=['orderer1.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp \
						--home ./fabric-ca-client
### 创建拷贝目录
mkdir ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/admincerts

### 拷贝
cp 	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/admincerts
#######################################################步骤四：为orderer2.example.com准备msp###########################

### 注册msp register
fabric-ca-client register --id.name orderer2.example.com \
						  --id.type orderer \
						  --id.affiliation "com.example" \
						  --id.attrs '"role=orderer",ecert=true' \
						  --id.secret=123456 \
						  --csr.cn=orderer2.example.com \
						  --csr.hosts=['orderer2.example.com'] \
						  -M ./crypto-config/ordererOrganizations/example.com/msp \
						  -u http://admin:adminpw@localhost:7056 \
						  --home ./fabric-ca-client
### enroll msp
fabric-ca-client enroll -u http://orderer2.example.com:123456@localhost:7056 \
						  --csr.cn=orderer2.example.com \
						  --csr.hosts=['orderer2.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp \
						--home ./fabric-ca-client
### 创建拷贝目录
mkdir ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/admincerts

### 拷贝
cp 	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/admincerts

#######################################################步骤四：为orderer3.example.com准备msp###########################

### 注册msp register
fabric-ca-client register --id.name orderer3.example.com \
						  --id.type orderer \
						  --id.affiliation "com.example" \
						  --id.attrs '"role=orderer",ecert=true' \
						  --id.secret=123456 \
						  --csr.cn=orderer3.example.com \
						  --csr.hosts=['orderer3.example.com'] \
						  -M ./crypto-config/ordererOrganizations/example.com/msp \
						  -u http://admin:adminpw@localhost:7056 \
						  --home ./fabric-ca-client
### enroll msp
fabric-ca-client enroll -u http://orderer3.example.com:123456@localhost:7056 \
						 --csr.cn=orderer3.example.com \
						 --csr.hosts=['orderer3.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp \
						--home ./fabric-ca-client
### 创建拷贝目录
mkdir ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/admincerts

### 拷贝
cp 	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/admincerts

#######################################################步骤四：为orderer4.example.com准备msp###########################

### 注册msp register
fabric-ca-client register --id.name orderer4.example.com \
						  --id.type orderer \
						  --id.affiliation "com.example" \
						  --id.attrs '"role=orderer",ecert=true' \
						  --id.secret=123456 \
						  --csr.cn=orderer4.example.com \
						  --csr.hosts=['orderer4.example.com'] \
						  -M ./crypto-config/ordererOrganizations/example.com/msp \
						  -u http://admin:adminpw@localhost:7056 --home ./fabric-ca-client
### enroll msp
fabric-ca-client enroll -u http://orderer4.example.com:123456@localhost:7056 \
						  --csr.cn=orderer4.example.com \
						  --csr.hosts=['orderer4.example.com'] \
						-M ./crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/msp --home ./fabric-ca-client
### 创建拷贝目录
mkdir ./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/msp/admincerts

### 拷贝
cp 	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/signcerts/cert.pem \
	./fabric-ca-client/crypto-config/ordererOrganizations/example.com/orderers/orderer4.example.com/msp/admincerts

echo "ca_msp_orderer  is  ok "
