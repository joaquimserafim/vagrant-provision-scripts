#!/bin/bash

apt-get update 1> /dev/null 2>&1
apt-get upgrade -y 1> /dev/null 2>&1
apt-get install -y language-pack-en 1> /dev/null 2>&1
shutdown -r now 1> /dev/null 2>&1