### 操作指南

#### 本项目是二级中间ca颁发证书。

容器结构：
    根    ca-master.example.com:根ca
    中间  ca-order-msp.example.com:orderer的msp ca
    中间  ca-org1-msp.example.com:org1的msp ca
    中间  ca-org2-msp.example.com:org2的msp ca
    中间  ca-order-tls.example.com:orderer的tls ca
    中间  ca-org1-tls.example.com:org1的tls ca
    中间  ca-org2-tls.example.com:org2的tls ca

 网络结构：
    orderer 5个： orderer0    orderer1    orderer2    orderer3    orderer4

    peer  4个    org1.peer0  org1.peer1  org2.peer0  org2.peer1

    ca    7个    ca-master   ca-order-msp    ca-order-tls    ca-org1-msp     ca-org1-tls     ca-org2-msp     ca-org2-tls


 启动流程：
 1. 启动ca容器 ：docker-compose -f docker-compose-ca.yaml -p ca up -d

    :-p 指定网络环境
    ：up 启动
    ：-d 守护模式

 2. 注册证书，并生成网络结构：./start.sh



 看这里看这里看这里：直接启动 ./start.sh




