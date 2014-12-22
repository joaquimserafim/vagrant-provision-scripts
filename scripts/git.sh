#!/bin/bash

OP="install git"

echo "# $OP"

START=$(date +%s)

apt-get install -y git 1> /dev/null 2>&1
git --version

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "´$OP´ took $DIFF seconds"