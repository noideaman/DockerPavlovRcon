#!/bin/bash
sudo chown -R steam:steam /home/steam
/usr/games/steamcmd +login anonymous +force_install_dir "/home/steam/pavlovserver" +app_update 622970 +exit
sudo chown -R steam:steam /home/steam
/usr/games/steamcmd +login anonymous +force_install_dir "/home/steam/pavlovserver" +app_update 1007 +quit
sudo chown -R steam:steam /home/steam
mkdir -p /home/steam/pavlovserver/pavlovserver/Pavlov/Binaries/Linux/
sudo chown -R steam:steam /home/steam
mkdir -p /home/steam/pavlovserver/.steam/sdk64
sudo chown -R steam:steam /home/steam
chmod +x /home/steam/pavlovserver/pavlovserver/PavlovServer.sh
sudo chown -R steam:steam /home/steam
cp /home/steam/pavlovserver/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/steam/pavlovserver/.steam/sdk64/steamclient.so
sudo chown -R steam:steam /home/steam
cp /home/steam/pavlovserver/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/steam/pavlovserver/pavlovserver/Pavlov/Binaries/Linux/steamclient.so
sudo chown -R steam:steam /home/steam
cd /home/steam/pavlovserver
./PavlovServer.sh

