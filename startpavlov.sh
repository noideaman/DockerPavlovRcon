#!/bin/bash
/usr/games/steamcmd +login anonymous +force_install_dir "/home/steam/pavlovserver" +app_update 622970 +exit
/usr/games/steamcmd +login anonymous +force_install_dir "/home/steam/pavlovserver" +app_update 1007 +quit
mkdir -p /home/steam/pavlovserver/pavlovserver/Pavlov/Binaries/Linux/
mkdir -p /home/steam/pavlovserver/.steam/sdk64
chmod +x /home/steam/pavlovserver/pavlovserver/PavlovServer.sh
cp /home/steam/pavlovserver/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/steam/pavlovserver/.steam/sdk64/steamclient.so
cp /home/steam/pavlovserver/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/steam/pavlovserver/pavlovserver/Pavlov/Binaries/Linux/steamclient.so
cd /home/steam/pavlovserver
./PavlovServer.sh

