FROM ubuntu:rolling
##copy over startup script
RUN apt update
RUN apt upgrade -y
RUN apt install rand -y
COPY startup.sh /
RUN rand | md5sum | head -c 20 > rootpass.txt
RUN echo $(cat /rootpass.txt)
RUN echo "root:$(cat /rootpass.txt)"|chpasswd
#RUN usermod --password $(cat /rootpass.txt) root
RUN echo root:$(cat /rootpass.txt) > /logininfo.txt

##create steam user for manageing pavlov instances
RUN useradd -m steam
RUN gpasswd -a steam sudo
RUN mkdir -p /home/steam/Steam
RUN chown -R steam:steam /home/steam


##update and install all dependent packages 
##zoneinfo, software properties, sudo, libc++, ssh, git,
##screen, sshpass, https for apt
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install software-properties-common sudo libc++1 ssh git wget screen sshpass apt-transport-https -y
RUN wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
##add multiverse repo and dotnet repo
RUN dpkg -i packages-microsoft-prod.deb
RUN add-apt-repository multiverse -y
RUN apt-get update -y
##install dotnet 5.0
RUN apt-get install -y dotnet-sdk-5.0
#enable i386 support for steamcmd
RUN dpkg --force-confold --add-architecture i386
##configure ssh to run on port 2222 and localhost only
RUN sed -i s/\#Port\ 22/Port\ 2222/ /etc/ssh/sshd_config
RUN sed -i s/\#ListenAddress\ 0.0.*/ListenAddress\ 127\.0\.0\.1/ /etc/ssh/sshd_config
RUN sed -i s/\#ListenAddress\ ::/ListenAddress\ ::1/ /etc/ssh/sshd_config
RUN sed -i s/\#PermitRootLogin\ prohibit-password/PermitRootLogin\ Yes/ /etc/ssh/sshd_config
RUN rand | md5sum | head -c 20 > steampass.txt
RUN echo "steam:$(cat steampass.txt)"|chpasswd
#RUN usermod --password $(cat steampass.txt) steam
RUN echo steam:$(cat steampass.txt) >> /logininfo.txt
RUN ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
RUN cp -r /root/.ssh /home/steam/.ssh
RUN cat /home/steam/.ssh/id_rsa.pub > /home/steam/.ssh/authorized_keys
RUN chmod 0600 /home/steam/.ssh/authorized_keys
RUN chown -R steam:steam /home/steam/.ssh
RUN echo ssh priv-key >> /logininfo.txt 
RUN cat ~/.ssh/id_rsa >> /logininfo.txt 
RUN rm -f steampass.txt rootpass.txt
RUN cat /logininfo.txt

##remove host keys, will be generated on container lunch
RUN /bin/rm -v /etc/ssh/ssh_host_*
#needed public ports
EXPOSE 7777
EXPOSE 8177
EXPOSE 9100

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/startup.sh" ]

