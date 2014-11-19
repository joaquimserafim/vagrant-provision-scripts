#!/bin/bash

echo "#update OS"

apt-get update > /dev/null
apt-get upgrade -y > /dev/null
