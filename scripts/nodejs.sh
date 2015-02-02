#!/bin/bash

apt-get install -y g++ 1> /dev/null 2>&1
g++ --version | sed -n 1p
rm -rf /home/vagrant/n
git clone -q https://github.com/tj/n.git /home/vagrant/n 1> /dev/null 2>&1

cd /home/vagrant/n
make install 1> /dev/null 2>&1
n stable 1> /dev/null 2>&1

echo "spin=false\nloglevel=http" > ~/.npmrc

echo "n version `n --version`"
echo "node version `node -v`"
echo "npm version `npm --version`"
