#!/bin/bash

path=$(dirname $0)

info() {
  echo '[INFO] ' "$@"
}
warn() {
  echo '[WARN] ' "$@" >&2
}
fatal() {
  echo '[ERROR] ' "$@" >&2
  exit 1
}

unDeploy_docker() {
  warn "start unInstall Docker"
  systemctl stop docker && systemctl disable docker
  yum remove -y docker docker-common docker-ce-cli docker-selinux docker-engine docker-ce container-selinux  docker-ce-selinux
  rm -rf /var/lib/docker /etc/docker /etc/sysconfig/docker

}
unDeploy_etcd() {
  warn "start unInstall ETCD"
  systemctl stop etcd && systemctl disable etcd

}
unDeploy_k3s() {
  warn "start unInstall K3S"
  systemctl stop k3s && systemctl disable k3s

}

#unDeploy_blog(){
#  warn "start unInstall K3S"
#}
