#!/bin/bash 
# chatgpt-plus deploy script
# By GeekMaster

sudo rm -rf install.tar.gz geekai

echo "You are installing chatgpt-plus-v3.2.7 source code：https://github.com/yangjian102621/chatgpt-plus"

source /etc/os-release
if [ "$ID" == "ubuntu" ]; then
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg -y
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    echo "Try to installing docker ..."
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
elif [ "$ID" == "centos" ]; then
    sudo yum remove docker \
                      docker-client \
                      docker-client-latest \
                      docker-common \
                      docker-latest \
                      docker-latest-logrotate \
                      docker-logrotate \
                      docker-engine -y

    echo "Try to installing docker ..."
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo "Unsupported operation system, ONLY support with Ubuntu or Centos"
    return
fi

echo "Try to download installation package..."
wget "https://img.r9it.com/geekai/v4.0.8/install.tar.gz" -O install.tar.gz

mkdir geekai
tar -xf install.tar.gz -C geekai

sudo echo '{
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://docker.nju.edu.cn",
        "https://dockerproxy.com"
    ]
}' >  /etc/docker/daemon.json 

sudo systemctl restart docker
cd geekai && docker-compose up -d 
