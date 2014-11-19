#!/bin/bash

echo "#install 'n' a Node version management"

apt-get install -y g++ > /dev/null
g++ --version | sed -n 1p

echo "git clone n"
rm -rf /home/vagrant/n
git clone -q https://github.com/tj/n.git /home/vagrant/n > /dev/null

cd /home/vagrant/n
make install > /dev/null
n stable > /dev/null
echo "n version `n --version`"
echo "node.js version `node -v`"
echo "npm version `npm --version`"
