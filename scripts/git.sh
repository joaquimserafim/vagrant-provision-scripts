#!/bin/bash

echo "#install git"

apt-get install -y git 1> /dev/null 2>&1
git --version