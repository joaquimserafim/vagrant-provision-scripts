#!/bin/bash

echo "#install 'n' a Node version management"

apt-get install -y g++ 1> /dev/null 2>&1
g++ --version | sed -n 1p

echo "git clone n"
rm -rf /home/vagrant/n
git clone -q https://github.com/tj/n.git /home/vagrant/n 1> /dev/null 2>&1

cd /home/vagrant/n
make install 1> /dev/null 2>&1
n stable 1> /dev/null 2>&1
echo "n version `n --version`"
echo "node.js version `node -v`"
echo "npm version `npm --version`"
