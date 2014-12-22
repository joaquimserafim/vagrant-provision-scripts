#!/bin/bash

OP="install htop"

echo "# $OP"

START=$(date +%s)

apt-get install -y htop 1> /dev/null 2>&1
htop --version | sed -n 1p

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "´$OP´ took $DIFF seconds"