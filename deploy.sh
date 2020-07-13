#!/bin/bash

path=$(dirname $0)
source $path/unDeploy.sh

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

rollback() {
  case $1 in
  docker)
    unDeploy_docker
    ;;
  k3s)
    unDeploy_k3s
    ;;
  etcd)
    unDeploy_etcd
    ;;
  *)
    fatal "Incorrect executable $1"
    ;;
  esac
}

deploy_docker() {
  rpm -ivh $path/ansible/roles/docker/files/*.rpm --force
  if [ ! -d /etc/docker ]; then
    echo "not exist"
    mkdir /etc/docker
  fi
  cp $path/ansible/roles/docker/template/daemon.json /etc/docker/daemon.json
  cp $path/ansible/roles/docker/template/docker.service /usr/lib/systemd/system/docker.service
  cp $path/ansible/roles/docker/template/docker /etc/sysconfig/docker
  systemctl daemon-reload && systemctl enable docker && systemctl restart docker
  if [ $? -eq 0 ]; then
    info "Docker install success"
  else
    fatal "Docker install failed,start rollback"
    rollback docker
  fi
}

load_image() {
  info "Load images for k3s"
  docker load -i $path/ansible/roles/k3s/files/k3s-airgap-images-amd64.tar
}

deploy_k3s() {
  /bin/cp -f $path/ansible/roles/k3s/files/k3s /usr/local/bin/
  chmod 755 /usr/local/bin/k3s
  rpm -ivh $path/ansible/roles/k3s/files/selinux/*.rpm --force
  bash $path/install.sh
  if [ $? -eq 0 ]; then
    systemctl stop k3s
    sed -i "s/server/server --docker/g" /etc/systemd/system/k3s.service
    systemctl daemon-reload && systemctl start k3s
  else
    fatal "K3S deploy failed,start rollback..."
    rollback k3s
    exit 1
  fi

}
deploy_blog() {
  echo ""
}
{
  #  deploy_docker
  #  load_image
  #  deploy_k3s
  unDeploy_docker
}
