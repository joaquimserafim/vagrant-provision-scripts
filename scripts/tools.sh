#!/bin/bash

echo "#install some tools"

apt-get install -y git 1> /dev/null 2>&1
git --version

apt-get install -y htop 1> /dev/null 2>&1
htop --version | sed -n 1p
