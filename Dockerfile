FROM ubuntu:rolling
#copy over needed scripts and init.d services
COPY startup.sh /
COPY startpavlov.sh /
COPY pavlov /etc/init.d/
COPY pavlovrcon /etc/init.d/
COPY installsteam.sh /
#create steam user for manageing pavlov instances
RUN useradd -m steam
RUN gpasswd -a steam sudo
RUN mkdir -p /home/steam/Steam
RUN chown -R steam:steam /home/steam
#update and install all dependent packages 
#zoneinfo, software properties, sudo, libc++, ssh, git,
#screen, sshpass, https for apt
RUN apt update
RUN apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install software-properties-common sudo libc++1 ssh git wget screen sshpass apt-transport-https -y
RUN wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
#add multiverse repo and dotnet repo
RUN dpkg -i packages-microsoft-prod.deb
RUN add-apt-repository multiverse -y
RUN apt-get update -y
#install dotnet 5.0
RUN apt-get install -y dotnet-sdk-5.0
#enable i386 support for steamcmd
RUN dpkg --force-confold --add-architecture i386
#install steamcmd from multiverse repo, script used to help auto accept prompts
RUN /installsteam.sh
#configure ssh to run on port 2222 and localhost only
RUN sed -i s/\#Port\ 22/Port\ 2222/ /etc/ssh/sshd_config
RUN sed -i s/\#ListenAddress\ 0.0.*/ListenAddress\ 127\.0\.0\.1/ /etc/ssh/sshd_config
RUN sed -i s/\#ListenAddress\ ::/ListenAddress\ ::1/ /etc/ssh/sshd_config
#remove host keys, will be generated on container lunch
RUN /bin/rm -v /etc/ssh/ssh_host_*
#needed public ports
EXPOSE 7777
EXPOSE 8177
EXPOSE 9100

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/startup.sh" ]

