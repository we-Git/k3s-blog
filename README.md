# k3s-blog
该项目旨在使用k3s进行容器编排，针对机器规模不同，推出了单机与集群两种模式，且两种模式均可在离线环境部署。

项目中所涉及到的组件版本号如下：
k3s:
etcd:
docker:
mariadb:
wordpress:
测试机器系统：Centos7.4 1708；mini；内核3.10

单机模式
直接执行install.sh脚本安装即可，默认安装docker，不会安装etcd，若需要安装etcd，需传入参数etcd


集群模式
采用ansible部署，部署前需设置config.json文件，指定server与agent分别部署在哪些节点，若指定多个server，则至少需要3台机器
集群模式部署时执行ansible-ploybook deploy.yml