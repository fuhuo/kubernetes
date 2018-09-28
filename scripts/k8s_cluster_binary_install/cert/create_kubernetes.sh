#!/bin/bash

source ../00_cluster_env.sh

# 创建证书签名请求
mkdir /root/kubernetes
cat > /root/kubernetes/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "127.0.0.1",
    "${MASTER1}",
    "${MASTER2}",
    "${MASTER3}",
    "${MASTER_VIP}",
    "${CLUSTER_KUBERNETES_SVC_IP}",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "k8s",
      "OU": "4Paradigm"
    }
  ]
}
EOF


# 生成证书和私钥
cd /root/kubernetes
cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
  -ca-key=/etc/kubernetes/cert/ca-key.pem \
  -config=/etc/kubernetes/cert/ca-config.json \
  -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes


# 将生成的证书和私钥拷贝到所有 master 节点
cd /root/kubernetes
cp kubernetes*.pem  /etc/kubernetes/cert  && chown -R k8s  /etc/kubernetes/cert










