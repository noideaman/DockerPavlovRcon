#/bin/bash
#download the latest release of PavlovRconWebserver
cd /
#if exists grab latest version, else download fresh version
if [ -d "/PavlovRconWebserver/" ]
then
        cd /PavlovRconWebserver/
        git pull
        cd /
else
        git clone https://github.com/devinSpitz/PavlovRconWebserver.git
fi
#cd into directory and build latest version
cd /PavlovRconWebserver/PavlovRconWebserver/
dotnet publish -c release -o /build --runtime linux-x64 --self-contained true --framework net5.0
cd /build/
#copy default database if not existant
[ ! -f Database/Database.db ] && cp /PavlovRconWebserver/PavlovRconWebserver/DefaultDB/Database.db /build/Database/Database.db
#plan to set this to a docker enviroment var
export ASPNETCORE_ENVIRONMENT=Development
#copy the develponent.json to production.json also create a symlink as for some reason it looks for appsettings..json
#instead of appsettings.Production.json
[ ! -f appsettings.Production.json ] && cp /PavlovRconWebserver/PavlovRconWebserver/appsettings.Development.json /build/appsettings.Production.json
ln -s /build/appsettings.Production.json /build/appsettings..json
cd /
#ssh host and client keys are deleted by default in container to prep for shiping
#generate new host keys if non-existant
#set a random password for the steam user
#install the ssh client key to the steam user
if [ ! -f /etc/ssh/ssh_host_dsa_key ]
then
    dpkg-reconfigure openssh-server
    service ssh start
    ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
    newpass=$(echo $RANDOM | md5sum | head -c 20; echo;)
    usermod --password $newpass steam
    echo $newpass > sshpass.txt
    sshpass -f sshpass.txt ssh-copy-id -p 2222 steam@localhost
    rm -f sshpass.txt
fi
#start services, pavlov should be removed once pavlovrcon supports ubuntu init.d service files
service ssh restart
service pavlov start
service pavlovrcon start
#output the steam generated password and private key so rcon can be configured to use it
#add plans to pre-populate the database with this info
echo ""
echo ""
echo ""
echo steampassword $newpass
echo ""
echo ""
echo ""
echo ""
echo ssh private key $(cat /root/.ssh/id_rsa)
#start sleep so the container does not exit and restart
sleep infinity
