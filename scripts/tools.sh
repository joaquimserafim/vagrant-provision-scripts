#!/bin/bash

echo "#install some tools"

apt-get install -y git 1> /dev/null 2>&1
git --version

apt-get install -y htop 1> /dev/null 2>&1
htop --version | sed -n 1p

rm -rf jq
wget http://stedolan.github.io/jq/download/linux64/jq 1> /dev/null 2>&1
chmod +x jq 1> /dev/null 2>&1
mv jq /usr/bin/ 1> /dev/null 2>&1
jq --version
