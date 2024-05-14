#!/bin/bash 
rm -rf install.tar.gz
tar --exclude=data/redis --exclude=data/leveldb --exclude=data/mysql/data -cpvzf install.tar.gz docker-compose.yaml data conf
