#!/bin/bash
sed -i s/\%sudo.*// /etc/sudoers
echo "%sudo        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
echo steam steam/question select "I AGREE" | debconf-set-selections
echo steam steam/license note '' | debconf-set-selections
apt update -y
apt install lib32gcc-s1 steamcmd -y
