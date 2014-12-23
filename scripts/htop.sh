#!/bin/bash

apt-get install -y htop 1> /dev/null 2>&1
htop --version | sed -n 1p
