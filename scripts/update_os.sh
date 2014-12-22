#!/bin/bash

OP="update OS"

echo "# $OP"

START=$(date +%s)

apt-get update 1> /dev/null 2>&1
apt-get upgrade -y 1> /dev/null 2>&1
apt-get install -y language-pack-en 1> /dev/null 2>&1

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "´$OP´ took $DIFF seconds"