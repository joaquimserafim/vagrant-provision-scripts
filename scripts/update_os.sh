#!/bin/bash

apt-get update 1> /dev/null 2>&1
apt-get dist-upgrade -y 1> /dev/null 2>&1
apt-get install -y language-pack-en 1> /dev/null 2>&1
