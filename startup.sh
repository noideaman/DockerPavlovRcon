#/bin/bash
cd /
if [ -d "/PavlovRconWebserver/" ]
then
        cd /PavlovRconWebserver/
        git pull
        cd /
else
        git clone https://github.com/devinSpitz/PavlovRconWebserver.git
fi
cd /PavlovRconWebserver/PavlovRconWebserver/
dotnet publish -c release -o /build --runtime linux-x64 --self-contained true --framework net5.0
cd /build/
[ ! -f Database/Database.db ] && cp /PavlovRconWebserver/PavlovRconWebserver/DefaultDB/Database.db /build/Database/Database.db
export ASPNETCORE_ENVIRONMENT=Development
[ ! -f appsettings.Production.json ] && cp /PavlovRconWebserver/PavlovRconWebserver/appsettings.Development.json /build/appsettings.Production.json
ln -s /build/appsettings.Production.json /build/appsettings..json
cd /

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
service ssh restart
service pavlov start
service pavlovrcon start
echo ""
echo ""
echo ""
echo steampassword $newpass
echo ""
echo ""
echo ""
echo ""
echo ssh private key $(cat /root/.ssh/id_rsa)
/bin/bash
