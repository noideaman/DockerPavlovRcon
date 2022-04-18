#!/bin/bash
#allow steam access to sudo with out password prompts
sed -i s/\%sudo.*// /etc/sudoers
echo "%sudo        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
#set debconf settings to skip prompts for steamcmd so the build proccess does not hang
echo steam steam/question select "I AGREE" | debconf-set-selections
echo steam steam/license note '' | debconf-set-selections
#install steamcmd and dependices
apt update -y
apt install lib32gcc-s1 steamcmd -y
