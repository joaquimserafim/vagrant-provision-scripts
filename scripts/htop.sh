#!/bin/bash

apt-get install -y htop 1> /dev/null 2>&1
htop --version | grep -o "^htop [0-9].[0-9].[0-9]"
