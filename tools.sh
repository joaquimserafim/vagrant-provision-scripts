#!/bin/bash

echo "#install some tools"

apt-get install -y git > /dev/null
git --version

apt-get install -y htop > /dev/null
htop --version | sed -n 1p
